//
// Created by Julius Roeder on 04/10/2022.
//

#ifndef CUDAPROJECTS_SIMULATOR_CUH
#define CUDAPROJECTS_SIMULATOR_CUH

#include <vector>
#include <map>
#include "../SimulationParameters.h"

class Simulator {
public:
    Simulator(SimulationParameters *simParams);
    void runSimulation();
    ~Simulator();

private:
    float h_answer;
    float* d_answer;
    float* rand_num;
    SimulationParameters *params;
    std::vector<float> cpu_rands;

    void prepGpu();
    void prepCpu();
    void runCpuSim();
    void runGpuSim();

    void downAndOutCallKernel();
};


#endif //CUDAPROJECTS_SIMULATOR_CUH
