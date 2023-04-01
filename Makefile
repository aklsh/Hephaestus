#
# Makefile
# Akilesh Kannan, 2020-12-15 14:35
#

SRC = src/cpu.v src/alu.v src/immGen.v src/control.v src/regfile.v
MEM = src/dmem.v src/imem.v
TB = test/cpu_tb.v
TESTS = test
CPU = build/singleCycle.v
RANDINT = $(shell python -c 'from random import randint; print(randint(1,100)%3 + 1);' | sed s/\n//)

define TITLE
------------------
 Single-Cycle CPU
------------------
endef
export TITLE

synth-vivado: $(CPU)
	@cd synth

synth-yosys:
	@yosys synth/synth.ys

test-random: $(CPU)
	@echo "$$TITLE"
	@iverilog -g2012 -DTESTDIR=\"t$(RANDINT)\" -o build/sCPU.o $(CPU) $(TB) $(MEM)
	@vvp build/sCPU.o
	@cat log/cpu_tb.log

test-all: $(CPU)
	@echo "$$TITLE"
	@iverilog -g2012 -DTESTDIR=\"t1\" -o build/sCPU.o $(CPU) $(TB) $(MEM)
	@vvp build/sCPU.o
	@iverilog -g2012 -DTESTDIR=\"t2\" -o build/sCPU.o $(CPU) $(TB) $(MEM)
	@vvp build/sCPU.o
	@iverilog -g2012 -DTESTDIR=\"t3\" -o build/sCPU.o $(CPU) $(TB) $(MEM)
	@vvp build/sCPU.o
	@cat log/cpu_tb.log


$(CPU): $(SRC)
	@iverilog -g2012 -E -o$(CPU) $(SRC)

.PHONY: clean
clean: 												## Remove the build and log files
	rm -rf build/* log/* *.o
	rm -f *.vcd
