transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/router.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/ripple_adder.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/reg_17.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/HexDriver.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/control.sv}
vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/adder2.sv}

vlog -sv -work work +incdir+C:/WORKPLACE/ece385/lab3/code {C:/WORKPLACE/ece385/lab3/code/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
