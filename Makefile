# make all       # new: use verilator to produce "core_tb.vcd" output
#
# make gtkwave   # new: complete build, run and display "core_tb.vcd" output
#
# make iverilog  # old: use iverilog to produce "core_tb.vcd" output

all: core_tb.vcd

gtkwave: core_tb.vcd
	gtkwave core_tb.gtkw  # key signals already selected for display

core_tb.vcd: core_tb.cpp alu.v core.v core_tb.v ram.v
	verilator -Wall --exe --build -j core_tb.v -cc core_tb.cpp --trace-fst
	./obj_dir/Vcore_tb

core_tb.vvp: alu.v core.v core_tb.v ram.v
	iverilog -o core_tb.vvp core_tb.v core.v alu.v ram.v

iverilog: core_tb.vvp
	vvp core_tb.vvp

clean:
	rm -rf core_tb.vvp core_tb.vcd obj_dir

.PHONY: all clean
