transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/intelFPGA_lite/lab3 {C:/intelFPGA_lite/lab3/router.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/lab3 {C:/intelFPGA_lite/lab3/ripple_adder.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/lab3 {C:/intelFPGA_lite/lab3/reg_17.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/lab3 {C:/intelFPGA_lite/lab3/HexDriver.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/lab3 {C:/intelFPGA_lite/lab3/control.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/lab3 {C:/intelFPGA_lite/lab3/adder2.sv}

