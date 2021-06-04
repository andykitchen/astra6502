# make all       # new: use verilator to produce "core_tb.fst" output
#
# make gtkwave   # new: complete build, run and display "core_tb.fst" output
#
# make iverilog  # old: use iverilog to produce "core_tb.fst" output

all: core_tb.fst

gtkwave: core_tb.fst
	gtkwave core_tb.gtkw  # key signals already selected for display

obj_dir/Vcore_tb: core_tb.cpp core_tb.v core.v alu.v ram.v
	verilator --cc --build --exe -Wall --trace-fst -j `nproc` core_tb.cpp core_tb.v

core_tb.fst: obj_dir/Vcore_tb
	obj_dir/Vcore_tb

core_tb.vvp: core_tb.v core.v alu.v ram.v
	iverilog -o core_tb.vvp core_tb.v core.v alu.v ram.v

iverilog: core_tb.vvp
	vvp core_tb.vvp -fst

clean:
	rm -rf core_tb.vvp core_tb.fst core_tb.fst obj_dir

.PHONY: all clean iverilog
