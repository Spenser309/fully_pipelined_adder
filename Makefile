# Engineer: Spenser Gilliland
# Company: IIT ECASP Lab
# License: GPLv3
# Date: 10-20-2011
#
# Makefile for Verilog Program

VERSION=0.0.1

sim = t_fully_pipelined_adder

src_files = t_fully_pipelined_adder.v fully_pipelined_adder.v

dist_files = Makefile README $(sim).sav

.PHONY: all clean wave run dist
.DEFAULT: run

all: $(sim) run

clean:
	rm -rf $(sim).lxt $(sim)

wave: $(sim).lxt
	gtkwave -A $(sim).lxt

run:
	vvp $(sim) -lxt2

dist:
	tar cvzf fully_pipelined_adder-$(VERSION).tar.gz $(dist_files) $(files)

$(sim).lxt: $(sim)
	vvp $(sim) -lxt2

$(sim): $(src_files)
	iverilog -o $(sim) $(src_files)



