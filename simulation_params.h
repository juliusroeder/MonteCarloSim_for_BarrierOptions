//
// Created by Julius Roeder on 04/10/2022.
//

#ifndef CUDAPROJECTS_SIMULATION_PARAMS_H
#define CUDAPROJECTS_SIMULATION_PARAMS_H

#include <string>

class simulation_params {
public:
    simulation_params(long N_PATH, long N_STEPS, float T, float K, float B, float S0, float sigma, float mu, float r, std::string option_type);

//  simulation parameters
    const long c_nPath;
    const long c_nSteps;

//  option parameters
    const float c_T;
    const float c_K;
    const float c_B;
    const float c_S0;
    const float c_sigma;
    const float c_mu;
    const float c_r;
    const std::string c_type;

//  calculated parameters
    long m_nRandNum;
    float m_dt;
    float m_sqrt_dt;
    float m_exponent;
};


#endif //CUDAPROJECTS_SIMULATION_PARAMS_H
