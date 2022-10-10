# Pricing Barrier Options using Monte Carlo simulation (CUDA and CPU)

# Requirements
- CMake 3.13+
- Cuda 11.2
- Boost

# Description
Pricing barrier options using monte carlo simulation. The simulator is implemented both for CPU and GPU (CUDA). 

# Todo
- better CSV parser
- add different option types - it as of now only supports one type (down-and-out call options)
- test Thruster with reduce instead of GPU atomics