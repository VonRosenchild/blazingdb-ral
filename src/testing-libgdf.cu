/*
 ============================================================================
 Name        : testing-libgdf.cu
 Author      : felipe
 Version     :
 Copyright   : Your copyright notice
 Description : MVP
 ============================================================================
 */

#include <cuda_runtime.h>
#include <memory>
#include <algorithm>
#include <thread>
#include "CalciteInterpreter.h"
#include "ResultSetRepository.h"
#include "DataFrame.h"
#include "Utils.cuh"
#include "Types.h"
#include <cuda_runtime.h>

#include "gdf_wrapper/gdf_wrapper.cuh"

#include <tuple>

#include <blazingdb/protocol/api.h>
#include <blazingdb/protocol/message/messages.h>
#include <blazingdb/protocol/message/interpreter/messages.h>
#include <blazingdb/protocol/message/io/file_system.h>
#include "ral-message.cuh"


using namespace blazingdb::protocol;

#include <blazingdb/io/Util/StringUtil.h>

#include <blazingdb/io/FileSystem/HadoopFileSystem.h>
#include <blazingdb/io/FileSystem/S3FileSystem.h>
#include <blazingdb/io/FileSystem/FileSystemRepository.h>
#include <blazingdb/io/FileSystem/FileSystemCommandParser.h>
#include <blazingdb/io/FileSystem/FileSystemManager.h>
#include <blazingdb/io/Config/BlazingContext.h>
#include <blazingdb/io/Library/Logging/Logger.h>
#include <blazingdb/io/Library/Logging/CoutOutput.h>
#include "blazingdb/io/Library/Logging/ServiceLogging.h"

#include "io/data_parser/CSVParser.h"
#include "io/data_provider/UriDataProvider.h"
#include "io/data_parser/DataParser.h"
#include "io/data_provider/DataProvider.h"

#include "Config/Config.h"

#include "CodeTimer.h"

const Path FS_NAMESPACES_FILE("/tmp/file_system.bin");
using result_pair = std::pair<Status, std::shared_ptr<flatbuffers::DetachedBuffer>>;
using FunctionType = result_pair (*)(uint64_t, Buffer&& buffer);
  
static result_pair  registerFileSystem(uint64_t accessToken, Buffer&& buffer)  {
  std::cout << "registerFileSystem: " << accessToken << std::endl;
  blazingdb::message::io::FileSystemRegisterRequestMessage message(buffer.data());

  FileSystemConnection fileSystemConnection;
  Path root("/");
  const std::string authority =  message.getAuthority();
  if (message.isLocal()) {
    fileSystemConnection = FileSystemConnection(FileSystemType::LOCAL);
  } else if (message.isHdfs()) {
    auto hdfs = message.getHdfs();
    fileSystemConnection = FileSystemConnection(hdfs.host, hdfs.port, hdfs.user, (HadoopFileSystemConnection::DriverType)hdfs.driverType, hdfs.kerberosTicket);
  } else if (message.isS3()) {
    auto s3 = message.getS3();
    fileSystemConnection = FileSystemConnection(s3.bucketName, ( S3FileSystemConnection::EncryptionType )s3.encryptionType, s3.kmsKeyAmazonResourceName, s3.accessKeyId, s3.secretKey, s3.sessionToken);
  }
  root = message.getRoot();
  if (root.isValid() == false) {
    std::cout << "something went wrong when registering filesystem ..." << std::endl;
    ResponseErrorMessage errorMessage{ std::string{ "ERROR: Invalid root provided when registering file system"} };
    return std::make_pair(Status_Error, errorMessage.getBufferData());
  }
  FileSystemEntity fileSystemEntity(authority, fileSystemConnection, root);

	const bool ok = BlazingContext::getInstance()->getFileSystemManager()->registerFileSystem(fileSystemEntity);
	if (ok) { // then save the fs
		const FileSystemRepository fileSystemRepository(FS_NAMESPACES_FILE, true);
		const bool saved = fileSystemRepository.add(fileSystemEntity);

		if (saved == false) {
			std::cout << "WARNING: could not save the registered file system into ... the data file uri ..."; //TODO percy error message
		}
	} else {
   	  std::cout << "something went wrong when registering filesystem ..." << std::endl;
      ResponseErrorMessage errorMessage{ std::string{"ERROR: Something went wrong when registering file system"} };
      return std::make_pair(Status_Error, errorMessage.getBufferData());
	}
  ZeroMessage response{};
  return std::make_pair(Status_Success, response.getBufferData());
}

static result_pair  deregisterFileSystem(uint64_t accessToken, Buffer&& buffer)  {
  std::cout << "deregisterFileSystem: " << accessToken << std::endl;
  blazingdb::message::io::FileSystemDeregisterRequestMessage message(buffer.data());
  auto authority =  message.getAuthority();
  if (authority.empty() == true) {
     ResponseErrorMessage errorMessage{ std::string{"derigistering an empty authority"} };
     return std::make_pair(Status_Error, errorMessage.getBufferData());
  }
  const bool ok = BlazingContext::getInstance()->getFileSystemManager()->deregisterFileSystem(authority);
  if (ok) { // then save the fs
    const FileSystemRepository fileSystemRepository(FS_NAMESPACES_FILE, true);
    const bool deleted = fileSystemRepository.deleteByAuthority(authority);
    if (deleted == false) {
      std::cout << "WARNING: could not delete the registered file system into ... the data file uri ..."; //TODO percy error message
    }
  }
  ZeroMessage response{};
  return std::make_pair(Status_Success, response.getBufferData());
}


query_token_t loadParquetAndInsertToResultRepository(std::string path, connection_id_t connection) {
	std::cout<<"loadParquet\n";

	query_token_t token = result_set_repository::get_instance().register_query(connection); //register the query so we can receive result requests for it

	std::thread t = std::thread([=]{
		CodeTimer blazing_timer;

		std::vector<Uri> uris(1);
		uris[0] = Uri(path);
		// auto provider = std::make_unique<ral::io::uri_data_provider>(uris);
		// auto parser = std::make_unique<ral::io::csv_parser>(delimiter, line_terminator, skip_rows, names, dtypes);
		// provider->has_next();

		// size_t num_cols = names.size();
		// std::vector<gdf_column_cpp> columns(num_cols);
		// std::vector<bool> include_column(num_cols, true);

		// parser->parse(provider->get_next(), columns, include_column);

    // // tests
	  // // for(size_t column_index = 0; column_index < num_cols; column_index++){
		// // 	Check<int>(columns[column_index]);
		// // }

		// blazing_frame output_frame;
  	// output_frame.add_table(columns);

		// double duration = blazing_timer.getDuration();
		// result_set_repository::get_instance().update_token(token, output_frame, duration);
	 });
	 t.detach();
	return token;
}

static result_pair loadParquet(uint64_t accessToken, Buffer&& buffer) {
  blazingdb::message::io::LoadCsvFileRequestMessage message(buffer.data());

  std::vector<gdf_dtype> types;
  for(auto val : message.dtypes)
    types.push_back( (gdf_dtype) val );


 uint64_t resultToken = 0L;
  try {
    // resultToken = loadCsvAndInsertToResultRepository(message.path, message.names, types, message.delimiter, message.line_terminator, message.skip_rows, accessToken);
  } catch (std::exception& error) {
     std::cout << error.what() << std::endl;
     ResponseErrorMessage errorMessage{ std::string{error.what()} };
     return std::make_pair(Status_Error, errorMessage.getBufferData());
  }
  interpreter::NodeConnectionDTO nodeInfo {
      .path = "/tmp/ral.socket",
      .type = NodeConnectionType {NodeConnectionType_IPC}
  };
  interpreter::ExecutePlanResponseMessage responsePayload{resultToken, nodeInfo};
  return std::make_pair(Status_Success, responsePayload.getBufferData());
}


using result_pair = std::pair<Status, std::shared_ptr<flatbuffers::DetachedBuffer>>;
using FunctionType = result_pair (*)(uint64_t, Buffer&& buffer);

static result_pair closeConnectionService(uint64_t accessToken, Buffer&& requestPayloadBuffer) {
  std::cout << "accessToken: " << accessToken << std::endl;

  try {
	result_set_repository::get_instance().remove_all_connection_tokens(accessToken);
  } catch (std::runtime_error &error) {
     std::cout << error.what() << std::endl;
     ResponseErrorMessage errorMessage{ std::string{error.what()} };
     return std::make_pair(Status_Error, errorMessage.getBufferData());
  }

  ZeroMessage response{};
  return std::make_pair(Status_Success, response.getBufferData());
}

static result_pair getResultService(uint64_t accessToken, Buffer&& requestPayloadBuffer) {
  std::cout << "accessToken: " << accessToken << std::endl;

  interpreter::GetResultRequestMessage request(requestPayloadBuffer.data());
  std::cout << "resultToken: " << request.getResultToken() << std::endl;


  // remove from repository using accessToken and resultToken
  std::tuple<blazing_frame, double> result = result_set_repository::get_instance().get_result(accessToken, request.getResultToken());

  //TODO ojo el result siempre es una sola tabla por eso indice 0
  const int rows = std::get<0>(result).get_columns()[0][0].size();

  interpreter::BlazingMetadataDTO  metadata = {
    .status = "OK",
    .message = "metadata message",
    .time = std::get<1>(result),
    .rows = rows
  };

  std::vector<std::string> fieldNames;
  std::vector<::gdf_dto::gdf_column> values;

  //TODO WARNING why 0 why multitables?
  for(int i = 0; i < std::get<0>(result).get_columns()[0].size(); ++i) {
	  fieldNames.push_back(std::get<0>(result).get_columns()[0][i].name());

	  auto data = libgdf::BuildCudaIpcMemHandler(std::get<0>(result).get_columns()[0][i].get_gdf_column()->data);
	  auto valid = libgdf::BuildCudaIpcMemHandler(std::get<0>(result).get_columns()[0][i].get_gdf_column()->valid);

	  auto col = ::gdf_dto::gdf_column {
	        .data = data,
	        .valid = valid,
	        .size = std::get<0>(result).get_columns()[0][i].size(),
	        .dtype = (gdf_dto::gdf_dtype)std::get<0>(result).get_columns()[0][i].dtype(),
	        .null_count = std::get<0>(result).get_columns()[0][i].null_count(),
	        .dtype_info = gdf_dto::gdf_dtype_extra_info {
	          .time_unit = (gdf_dto::gdf_time_unit)0,
	        }
	    };

	  values.push_back(col);
  }

//  // todo: remove hardcode by creating the resulset vector
//  gdf_column_cpp column = result.get_columns()[0][0];
//	std::cout<<"getResultService\n";
//  print_gdf_column(column.get_gdf_column());
//  std::cout<<"end:getResultService\n";
//
//  auto data = libgdf::BuildCudaIpcMemHandler(column.get_gdf_column()->data);
//  auto valid = libgdf::BuildCudaIpcMemHandler(column.get_gdf_column()->valid);
//
//  std::vector<::gdf_dto::gdf_column> values = {
//    ::gdf_dto::gdf_column {
//        .data = data,
//        .valid = valid,
//        .size = column.size(),
//        .dtype = (gdf_dto::gdf_dtype)column.dtype(),
//        .null_count = column.null_count(),
//        .dtype_info = gdf_dto::gdf_dtype_extra_info {
//          .time_unit = (gdf_dto::gdf_time_unit)0,
//        }
//    }
//  };

  interpreter::GetResultResponseMessage responsePayload(metadata, fieldNames, values);
  std::cout << "**before return data frame\n" << std::flush;
  return std::make_pair(Status_Success, responsePayload.getBufferData());
}

static result_pair freeResultService(uint64_t accessToken, Buffer&& requestPayloadBuffer) {
   std::cout << "freeResultService: " << accessToken << std::endl;

  interpreter::GetResultRequestMessage request(requestPayloadBuffer.data());
  std::cout << "resultToken: " << request.getResultToken() << std::endl;
  if(result_set_repository::get_instance().free_result(request.getResultToken())){
	  ZeroMessage response{};
	  return std::make_pair(Status_Success, response.getBufferData());
  }else{
	  ResponseErrorMessage errorMessage{ std::string{"Could not free result set!"} };
	  return std::make_pair(Status_Error, errorMessage.getBufferData());
  }

}

static result_pair executePlanService(uint64_t accessToken, Buffer&& requestPayloadBuffer)   {
  interpreter::ExecutePlanRequestMessage requestPayload(requestPayloadBuffer.data());

  // ExecutePlan
  std::cout << "accessToken: " << accessToken << std::endl;
  std::cout << "query: " << requestPayload.getLogicalPlan() << std::endl;
  std::cout << "tableGroup: " << requestPayload.getTableGroup().name << std::endl;
 	std::cout << "tables: " << requestPayload.getTableGroup().tables.size() << std::endl;
  std::cout << "tableSize: " << requestPayload.getTableGroup().tables.size() << std::endl;
	std::cout << "FirstColumnSize: "
			<< requestPayload.getTableGroup().tables[0].columns[0].size
			<< std::endl;
	  std::vector<void *> handles;
	std::tuple<std::vector<std::vector<gdf_column_cpp>>, std::vector<std::string>, std::vector<std::vector<std::string>>> request = libgdf::toBlazingDataframe(requestPayload.getTableGroup(),handles);

  uint64_t resultToken = 0L;
  try {
    resultToken = evaluate_query(std::get<0>(request), std::get<1>(request), std::get<2>(request),
                                        requestPayload.getLogicalPlan(), accessToken,handles);
  } catch (std::exception& error) {
     std::cout << error.what() << std::endl;
     ResponseErrorMessage errorMessage{ std::string{error.what()} };
     return std::make_pair(Status_Error, errorMessage.getBufferData());
  }
  interpreter::NodeConnectionDTO nodeInfo {
      .path = "/tmp/ral.socket",
      .type = NodeConnectionType {NodeConnectionType_IPC}
  };
  interpreter::ExecutePlanResponseMessage responsePayload{resultToken, nodeInfo};
  return std::make_pair(Status_Success, responsePayload.getBufferData());
}

int main(void)
{
	std::cout << "RAL Engine starting"<< std::endl;
  auto output = new Library::Logging::CoutOutput();
  Library::Logging::ServiceLogging::getInstance().setLogOutput(output);

  blazingdb::protocol::UnixSocketConnection connection({"/tmp/ral.socket", std::allocator<char>()});
  blazingdb::protocol::Server server(connection);

  std::map<int8_t, FunctionType> services;
  services.insert(std::make_pair(interpreter::MessageType_ExecutePlan, &executePlanService));
  services.insert(std::make_pair(interpreter::MessageType_CloseConnection, &closeConnectionService));
  services.insert(std::make_pair(interpreter::MessageType_GetResult, &getResultService));
  services.insert(std::make_pair(interpreter::MessageType_FreeResult, &freeResultService));
  services.insert(std::make_pair(interpreter::MessageType_RegisterFileSystem, &registerFileSystem));
  services.insert(std::make_pair(interpreter::MessageType_DeregisterFileSystem, &deregisterFileSystem));

  auto interpreterServices = [&services](const blazingdb::protocol::Buffer &requestPayloadBuffer) -> blazingdb::protocol::Buffer {
    RequestMessage request{requestPayloadBuffer.data()};
    std::cout << "header: " << (int)request.messageType() << std::endl;

    auto result = services[request.messageType()] ( request.accessToken(),  request.getPayloadBuffer() );
    ResponseMessage responseObject{result.first, result.second};
    return Buffer{responseObject.getBufferData()};
  };
  server.handle(interpreterServices);

	return 0;
}
