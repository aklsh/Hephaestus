if [ -z "$1" ]
    then
        echo "No model specified. Abort"
    else
    	clear
    	find ./"$1" -type f  -name "*.v"|xargs iverilog -Wall
    	vvp ./"$1"/a.out
    	open -a gtkwave ./"$1"/test.vcd
    	rm -f ./a.out
fi
