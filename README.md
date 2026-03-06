# RTP - Real Time Processor
The RTP is a simple RISC-V processor designed to support real-time processing. 

Real time processing is defined with response times less than 10ms, so we need to optimize performance over throughput or complexity of instructions. 

The goal is to implement I, then M, then A, then C, then F, then all the extensions. 

The processor itself will be pipelined, it will not be controlled directly with an FSM. We hope to make it 5-7 stages maximum. 

## [RV32IMACF_ZiCSR_ZiFenci_ZiCntr](https://five-embeddev.com/riscv-user-isa-manual/Priv-v1.12/instr-table.html) 

### Schematic
![RTP_SCHEMATIC](RTP.drawio.svg)

### Submodules
PROG_CNTR - Simple 32 bit program counter 

REG_FILE  - 32x32 register file 

IMEM - 24kB Instruction Memory 

DMEM - 40kB Data Memory 

DCDR - Instruction Decoder  

IMM_GEN - Immediate Generator (3 bit selected) 

JUMP_GEN - Jump/Branch Generator (2 bit selected) 

BR_PRED - Branch Predictor (2-State) 

ALU - Arithmetic Logic Unit

HAZ_CTRL - Hazard Controller (forwards, stalls, and flushes if needed) 

CSR - Control and Status Registers

### Auxiliary Modules
MUX2T1 

MUX4T1 

MUX8T1 
