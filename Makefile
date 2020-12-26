#
# Makefile
# Akilesh Kannan, 2020-12-15 14:35
#

SRC = src/cpu.v src/alu32.v src/immGen.v src/control.v src/regfile.v
TB = test/cpu_tb.v src/dmem.v src/imem.v
TESTS = test
CPU = build/singleCycle.v
RANDINT = $(shell python -c 'from random import randint; print(randint(1,100)%3 + 1);' | sed s/\n//)

define TITLE
------------------
 Single-Cycle CPU
------------------
endef
export TITLE

synth: $(CPU)
	@mkdir synth
	@cd synth

test-random: $(CPU)
	@iverilog -g2012 -DTESTDIR=\"t$(RANDINT)\" -o build/sCPU.o $(CPU) $(TB)
	@vvp build/sCPU.o
	@cat log/cpu_tb.log

$(CPU): $(SRC)
	@echo "$$TITLE"
	@iverilog -g2012 -E -o$(CPU) $(SRC)

.PHONY: clean
clean: 												## Remove the build and log files
	rm -rf build/* log/* *.o
	rm -f *.vcd
