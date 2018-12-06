#=============================================================================
# Copyright 2018 BlazingDB, Inc.
#     Copyright 2018 Percy Camilo Triveño Aucahuasi <percy@blazingdb.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=============================================================================

cmake_minimum_required(VERSION 3.12)

project(thrift-download NONE)

include(ExternalProject)

ExternalProject_Add(thrift
    GIT_REPOSITORY    https://github.com/apache/thrift.git
    GIT_TAG           0.11.0
    SOURCE_DIR        "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/thrift-src"
    BINARY_DIR        "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/thrift-build"
    INSTALL_DIR       "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/thrift-install"
    UPDATE_COMMAND    ""
    CMAKE_ARGS        ${THRIFT_CMAKE_ARGS}
                      -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/thrift-install
                      -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
                      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
)
