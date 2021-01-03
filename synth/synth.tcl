create_project -force cpu_proj ./cpu_proj -part xc7a35tcpg236-1
add_files src/cpu.v
add_files src/alu32.v
add_files src/immGen.v
add_files src/regfile.v
add_files src/control.v

add_files -fileset sim_1 test/cpu_tb.v
add_files -fileset sim_1 src/dmem.v
add_files -fileset sim_1 src/imem.v

add_files -fileset sim_1 test/t1/*
add_files -fileset sim_1 test/t2/*
add_files -fileset sim_1 test/t3/*

update_compile_order -fileset sim_1
launch_simulation
run all
close_sim

launch_runs synth_1 -jobs 8
wait_on_run synth_1
open_run [current_run -synth -quiet]
namespace import ::tclapp::xilinx::designutils::report_failfast
report_failfast -csv -transpose -no_header -file utilisation.csv

launch_simulation -mode post-synthesis -type functional
run all
close_sim
