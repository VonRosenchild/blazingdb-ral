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

static std::basic_string<int8_t> ConvertIpcByteArray (nvstrings_ipc_transfer ipc_data) {
  std::basic_string<int8_t> bytes;
  bytes.resize(sizeof(nvstrings_ipc_transfer));
  memcpy((void*)bytes.data(), (int8_t*)(&ipc_data), sizeof(nvstrings_ipc_transfer));
  return bytes;
}

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
    //table_names.push_back(table.name);
    //column_names.push_back(table.columnNames);

    std::vector<gdf_column_cpp> input_table;

    int column_index = 0;
    for(auto column : table.columns) {

      gdf_column_cpp col;

      if (table.columnTokens[column_index] == 0){
        //const std::string column_name = table.columnNames.at(column_index);
        const std::string column_name = "";
        
        if((::gdf_dtype)column.dtype == GDF_STRING){

          nvstrings_ipc_transfer ipc;  // NOTE: IPC handles will be closed when nvstrings_ipc_transfer goes out of scope
          memcpy(&ipc,column.custrings_data.data(),sizeof(nvstrings_ipc_transfer));

          NVStrings* strs = NVStrings::create_from_ipc(ipc);
          NVCategory* category = NVCategory::create_from_strings(*strs);
          NVStrings::destroy(strs);

          col.create_gdf_column(category, column.size, column_name);

        } else {
          if ((::gdf_dtype)column.dtype == GDF_STRING_CATEGORY) 
            std::cout<<"WARNING: incoming data is a GDF_STRING_CATEGORY"<<std::endl;

          // col.create_gdf_column_for_ipc((::gdf_dtype)column.dtype,libgdf::CudaIpcMemHandlerFrom(column.data),(gdf_valid_type*)libgdf::CudaIpcMemHandlerFrom(column.valid),column.size,column_name);
          void * dataHandle = libgdf::CudaIpcMemHandlerFrom(column.data);
          void * validHandle = libgdf::CudaIpcMemHandlerFrom(column.valid);
          col.create_gdf_column_for_ipc((::gdf_dtype)column.dtype,dataHandle,
                                          static_cast<gdf_valid_type*>(validHandle), column.size, column.null_count, column_name);
          handles.push_back(dataHandle);
          if (validHandle != nullptr){
            handles.push_back(validHandle);
          }
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
