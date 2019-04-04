#pragma once

#include <tuple>

#include <cuda_runtime.h>

#include <blazingdb/protocol/message/messages.h>
#include <blazingdb/protocol/message/interpreter/messages.h>
#include "Utils.cuh"
#include "ResultSetRepository.h"
#include "DataFrame.h"
#include <nvstrings/NVStrings.h>
#include <nvstrings/ipc_transfer.h>
#include "FreeMemory.h"

namespace libgdf {

static std::basic_string<int8_t> ConvertCudaIpcMemHandler (cudaIpcMemHandle_t ipc_memhandle) {
  std::basic_string<int8_t> bytes;
  bytes.resize(sizeof(cudaIpcMemHandle_t));
  memcpy((void*)bytes.data(), (int8_t*)(&ipc_memhandle), sizeof(cudaIpcMemHandle_t));
  return bytes;
}

static cudaIpcMemHandle_t ConvertByteArray (std::basic_string<int8_t>& bytes) {
  cudaIpcMemHandle_t ipc_memhandle;
  memcpy((int8_t*)&ipc_memhandle, bytes.data(), sizeof(cudaIpcMemHandle_t));
  return ipc_memhandle;
}

static std::basic_string<int8_t> BuildCudaIpcMemHandler (void *data) {
  FreeMemory::registerIPCPointer(data);
  std::basic_string<int8_t> bytes;
  if (data != nullptr) {
    cudaIpcMemHandle_t ipc_memhandle;
    CheckCudaErrors(cudaIpcGetMemHandle((cudaIpcMemHandle_t *) &ipc_memhandle, (void *) data));

    bytes.resize(sizeof(cudaIpcMemHandle_t));
    memcpy((void*)bytes.data(), (int8_t*)(&ipc_memhandle), sizeof(cudaIpcMemHandle_t));

  }
  return bytes;
}

static void* CudaIpcMemHandlerFrom (const std::basic_string<int8_t>& handler) {
  void * response = nullptr;
  std::cout << "handler-content: " <<  handler.size() <<  std::endl;
  if (handler.size() == 64) {
    cudaIpcMemHandle_t ipc_memhandle;
    memcpy((int8_t*)&ipc_memhandle, handler.data(), sizeof(ipc_memhandle));
    CheckCudaErrors(cudaIpcOpenMemHandle((void **)&response, ipc_memhandle, cudaIpcMemLazyEnablePeerAccess));
  }
  return response;
}

std::tuple<std::vector<std::vector<gdf_column_cpp>>,
           std::vector<std::string>,
           std::vector<std::vector<std::string>>> toBlazingDataframe(uint64_t accessToken, const ::blazingdb::protocol::TableGroupDTO& request,std::vector<void *> & handles)
{
  std::vector<std::vector<gdf_column_cpp>> input_tables;
  std::vector<std::string> table_names;
  std::vector<std::vector<std::string>> column_names;

  for(auto table : request.tables) {
    table_names.push_back(table.name);
    column_names.push_back(table.columnNames);

    std::vector<gdf_column_cpp> input_table;

    int column_index = 0;
    for(auto column : table.columns) {

      gdf_column_cpp col;

      if (table.columnTokens[column_index] == 0){
        const std::string column_name = table.columnNames.at(column_index);
        
        if((::gdf_dtype)column.dtype == GDF_STRING){

          nvstrings_ipc_transfer ipc;
          ipc.hstrs = ConvertByteArray(column.dtype_info.custrings_views); // cudaIpcMemHandle_t
          ipc.count = column.dtype_info.custrings_views_count; // unsigned int
          ipc.hmem = ConvertByteArray(column.dtype_info.custrings_membuffer); // cudaIpcMemHandle_t
          ipc.size = column.dtype_info.custrings_membuffer_size; // size_t
          ipc.base_address = reinterpret_cast<char*>(column.dtype_info.custrings_base_ptr); // char*

          NVStrings* strs = NVStrings::create_from_ipc(ipc);
          NVCategory* category = NVCategory::create_from_strings(*strs);

          col.create_gdf_column_for_ipc((::gdf_dtype)column.dtype, nullptr, nullptr, column.size, column_name, category);
        }
        else {
          // col.create_gdf_column_for_ipc((::gdf_dtype)column.dtype,libgdf::CudaIpcMemHandlerFrom(column.data),(gdf_valid_type*)libgdf::CudaIpcMemHandlerFrom(column.valid),column.size,column_name);
          col.create_gdf_column_for_ipc((::gdf_dtype)column.dtype,libgdf::CudaIpcMemHandlerFrom(column.data),nullptr,column.size,column_name);
          handles.push_back(col.data());
        }

        if(col.valid() == nullptr){
          //TODO: we can remove this when libgdf properly
          //implements all algorithsm with valid == nullptr support
          //it crashes somethings like group by
          col.allocate_set_valid();

        }else{
          handles.push_back(col.valid());
        }
      }else{
        col = result_set_repository::get_instance().get_column(accessToken, table.columnTokens[column_index]);
      }

      input_table.push_back(col);

      ++column_index;
    }

    input_tables.push_back(input_table);
  }

  return std::make_tuple(input_tables, table_names, column_names);
}

} //namespace libgdf
