
#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

#include <CalciteExpressionParsing.h>
#include <CalciteInterpreter.h>
#include <DataFrame.h>
#include <blazingdb/io/Util/StringUtil.h>
#include <gtest/gtest.h>
#include <GDFColumn.cuh>
#include <GDFCounter.cuh>
#include <Utils.cuh>

#include "gdf/library/api.h"
using namespace gdf::library;

struct EvaluateQueryTest : public ::testing::Test {
  struct InputTestItem {
    std::string query;
    std::string logicalPlan;
    gdf::library::TableGroup tableGroup;
    gdf::library::Table resultTable;
  };

  void CHECK_RESULT(gdf::library::Table& computed_solution,
                    gdf::library::Table& reference_solution) {
    computed_solution.print(std::cout);
    reference_solution.print(std::cout);

    for (size_t index = 0; index < reference_solution.size(); index++) {
      const auto& reference_column = reference_solution[index];
      const auto& computed_column = computed_solution[index];
      auto a = reference_column.to_string();
      auto b = computed_column.to_string();
      EXPECT_EQ(a, b);
    }
  }
};

// AUTO GENERATED UNIT TESTS
TEST_F(EvaluateQueryTest, TEST_00) {
  auto input = InputTestItem{
      .query =
          "select c_custkey, c_nationkey, c_acctbal from main.customer limit 5",
      .logicalPlan =
          "LogicalSort(fetch=[5])\n  LogicalProject(c_custkey=[$0], "
          "c_nationkey=[$3], c_acctbal=[$5])\n    "
          "EnumerableTableScan(table=[[main, customer]])",
      .tableGroup =
          LiteralTableGroupBuilder{
              {"main.customer",
               {{"c_custkey",
                 Literals<GDF_INT32>{
                     1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,
                     13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,
                     25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,
                     37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,
                     49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,
                     61,  62,  63,  64,  65,  66,  67,  68,  69,  70,  71,  72,
                     73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84,
                     85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,  96,
                     97,  98,  99,  100, 101, 102, 103, 104, 105, 106, 107, 108,
                     109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                     121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132,
                     133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144,
                     145, 146, 147, 148, 149, 150}},
                {"c_name",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_address",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_nationkey",
                 Literals<GDF_INT32>{
                     15, 13, 1,  4,  3,  20, 18, 17, 8,  5,  23, 13, 3,  1,
                     23, 10, 2,  6,  18, 22, 8,  3,  3,  13, 12, 22, 3,  8,
                     0,  1,  23, 15, 17, 15, 17, 21, 8,  12, 2,  3,  10, 5,
                     19, 16, 9,  6,  2,  0,  10, 6,  12, 11, 15, 4,  10, 10,
                     21, 13, 1,  12, 17, 7,  21, 3,  23, 22, 9,  12, 9,  22,
                     7,  2,  0,  4,  18, 0,  17, 9,  15, 0,  20, 18, 22, 11,
                     5,  0,  23, 16, 14, 16, 8,  2,  7,  9,  15, 8,  17, 12,
                     15, 20, 2,  19, 9,  10, 10, 1,  15, 5,  16, 10, 22, 19,
                     12, 14, 8,  16, 24, 18, 7,  12, 17, 3,  5,  18, 19, 22,
                     21, 4,  7,  9,  11, 4,  17, 11, 19, 7,  16, 5,  9,  4,
                     1,  9,  16, 1,  13, 3,  18, 11, 19, 18}},
                {"c_phone",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_acctbal",
                 Literals<GDF_FLOAT64>{
                     711.56,  121.65,  7498.12, 2866.83, 794.47,  7638.57,
                     9561.95, 6819.74, 8324.07, 2753.54, -272.6,  3396.49,
                     3857.34, 5266.3,  2788.52, 4681.03, 6.34,    5494.43,
                     8914.71, 7603.4,  1428.25, 591.98,  3332.02, 9255.67,
                     7133.7,  5182.05, 5679.84, 1007.18, 7618.27, 9321.01,
                     5236.89, 3471.53, -78.56,  8589.7,  1228.24, 4987.27,
                     -917.75, 6345.11, 6264.31, 1335.3,  270.95,  8727.01,
                     9904.28, 7315.94, 9983.38, 5744.59, 274.58,  3792.5,
                     4573.94, 4266.13, 855.87,  5630.28, 4113.64, 868.9,
                     4572.11, 6530.86, 4151.93, 6478.46, 3458.6,  2741.87,
                     1536.24, 595.61,  9331.13, -646.64, 8795.16, 242.77,
                     8166.59, 6853.37, 1709.28, 4867.52, -611.19, -362.86,
                     4288.5,  2764.43, 6684.1,  5745.33, 1738.87, 7136.97,
                     5121.28, 7383.53, 2023.71, 9468.34, 6463.51, 5174.71,
                     3386.64, 3306.32, 6327.54, 8031.44, 1530.76, 7354.23,
                     4643.14, 1182.91, 2182.52, 5500.11, 5327.38, 6323.92,
                     2164.48, -551.37, 4088.65, 9889.89, 7470.96, 8462.17,
                     2757.45, -588.38, 9091.82, 3288.42, 2514.15, 2259.38,
                     -716.1,  7462.99, 6505.26, 2953.35, 2912.0,  1027.46,
                     7508.92, 8403.99, 3950.83, 3582.37, 3930.35, 363.75,
                     6428.32, 7865.46, 5897.83, 1842.49, -234.12, 1001.39,
                     9280.71, -986.96, 9127.27, 5073.58, 8595.53, 162.57,
                     2314.67, 4608.9,  8732.91, -842.39, 7838.3,  430.59,
                     7897.78, 9963.15, 6706.14, 2209.81, 2186.5,  6417.31,
                     9748.93, 3328.68, 8071.4,  2135.6,  8959.65, 3849.48}},
                {"c_mktsegment",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_comment",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}}}}
              .Build(),
      .resultTable =
          LiteralTableBuilder{
              "ResultSet",
              {{"GDF_INT64", Literals<GDF_INT64>{1, 2, 3, 4, 5}},
               {"GDF_INT64", Literals<GDF_INT64>{15, 13, 1, 4, 3}},
               {"GDF_FLOAT64", Literals<GDF_FLOAT64>{711.56, 121.65, 7498.12,
                                                     2866.83, 794.47}}}}
              .Build()};
  auto logical_plan = input.logicalPlan;
  auto input_tables = input.tableGroup.ToBlazingFrame();
  auto table_names = input.tableGroup.table_names();
  auto column_names = input.tableGroup.column_names();
  std::vector<gdf_column_cpp> outputs;
  gdf_error err = evaluate_query(input_tables, table_names, column_names,
                                 logical_plan, outputs);
  EXPECT_TRUE(err == GDF_SUCCESS);
  auto output_table =
      GdfColumnCppsTableBuilder{"output_table", outputs}.Build();
  CHECK_RESULT(output_table, input.resultTable);
}
TEST_F(EvaluateQueryTest, TEST_01) {
  auto input = InputTestItem{
      .query =
          "select c_custkey, c_nationkey, c_acctbal from main.customer where "
          "c_nationkey=1 limit 50",
      .logicalPlan =
          "LogicalSort(fetch=[50])\n  LogicalProject(c_custkey=[$0], "
          "c_nationkey=[$3], c_acctbal=[$5])\n    "
          "LogicalFilter(condition=[=($3, 1)])\n      "
          "EnumerableTableScan(table=[[main, customer]])",
      .tableGroup =
          LiteralTableGroupBuilder{
              {"main.customer",
               {{"c_custkey",
                 Literals<GDF_INT32>{
                     1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,
                     13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,
                     25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,
                     37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,
                     49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,
                     61,  62,  63,  64,  65,  66,  67,  68,  69,  70,  71,  72,
                     73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84,
                     85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,  96,
                     97,  98,  99,  100, 101, 102, 103, 104, 105, 106, 107, 108,
                     109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                     121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132,
                     133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144,
                     145, 146, 147, 148, 149, 150}},
                {"c_name",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_address",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_nationkey",
                 Literals<GDF_INT32>{
                     15, 13, 1,  4,  3,  20, 18, 17, 8,  5,  23, 13, 3,  1,
                     23, 10, 2,  6,  18, 22, 8,  3,  3,  13, 12, 22, 3,  8,
                     0,  1,  23, 15, 17, 15, 17, 21, 8,  12, 2,  3,  10, 5,
                     19, 16, 9,  6,  2,  0,  10, 6,  12, 11, 15, 4,  10, 10,
                     21, 13, 1,  12, 17, 7,  21, 3,  23, 22, 9,  12, 9,  22,
                     7,  2,  0,  4,  18, 0,  17, 9,  15, 0,  20, 18, 22, 11,
                     5,  0,  23, 16, 14, 16, 8,  2,  7,  9,  15, 8,  17, 12,
                     15, 20, 2,  19, 9,  10, 10, 1,  15, 5,  16, 10, 22, 19,
                     12, 14, 8,  16, 24, 18, 7,  12, 17, 3,  5,  18, 19, 22,
                     21, 4,  7,  9,  11, 4,  17, 11, 19, 7,  16, 5,  9,  4,
                     1,  9,  16, 1,  13, 3,  18, 11, 19, 18}},
                {"c_phone",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_acctbal",
                 Literals<GDF_FLOAT64>{
                     711.56,  121.65,  7498.12, 2866.83, 794.47,  7638.57,
                     9561.95, 6819.74, 8324.07, 2753.54, -272.6,  3396.49,
                     3857.34, 5266.3,  2788.52, 4681.03, 6.34,    5494.43,
                     8914.71, 7603.4,  1428.25, 591.98,  3332.02, 9255.67,
                     7133.7,  5182.05, 5679.84, 1007.18, 7618.27, 9321.01,
                     5236.89, 3471.53, -78.56,  8589.7,  1228.24, 4987.27,
                     -917.75, 6345.11, 6264.31, 1335.3,  270.95,  8727.01,
                     9904.28, 7315.94, 9983.38, 5744.59, 274.58,  3792.5,
                     4573.94, 4266.13, 855.87,  5630.28, 4113.64, 868.9,
                     4572.11, 6530.86, 4151.93, 6478.46, 3458.6,  2741.87,
                     1536.24, 595.61,  9331.13, -646.64, 8795.16, 242.77,
                     8166.59, 6853.37, 1709.28, 4867.52, -611.19, -362.86,
                     4288.5,  2764.43, 6684.1,  5745.33, 1738.87, 7136.97,
                     5121.28, 7383.53, 2023.71, 9468.34, 6463.51, 5174.71,
                     3386.64, 3306.32, 6327.54, 8031.44, 1530.76, 7354.23,
                     4643.14, 1182.91, 2182.52, 5500.11, 5327.38, 6323.92,
                     2164.48, -551.37, 4088.65, 9889.89, 7470.96, 8462.17,
                     2757.45, -588.38, 9091.82, 3288.42, 2514.15, 2259.38,
                     -716.1,  7462.99, 6505.26, 2953.35, 2912.0,  1027.46,
                     7508.92, 8403.99, 3950.83, 3582.37, 3930.35, 363.75,
                     6428.32, 7865.46, 5897.83, 1842.49, -234.12, 1001.39,
                     9280.71, -986.96, 9127.27, 5073.58, 8595.53, 162.57,
                     2314.67, 4608.9,  8732.91, -842.39, 7838.3,  430.59,
                     7897.78, 9963.15, 6706.14, 2209.81, 2186.5,  6417.31,
                     9748.93, 3328.68, 8071.4,  2135.6,  8959.65, 3849.48}},
                {"c_mktsegment",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_comment",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}}}}
              .Build(),
      .resultTable =
          LiteralTableBuilder{
              "ResultSet",
              {{"GDF_INT64", Literals<GDF_INT64>{3, 14, 30, 59, 106, 141, 144}},
               {"GDF_INT64", Literals<GDF_INT64>{1, 1, 1, 1, 1, 1, 1}},
               {"GDF_FLOAT64",
                Literals<GDF_FLOAT64>{7498.12, 5266.3, 9321.01, 3458.6, 3288.42,
                                      6706.14, 6417.31}}}}
              .Build()};
  auto logical_plan = input.logicalPlan;
  auto input_tables = input.tableGroup.ToBlazingFrame();
  auto table_names = input.tableGroup.table_names();
  auto column_names = input.tableGroup.column_names();
  std::vector<gdf_column_cpp> outputs;
  gdf_error err = evaluate_query(input_tables, table_names, column_names,
                                 logical_plan, outputs);
  EXPECT_TRUE(err == GDF_SUCCESS);
  auto output_table =
      GdfColumnCppsTableBuilder{"output_table", outputs}.Build();
  CHECK_RESULT(output_table, input.resultTable);
}
TEST_F(EvaluateQueryTest, TEST_02) {
  auto input = InputTestItem{
      .query =
          "select c_custkey, c_nationkey, c_acctbal from main.customer order "
          "by c_nationkey asc, c_acctbal desc limit 30",
      .logicalPlan =
          "LogicalSort(sort0=[$1], sort1=[$2], dir0=[ASC], dir1=[DESC], "
          "fetch=[30])\n  LogicalProject(c_custkey=[$0], c_nationkey=[$3], "
          "c_acctbal=[$5])\n    EnumerableTableScan(table=[[main, customer]])",
      .tableGroup =
          LiteralTableGroupBuilder{
              {"main.customer",
               {{"c_custkey",
                 Literals<GDF_INT32>{
                     1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,
                     13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,
                     25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,
                     37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,  48,
                     49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,
                     61,  62,  63,  64,  65,  66,  67,  68,  69,  70,  71,  72,
                     73,  74,  75,  76,  77,  78,  79,  80,  81,  82,  83,  84,
                     85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,  96,
                     97,  98,  99,  100, 101, 102, 103, 104, 105, 106, 107, 108,
                     109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
                     121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132,
                     133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144,
                     145, 146, 147, 148, 149, 150}},
                {"c_name",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_address",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_nationkey",
                 Literals<GDF_INT32>{
                     15, 13, 1,  4,  3,  20, 18, 17, 8,  5,  23, 13, 3,  1,
                     23, 10, 2,  6,  18, 22, 8,  3,  3,  13, 12, 22, 3,  8,
                     0,  1,  23, 15, 17, 15, 17, 21, 8,  12, 2,  3,  10, 5,
                     19, 16, 9,  6,  2,  0,  10, 6,  12, 11, 15, 4,  10, 10,
                     21, 13, 1,  12, 17, 7,  21, 3,  23, 22, 9,  12, 9,  22,
                     7,  2,  0,  4,  18, 0,  17, 9,  15, 0,  20, 18, 22, 11,
                     5,  0,  23, 16, 14, 16, 8,  2,  7,  9,  15, 8,  17, 12,
                     15, 20, 2,  19, 9,  10, 10, 1,  15, 5,  16, 10, 22, 19,
                     12, 14, 8,  16, 24, 18, 7,  12, 17, 3,  5,  18, 19, 22,
                     21, 4,  7,  9,  11, 4,  17, 11, 19, 7,  16, 5,  9,  4,
                     1,  9,  16, 1,  13, 3,  18, 11, 19, 18}},
                {"c_phone",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_acctbal",
                 Literals<GDF_FLOAT64>{
                     711.56,  121.65,  7498.12, 2866.83, 794.47,  7638.57,
                     9561.95, 6819.74, 8324.07, 2753.54, -272.6,  3396.49,
                     3857.34, 5266.3,  2788.52, 4681.03, 6.34,    5494.43,
                     8914.71, 7603.4,  1428.25, 591.98,  3332.02, 9255.67,
                     7133.7,  5182.05, 5679.84, 1007.18, 7618.27, 9321.01,
                     5236.89, 3471.53, -78.56,  8589.7,  1228.24, 4987.27,
                     -917.75, 6345.11, 6264.31, 1335.3,  270.95,  8727.01,
                     9904.28, 7315.94, 9983.38, 5744.59, 274.58,  3792.5,
                     4573.94, 4266.13, 855.87,  5630.28, 4113.64, 868.9,
                     4572.11, 6530.86, 4151.93, 6478.46, 3458.6,  2741.87,
                     1536.24, 595.61,  9331.13, -646.64, 8795.16, 242.77,
                     8166.59, 6853.37, 1709.28, 4867.52, -611.19, -362.86,
                     4288.5,  2764.43, 6684.1,  5745.33, 1738.87, 7136.97,
                     5121.28, 7383.53, 2023.71, 9468.34, 6463.51, 5174.71,
                     3386.64, 3306.32, 6327.54, 8031.44, 1530.76, 7354.23,
                     4643.14, 1182.91, 2182.52, 5500.11, 5327.38, 6323.92,
                     2164.48, -551.37, 4088.65, 9889.89, 7470.96, 8462.17,
                     2757.45, -588.38, 9091.82, 3288.42, 2514.15, 2259.38,
                     -716.1,  7462.99, 6505.26, 2953.35, 2912.0,  1027.46,
                     7508.92, 8403.99, 3950.83, 3582.37, 3930.35, 363.75,
                     6428.32, 7865.46, 5897.83, 1842.49, -234.12, 1001.39,
                     9280.71, -986.96, 9127.27, 5073.58, 8595.53, 162.57,
                     2314.67, 4608.9,  8732.91, -842.39, 7838.3,  430.59,
                     7897.78, 9963.15, 6706.14, 2209.81, 2186.5,  6417.31,
                     9748.93, 3328.68, 8071.4,  2135.6,  8959.65, 3849.48}},
                {"c_mktsegment",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
                {"c_comment",
                 Literals<GDF_INT64>{
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}}}}
              .Build(),
      .resultTable =
          LiteralTableBuilder{
              "ResultSet",
              {{"GDF_INT64",
                Literals<GDF_INT64>{29, 80, 76,  73,  48, 86, 30, 3,  141, 144,
                                    14, 59, 106, 101, 39, 92, 47, 17, 72,  122,
                                    27, 13, 23,  146, 40, 5,  22, 64, 140, 4}},
               {"GDF_INT64", Literals<GDF_INT64>{0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
                                                 1, 1, 1, 2, 2, 2, 2, 2, 2, 3,
                                                 3, 3, 3, 3, 3, 3, 3, 3, 4, 4}},
               {"GDF_FLOAT64",
                Literals<GDF_FLOAT64>{
                    7618.27, 7383.53, 5745.33, 4288.5,  3792.5,  3306.32,
                    9321.01, 7498.12, 6706.14, 6417.31, 5266.3,  3458.6,
                    3288.42, 7470.96, 6264.31, 1182.91, 274.58,  6.34,
                    -362.86, 7865.46, 5679.84, 3857.34, 3332.02, 3328.68,
                    1335.3,  794.47,  591.98,  -646.64, 9963.15, 2866.83}}}}
              .Build()};
  auto logical_plan = input.logicalPlan;
  auto input_tables = input.tableGroup.ToBlazingFrame();
  auto table_names = input.tableGroup.table_names();
  auto column_names = input.tableGroup.column_names();
  std::vector<gdf_column_cpp> outputs;
  gdf_error err = evaluate_query(input_tables, table_names, column_names,
                                 logical_plan, outputs);
  EXPECT_TRUE(err == GDF_SUCCESS);
  auto output_table =
      GdfColumnCppsTableBuilder{"output_table", outputs}.Build();
  CHECK_RESULT(output_table, input.resultTable);
}
