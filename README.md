# AXI_Bus_Sim
System verilog simulation for AXI module.
DUT module contains 8 PWM moduels. Address 0 - 7 are PWM value registers, 8 - 15 are range registers, and address 16 is PWM control register (enable for 8 PWM units).

What this simulation does is;
1. Module reset
2. Write 0xFF to PWM control register (address 0x40, all 8 PWM units are enabled)
3. Write PWM values to 8 value registers sequentially

Simulated by Intel ModelSim.
Simulation results are below.

![alt text](https://github.com/yuhei1horibe/AXI_Bus_Sim/blob/master/SystemVrilogSimulation.png)
![alt text](https://github.com/yuhei1horibe/AXI_Bus_Sim/blob/master/PWM_SimResult.png)
