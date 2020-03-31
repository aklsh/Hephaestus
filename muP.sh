clear
python3 assembler.py --input $1
iverilog processor.v
vvp ./a.out
