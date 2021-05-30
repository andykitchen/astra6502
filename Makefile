all: core_tb.vcd

core_tb.vvp: core_tb.v core.v ram.v
	iverilog -o core_tb.vvp core_tb.v core.v ram.v

core_tb.vcd: core_tb.vvp
	vvp core_tb.vvp

clean:
	rm -rf core_tb.vvp core_tb.vcd

.PHONY: all clean
