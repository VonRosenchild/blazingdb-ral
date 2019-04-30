/*
 * GDFColumn.h
 *
 *  Created on: Sep 12, 2018
 *      Author: rqc
 */

#ifndef GDFCOLUMN_H_
#define GDFCOLUMN_H_

#include "gdf_wrapper/gdf_wrapper.cuh"
#include "GDFCounter.cuh"
#include "Utils.cuh"
#include "Types.h"
#include <string>

class gdf_column_cpp
{
	private:
		gdf_valid_type * allocate_valid();


	//	gdf_column_cpp(void* _data, gdf_valid_type* _valid, gdf_dtype _dtype, size_t _size, gdf_size_type _null_count, const std::string &column_name = "");
	public:
	
		void set_name(std::string name);
	void set_name_cpp_only(std::string name); //TODO: this only exists because sometimes a gdf_column gets generated by another process
    void* data() const;
    void allocate_set_valid();
    gdf_valid_type* valid() const;
    std::string name() const;

    gdf_size_type size() const;

    gdf_dtype dtype() const;

    gdf_size_type null_count();

    gdf_dtype_extra_info dtype_info();
	
	column_token_t get_column_token() const;

	void set_column_token(column_token_t column_token);

	void set_dtype(gdf_dtype dtype);
	bool is_ipc() const;

	bool has_token();

	gdf_column_cpp();
	void create_gdf_column(gdf_column * column);
	void create_gdf_column_for_ipc(gdf_dtype type, void * col_data,gdf_valid_type * valid_data,size_t size,std::string column_name);

	gdf_column_cpp(const gdf_column_cpp& col);

	gdf_column_cpp(gdf_column_cpp& col);

	void operator=(const gdf_column_cpp& col);

	gdf_column_cpp clone(std::string name = "");

	gdf_column* get_gdf_column() const;

	void create_gdf_column(NVCategory* category, size_t num_values,std::string column_name);

	void create_gdf_column(gdf_dtype type, size_t num_values, void * input_data, size_t width_per_value, const std::string &column_name = "");

	void create_gdf_column(gdf_dtype type, size_t num_values, void * input_data, gdf_valid_type * host_valid, size_t width_per_value, const std::string &column_name = "");

	gdf_error gdf_column_view(gdf_column *column, void *data, gdf_valid_type *valid, gdf_size_type size, gdf_dtype dtype);

	~gdf_column_cpp();

	void resize(size_t new_size);
	gdf_error compact();
	void update_null_count();

public:
    std::size_t get_valid_size() const;

    inline void decrement_counter(gdf_column* column) {
        if ((column != nullptr) && (is_ipc_column == false)) {
            GDFRefCounter::getInstance()->decrement(column);
        }
    }

public:
    gdf_column_cpp slice(gdf_size_type data_position, gdf_size_type data_length) const;

protected:
    void allocate_gpu_memory(gdf_column_cpp* column, gdf_size_type quantity, gdf_dtype dtype) const;

    void copy_in_gpu_memory(gdf_column_cpp*       output_column,
                            const gdf_column_cpp* input_column,
                            gdf_size_type         position,
                            gdf_size_type         length,
                            gdf_dtype             dtype) const;

    void update_null_count(gdf_column* column) const;

private:
    gdf_column* column{};
    std::size_t allocated_size_data{};
    std::size_t allocated_size_valid{};
    std::string column_name{};
    bool is_ipc_column{};
    column_token_t column_token{};
};

#endif /* GDFCOLUMN_H_ */
