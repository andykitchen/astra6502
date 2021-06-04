/*
 * Usage
 * ~~~~~
 * verilator -V | grep VERILATOR_ROOT
 *   VERILATOR_ROOT=/home/pi/play/fpga/oss-cad-suite/share/verilator
 * verilator -Wall --exe --build -j core_tb.v -cc core_tb.cpp --trace-fst
 * ./obj_dir/Vcore_tb
 *
 * To Do
 * ~~~~~
 * - Command line argument to enable / disable VL_PRINTF()
 * - Command line argument for maximum clock cycles to run
 */

#include <stdlib.h>
#include <memory>

#include "verilated_fst_c.h"  // "verilated.h" and "--trace"

#include "Vcore_tb.h"

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::debug(0);  // 0 - 9
  Verilated::traceEverOn(true);  // required for "--trace" or "--trace-fst"

  auto core_tb = std::make_unique<Vcore_tb>();

  int counter = 0;
  while (! Verilated::gotFinish()  &&  ++ counter <= 100) {
    core_tb->clk = ! core_tb->clk;
    core_tb->eval();

    VL_PRINTF("[%" VL_PRI64 "d] clk=%x\n", Verilated::time(), core_tb->clk);
    Verilated::timeInc(1);
  }

  core_tb->final();
  return(0);
}
