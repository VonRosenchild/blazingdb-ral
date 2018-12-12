# blazingdb-ral
BlazingDB Relational Algebra Interpreter

# Requirements
- C++11 compiler
- CMake 3.11+
- Boost libs

# Dependencies
- cudf/libgdf development branch from BlazingDB fork https://github.com/BlazingDB/cudf/tree/develop/libgdf
- blazingdb-protocol/cpp development branch from https://github.com/BlazingDB/blazingdb-protocol/tree/develop/cpp
- Google Tests

# Clone
This repo uses submodules. Make sure you cloned recursively:

```bash
git clone --recurse-submodules git@github.com:BlazingDB/blazingdb-ral.git
```

Or, after cloning:

```bash
cd blazingdb-ral
git submodule update --init --recursive
```

# Build
Before build always update the gitsumbdule
```bash
cd blazingdb-ral
git submodule update --init --recursive
```

There are two ways to build the RAL component (for both cases you don't need to have conda in your system).

## Basic build
The first one will automagically download all the RAL dependencies as part of the cmake process.

```bash
cd blazingdb-ral
mkdir build
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
```

## Custom build with dependencies
### Building the dependencies
Setup your workspace and output folders:
```bash
mkdir workspace
mkdir output
cd workspace
wget https://github.com/BlazingDB/blazingdb-automation/blob/develop/docker/blazingsql-build/blazingsql-build.properties
```

The blazingsql-build.properties describes how you want to build BlazingSQL, if you want to build only the dependencies then disable all modules:
```bash
...
#optional: enable build (default is true)
cudf_enable=false
blazingdb_protocol_enable=false
blazingdb_io_enable=false
blazingdb_ral_enable=false
blazingdb_orchestrator_enable=false
blazingdb_calcite_enable=false
pyblazing_enable=false
...
```

Finally run the build.sh script: 
```bash
wget https://github.com/BlazingDB/blazingdb-automation/blob/develop/docker/blazingsql-build/build.sh
chmod +x build.sh
./build.sh /path/to/workspace /path/to/output
```

All the dependencies will be inside /path/to/workspace/dependencies/

### Build with dependencies
This second approach will reuse your development environment.
So you just need to pass cmake arguments for installation paths of nvstrings, cudf/libgdf, blazingdb-protocol/cpp, etc.

```bash
cd blazingdb-ral
mkdir build
CUDACXX=/usr/local/cuda-9.2/bin/nvcc cmake -DCMAKE_BUILD_TYPE=Debug \
      -DNVSTRINGS_INSTALL_DIR=/path/to/workspace/dependencies/nvstrings_install_dir \
      -DBOOST_INSTALL_DIR=/path/to/workspace/dependencies/boost_install_dir \
      -DAWS_SDK_CPP_BUILD_DIR=/path/to/workspace/dependencies/aws_sdk_cpp_build_dir \
      -DFLATBUFFERS_INSTALL_DIR=/path/to/workspace/dependencies/flatbuffers_install_dir \
      -DLZ4_INSTALL_DIR=/path/to/workspace/dependencies/lz4_install_dir \
      -DZSTD_INSTALL_DIR=/path/to/workspace/dependencies/zstd_install_dir \
      -DBROTLI_INSTALL_DIR=/path/to/workspace/dependencies/brotli_install_dir \
      -DSNAPPY_INSTALL_DIR=/path/to/workspace/dependencies/snappy_install_dir \
      -DTHRIFT_INSTALL_DIR=/path/to/workspace/dependencies/thrift_install_dir \
      -DARROW_INSTALL_DIR=/path/to/workspace/dependencies/_install_dir \
      -DLIBGDF_INSTALL_DIR=/path/to/workspace/dependencies/libgdf_install_dir \
      -DBLAZINGDB_PROTOCOL_INSTALL_DIR=/path/to/workspace/dependencies/blazingdb_protocol_install_dir \
      -DBLAZINGDB_IO_INSTALL_DIR=/path/to/workspace/dependencies/blazingdb_io_install_dir \
      -DDGOOGLETEST_INSTALL_DIR=/path/to/workspace/dependencies/googletest_install_dir \
      ..
make
```

Remember NVSTRINGS_INSTALL_DIR and LIBGDF_INSTALL_DIR always got together.

If you don't define these optional arguments then the cmake process will resolve (download & build) each dependency:
- DNVSTRINGS_INSTALL_DIR
- DBOOST_INSTALL_DIR
- DAWS_SDK_CPP_BUILD_DIR
- DFLATBUFFERS_INSTALL_DIR
- DLZ4_INSTALL_DIR
- DZSTD_INSTALL_DIR
- DBROTLI_INSTALL_DIR
- DSNAPPY_INSTALL_DIR
- DTHRIFT_INSTALL_DIR
- DARROW_INSTALL_DIR
- DLIBGDF_INSTALL_DIR
- DBLAZINGDB_PROTOCOL_INSTALL_DIR
- DBLAZINGDB_IO_INSTALL_DIR
- DDGOOGLETEST_INSTALL_DIR

Finally, if don't want to use conda and need the nvstrings library, just download https://anaconda.org/nvidia/nvstrings/0.0.3/download/linux-64/nvstrings-0.0.3-cuda9.2_py35_0.tar.bz2 and uncompress the folder, this folder is the NVSTRINGS_HOME.

# Integration Tests

```bash
./integration_test-gen.sh
mkdir -p  build && cd build
LIBGDF_HOME="/path/to/libgdf"cmake ..
make -j8
```