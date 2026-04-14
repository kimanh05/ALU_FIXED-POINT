# 32-bit Fixed-Point ALU on FPGA

## 📌 Overview
This project implements a 32-bit fixed-point Arithmetic Logic Unit (ALU) using Verilog HDL, designed with a pipelined and modular architecture. The ALU supports multiple arithmetic, logic, shift, and comparison operations with configurable fixed-point format (Q-format).

## 🚀 Features
- 32-bit fixed-point arithmetic (Q-format configurable)
- Supported operations:
  - Arithmetic: ADD, SUB, MUL, DIV
  - Logic: AND, OR, XOR, NOR
  - Shift: Logical/Arithmetic Shift
  - Comparison: EQ, LT, LE
- Pipelined architecture for improved throughput
- Modular design with separate functional units
- Overflow detection and saturation handling
- Rounding mechanism for multiplication
- Valid signal synchronization for multi-cycle operations

## 🏗️ Architecture
The ALU is designed using a modular datapath architecture:
- **algorithm**: Main datapath controller
- **add32 / sub32**: Fixed-point addition and subtraction with saturation
- **mul_unit**: Multiplication with rounding and pipeline support
- **div_unit**: Fixed-point division with zero-division handling
- **logic_unit**: Bitwise logic operations
- **shift_unit**: Shift operations
- **compare_unit**: Comparison operations
- **select_unit**: Output selection
- **flag_unit**: Status flags (overflow, zero, negative)

## ⏱️ Pipeline Design
- Supports different operation latencies (e.g., MUL, DIV)
- Uses `valid_in` and `valid_out` signals for synchronization
- Ensures correct data alignment across pipeline stages

## 🧪 Verification
- Functional simulation performed in Xilinx Vivado
- Verified across multiple test cases:
  - Positive/negative operands
  - Overflow scenarios
  - Division by zero
  - Fixed-point precision and rounding behavior
- Waveform analysis confirms correct timing and output behavior

## 🛠️ Tools & Technologies
- Verilog HDL
- Xilinx Vivado
- GitHub for version control

## 📂 Project Structure
/src # Verilog source files
/testbench # Testbench files
/sim # Simulation results (waveforms)

## 🎯 Learning Outcomes
- Designed a pipelined datapath in RTL
- Implemented fixed-point arithmetic (Q-format)
- Handled overflow, saturation, and rounding
- Understood timing, latency, and signal synchronization in hardware design
