# Engineer: Spenser Gilliland
# Company: IIT ECASP Lab
# License: GPLv3
# Date: 10-20-2011
#
# Makefile for Verilog Program

VERSION=0.0.2

sim = t_fully_pipelined_adder
uut = fully_pipelined_adder

srcfiles = t_fully_pipelined_adder.v fully_pipelined_adder.v
dist_files = Makefile README $(sim).do $(uut).scr alib-52 gscl45nm.db

.PHONY: all clean run syn wave dist
.DEFAULT: all 

all: syn sim 

syn: $(uut).timing $(uut).power $(uut).area $(uut).syn.log
	cat $(uut).syn.log
	cat $(uut).timing
	cat $(uut).power
	cat $(uut).area

sim: $(sim).sim.log
	cat $(sim).sim.log

wave: run
	vsim -view $(sim).wlf

clean:
	rm -rf transcript modelsim.ini work-sim work-syn default.svf $(sim).lxt *.log *.{power,timing,area} *.{wlf,vcd,saif}

dist:
	tar cvzf fully_pipelined_adder-$(VERSION).tar.gz $(dist_files) $(srcfiles)

%.timing %.power %.area %.syn.log: %.v %.scr t_%.saif
	dc_shell -f $*.scr | tee $*.syn.log	

%.wlf %.sim.log: %.do $(srcfiles) 
	vsim -c -do $*.do | tee $*.sim.log

%.vcd: %.wlf
	wlf2vcd $*.wlf > $*.vcd

%.saif: %.vcd
	vcd2saif -i $*.vcd -o $*.saif

