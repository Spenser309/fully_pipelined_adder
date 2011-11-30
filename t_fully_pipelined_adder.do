# Behavioural Simulation of Fully Pipelined Adder
#

vlib work-sim
vmap work work-sim
vlog -sv t_fully_pipelined_adder.v
vlog fully_pipelined_adder.v
vsim -novopt -lib work t_fully_pipelined_adder -wlf t_fully_pipelined_adder.wlf

add wave -unsigned /*

run

#write wave

exit
