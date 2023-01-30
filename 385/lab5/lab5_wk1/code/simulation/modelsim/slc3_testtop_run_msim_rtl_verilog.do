transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/test_memory.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/synchronizers.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/SLC3_2.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/Mem2IO.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/ISDU.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/HexDriver.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/datapath.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/slc3.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/memory_contents.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/slc3_testtop.sv}

vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab5/lab5_wk1/code {C:/WORKPLACE/ece385/lab5/lab5_wk1/code/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
