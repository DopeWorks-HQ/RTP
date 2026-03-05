TOP= top
RTL_SRCS := $(wildcard hdl/rtl/*.sv)
SIM:=iverilog -g2012
SIM_ARGS:= -o sim.vvp
LINT:=verilator --lint-only -Wall
BITSTREAM=flash.bit
TIMESCALE:= `timescale 1ns/1ps
TB_MOD:= module tb_


ifeq ($(firstword $(MAKECMDGOALS)), init-tb)
TOP:= $(word 2, $(MAKECMDGOALS))
$(eval $(TOP):;@:)
SIM_ARGS:= -o hdl/sim/tb_$(TOP)/tb_$(TOP).vvp hdl/rtl/$(TOP).sv hdl/sim/tb_$(TOP)/tb_$(TOP).sv
TB_MOD:= module tb_$(TOP);
END_MOD:= endmodule
endif

ifeq ($(firstword $(MAKECMDGOALS)), sim)
TOP:= $(word 2, $(MAKECMDGOALS))
$(eval $(TOP):;@:)
SIM_ARGS:= -o hdl/sim/tb_$(TOP)/tb_$(TOP).vvp hdl/rtl/$(TOP).sv hdl/sim/tb_$(TOP)/tb_$(TOP).sv
endif

ifeq ($(firstword $(MAKECMDGOALS)), lint)
TOP:= $(word 2, $(MAKECMDGOALS))
$(eval $(TOP):;@:)
endif

ifeq ($(firstword $(MAKECMDGOALS)), flash)
BITSTREAM:= $(word 2, $(MAKECMDGOALS))
$(eval $(BITSTREAM):;@:)
endif

.PHONY: init-tb sim lint wave clean synth build $(TOP)

init-tb:
	@ if [ ! -f hdl/rtl/$(TOP).sv ]; then \
		echo "RTL module $(TOP) not found"; \
		exit 2; \
	fi
	@ mkdir -p hdl/sim/tb_$(TOP)
	@ : > hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@ echo '$(TIMESCALE)' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@ echo '$(TB_MOD)' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@ sed -n '/START: $(TOP)/,/END: $(TOP)/p' hdl/rtl/$(TOP).sv >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@ echo '$(END_MOD)' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv

sim:     
	@ if [ ! -f hdl/rtl/$(TOP).sv ]; then \
		echo "RTL module $(TOP) not found"; \
		exit 2; \
	fi
	$(SIM) $(SIM_ARGS)

lint:
	$(LINT) hdl/rtl/$(TOP).sv

lint-all:
	$(LINT) $(RTL_SRCS)

synth:
	/tools/Xilinx/2025.1/Vivado/bin/vivado -mode batch -source tcl/build.tcl

flash:
	openFPGALoader -b basys3 $(BITSTREAM).bit
