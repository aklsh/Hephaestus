clear
iverilog ALU-test.v
vvp ./"$1"/a.out
open -a gtkwave ./"$1"/test.vcd
rm -f ./a.out
