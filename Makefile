TOP := top
RTL_SRCS := $(wildcard hdl/rtl/*.sv)
SIM := iverilog -g2012
SIM_ARGS := -o sim.vvp
LINT := verilator --lint-only -Wall
BITSTREAM := flash.bit
TIMESCALE := `timescale 1ns/1ps
TB_MOD := module tb_
END_MOD := endmodule
GTK = gtkwave

ifeq ($(firstword $(MAKECMDGOALS)),init-tb)
TOP := $(word 2,$(MAKECMDGOALS))
$(eval $(TOP):;@:)
SIM_ARGS := -o hdl/sim/tb_$(TOP)/tb_$(TOP).vvp hdl/rtl/$(TOP).sv hdl/sim/tb_$(TOP)/tb_$(TOP).sv
TB_MOD := module tb_$(TOP);
END_MOD := endmodule
endif

ifeq ($(firstword $(MAKECMDGOALS)),sim)
TOP := $(word 2,$(MAKECMDGOALS))
$(eval $(TOP):;@:)
SIM_ARGS := -o hdl/sim/tb_$(TOP)/tb_$(TOP).vvp hdl/rtl/$(TOP).sv hdl/sim/tb_$(TOP)/tb_$(TOP).sv
endif

ifeq ($(firstword $(MAKECMDGOALS)),lint)
TOP := $(word 2,$(MAKECMDGOALS))
$(eval $(TOP):;@:)
endif

ifeq ($(firstword $(MAKECMDGOALS)),wave)
TOP := $(word 2,$(MAKECMDGOALS))
$(eval $(TOP):;@:)
endif

ifeq ($(firstword $(MAKECMDGOALS)),flash)
BITSTREAM := $(word 2,$(MAKECMDGOALS))
$(eval $(BITSTREAM):;@:)
endif

.PHONY: init-tb sim lint lint-all wave clean synth build $(TOP)

init-tb:
	@if [ ! -f hdl/rtl/$(TOP).sv ]; then \
		echo "RTL module $(TOP) not found"; \
		exit 2; \
	fi
	@mkdir -p hdl/sim/tb_$(TOP)
	@: > hdl/sim/tb_$(TOP)/tb_$(TOP).sv

	@printf '%s\n' '`timescale 1ns/1ps' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf 'module tb_%s;\n\n' '$(TOP)' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv

		@awk ' \
		BEGIN { in_module=0; in_params=0; in_ports=0 } \
		$$0 ~ "^[[:space:]]*module[[:space:]]+$(TOP)" { in_module=1; next } \
		in_module && !in_ports { \
			if ($$0 ~ /^[[:space:]]*# *\(/) { in_params=1; next } \
			if (in_params && $$0 ~ /\)[[:space:]]*\(/) { in_params=0; in_ports=1; next } \
			if (!in_params && $$0 ~ /^[[:space:]]*\(/) { in_ports=1; next } \
		} \
		in_ports { \
			line = $$0; \
			sub(/\/\/.*/, "", line); \
			if (line ~ /^[[:space:]]*(input|output|inout)[[:space:]]+/) { \
				gsub(/,/, "", line); \
				sub(/^[[:space:]]*(input|output|inout)[[:space:]]+/, "", line); \
				while (sub(/^[[:space:]]*(wire|reg|logic|signed|unsigned)[[:space:]]+/, "", line)) {} \
				gsub(/^[[:space:]]+|[[:space:]]+$$/, "", line); \
				if (line != "") print "\tlogic " line ";"; \
			} \
			if ($$0 ~ /\)[[:space:]]*;/) exit; \
		} \
	' hdl/rtl/$(TOP).sv >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv

	@printf '\n\t$(TOP) dut (\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@awk ' \
		BEGIN { in_module=0; in_params=0; in_ports=0; first=1 } \
		$$0 ~ "^[[:space:]]*module[[:space:]]+$(TOP)" { in_module=1; next } \
		in_module && !in_ports { \
			if ($$0 ~ /^[[:space:]]*# *\(/) { in_params=1; next } \
			if (in_params && $$0 ~ /\)[[:space:]]*\(/) { in_params=0; in_ports=1; next } \
			if (!in_params && $$0 ~ /^[[:space:]]*\(/) { in_ports=1; next } \
		} \
		in_ports { \
			line = $$0; \
			sub(/\/\/.*/, "", line); \
			if (line ~ /^[[:space:]]*(input|output|inout)[[:space:]]+/) { \
				gsub(/,/, "", line); \
				sub(/^[[:space:]]*(input|output|inout)[[:space:]]+/, "", line); \
				while (sub(/^[[:space:]]*(wire|reg|logic|signed|unsigned)[[:space:]]+/, "", line)) {} \
				gsub(/\[[^]]*\]/, "", line); \
				gsub(/^[[:space:]]+|[[:space:]]+$$/, "", line); \
				if (line != "") { \
					if (!first) printf ",\n"; \
					printf "\t\t.%s(%s)", line, line; \
					first=0; \
				} \
			} \
			if ($$0 ~ /\)[[:space:]]*;/) exit; \
		} \
		END { printf "\n\t);\n" } \
	' hdl/rtl/$(TOP).sv >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv

	@printf '\n\tinitial begin\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf '\t\t$$dumpfile("tb_$(TOP).vcd");\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf '\t\t$$dumpvars(0, tb_$(TOP));\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf '\tend\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv

	@if grep -Eq '^[[:space:]]*input[[:space:]].*CLK' hdl/rtl/$(TOP).sv; then \
		echo "Clock detected, adding CLK generator"; \
		printf '\n\tinitial begin\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
		printf "\t\tCLK = 1'b0;\n" >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
		printf '\t\tforever #5 CLK = ~CLK;\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
		printf '\tend\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
	elif grep -Eq '^[[:space:]]*input[[:space:]].*clk' hdl/rtl/$(TOP).sv; then \
		echo "Clock detected, adding clk generator"; \
		printf '\n\tinitial begin\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
		printf "\t\tclk = 1'b0;\n" >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
		printf '\t\tforever #5 clk = ~clk;\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
		printf '\tend\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv; \
	else \
		echo "No clock input detected"; \
	fi

	@printf '\n\tinitial begin\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf '\t\t#200;\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf '\t\t$$finish;\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@printf '\tend\n\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv

	@printf 'endmodule\n' >> hdl/sim/tb_$(TOP)/tb_$(TOP).sv
	@echo "Generated hdl/sim/tb_$(TOP)/tb_$(TOP).sv"

sim:
	@if [ ! -f hdl/rtl/$(TOP).sv ]; then \
		echo "RTL module $(TOP) not found"; \
		exit 2; \
	fi
	@$(SIM) $(SIM_ARGS)
	@echo "Do you want to see simulation results? (y/n)"; \
	read input; \
	if [ "$$input" = "y" ]; then \
		echo "Proceeding with sim..."; \
		cd hdl/sim/tb_$(TOP) && vvp tb_$(TOP).vvp; \
	else \
		echo "Aborting."; \
		exit 1; \
	fi
	@echo "Do you want to view the waveform? (y/n)"; \
	read input; \
	if [ "$$input" = "y" ]; then \
		echo "Opening waveform with GTKWave..."; \
		gtkwave hdl/sim/tb_$(TOP)/tb_$(TOP).vcd; \
	else \
		echo "Aborting."; \
		exit 1; \
	fi

wave:
	$(GTK) hdl/sim/tb_$(TOP)/tb_$(TOP).gtkw

lint:
	$(LINT) hdl/rtl/$(TOP).sv

lint-all:
	$(LINT) $(RTL_SRCS)

synth:
	/tools/Xilinx/2025.1/Vivado/bin/vivado -mode batch -source tcl/build.tcl

flash:
	openFPGALoader -b basys3 $(BITSTREAM).bit