#include <cstdint>
#include <memory>

#include "verilated_fst_c.h"

#include "Vcore.h"

static const uint64_t clk_step    = 100;
static const uint64_t sim_time    = 100*clk_step;
static const uint64_t trace_depth = 50;

unsigned char ram[1024] = {
  0xEA, // NOP
  0xA9, // LDA #55
  0x55,
  0x69, // ADC #03
  0x03,
  0x29, // AND #F0
  0xF0,
  0x09, // ORA #05
  0x05,
};

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::debug(0); // 0 - 9
  Verilated::time(0);
  Verilated::traceEverOn(true);

  auto core = std::make_unique<Vcore>(); // should be instantiated before tfp
  auto tfp  = std::make_unique<VerilatedFstC>();

  core->trace(tfp.get(), trace_depth);
  tfp->open("core.fst");

  while (Verilated::time() < sim_time && !Verilated::gotFinish()) {
    core->clk = 1;
    core->eval();
    Verilated::timeInc(clk_step);
    tfp->dump(Verilated::time());

    uint16_t addr = core->AD & 0x03ff;
    if (core->RW) {
      core->D_in = ram[addr];
    } else {
      ram[addr] = core->D_out;
    }

    core->clk = 0;
    core->eval();
    Verilated::timeInc(clk_step);
    tfp->dump(Verilated::time());
  }

  tfp->close();
  core->final();
  return 0;
}
