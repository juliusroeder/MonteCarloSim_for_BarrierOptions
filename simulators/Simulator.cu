//
// Created by Julius Roeder on 04/10/2022.
//

#include "Simulator.cuh"
#include <cuda_runtime.h>
#include <curand_kernel.h>
#include <curand.h>
#include <random>
#include <cuda.h>
#include <algorithm>
#include <iostream>

#define BILLION 1000000000L
#define MILLION 1000000L

__global__ void  down_and_out_call_kernel(
        const float* rand_num,
        const float K,
        const float B,
        const float S0,
        const float sigma,
        const float mu,
        const float dt,
        const unsigned N_PATH,
        const unsigned N_STEP,
        float * d_answer){

    unsigned int index = threadIdx.x + blockIdx.x * blockDim.x;
    unsigned int index_rand_num = index * N_STEP ;

    __shared__ float partial_payoff;
    if (threadIdx.x == 0) partial_payoff=0;
    if (index == 0) *d_answer = 0;
    __syncthreads();

    // simulation part
    if(index < N_PATH) {
        float current_price = S0;
        unsigned int n = 0;
        while (n < N_STEP && current_price > B) {
            current_price += mu * current_price * dt + sigma * current_price * rand_num[index_rand_num];
            index_rand_num++;
            n++;
        }
        (current_price > K ? atomicAdd(&partial_payoff,current_price - K) : 0);
    }

    __syncthreads(); //make sure all threads are done
    if (threadIdx.x==0) atomicAdd(d_answer, partial_payoff); //thread 0 in a block adds the block payoff to the global payoff
}

Simulator::Simulator(simulation_params *simParams) {
    params = simParams;



}

Simulator::~Simulator() {
    cudaFree(rand_num);
    cudaFree(d_answer);
}

void Simulator::prepGpu(){
    ////  allocate space on GPU
    cudaMalloc(&d_answer, sizeof(float));
    cudaMalloc((void**)&rand_num, params->m_nRandNum * sizeof(float));

    ////  generate random numbers
    curandGenerator_t GPU_generator;
    curandCreateGenerator(&GPU_generator, CURAND_RNG_PSEUDO_MTGP32);
    curandSetPseudoRandomGeneratorSeed(GPU_generator, 3567357ULL);
    curandGenerateNormal(GPU_generator, rand_num, params->m_nRandNum, 0.0f, params->m_sqrt_dt);
}

void Simulator::prepCpu(){
    ////  CPU Version
    std::default_random_engine CPU_generator;
    std::normal_distribution<float> distribution (0, params->m_sqrt_dt);

    auto gen = [&distribution, &CPU_generator](){
        return distribution(CPU_generator);
    };

    cpu_rands.resize(params->m_nRandNum);
    std::generate(begin(cpu_rands), end(cpu_rands), gen);
}

void Simulator::downAndOutCallKernel(){
    int numBlocks = ceil((float)params->c_nPath/512.0f);
    down_and_out_call_kernel<<<numBlocks, 512>>>(rand_num, params->c_K, params->c_B, params->c_S0, params->c_sigma,
                                                 params->c_mu, params->m_dt, params->c_nPath, params->c_nSteps, d_answer);
}

void Simulator::runGpuSim(){
    ////  call Kernel
    if (params->c_type == "down_and_out_call") {
        downAndOutCallKernel();
    }else if (params->c_type.empty()){
        std::cout << "No option type specified." << std::endl;
        throw;
    }

    cudaMemcpy(&h_answer, d_answer, sizeof(float), cudaMemcpyDeviceToHost);
    std::cout << "GPU result " << params->m_exponent * h_answer/params->c_nPath << std::endl;
}

void Simulator::runCpuSim(){ //down_and_out call option

    float payoff = 0;
    unsigned ii = 0;
    for (unsigned i=0; i < params->c_nPath; i++){
        int j = 0;
        float curr_value = params->c_S0;
        ii = i * params->c_nSteps; // need to actually start at the right random value
        while (j < params->c_nSteps && curr_value > params->c_B){
            curr_value = curr_value + params->c_mu * curr_value * params->m_dt + params->c_sigma * curr_value * cpu_rands[ii];
            j++;
            ii++;
        }
        payoff += params->m_exponent * (curr_value > params->c_K ? curr_value - params->c_K : 0);
    }

    std::cout << "CPU result " << payoff/(float)params->c_nPath << std::endl;
}

void Simulator::runSimulation(){
    ////  Profiling
    unsigned long diff_cpu = 0, diff_gpu = 0;
    struct timespec start{}, end{};
    clock_gettime(CLOCK_MONOTONIC, &start);

//  Start GPU Monte Carlo Sim
    prepGpu();
    runGpuSim();

    ////  Profiling
    clock_gettime(CLOCK_MONOTONIC, &end);
    diff_gpu = BILLION * (end.tv_sec - start.tv_sec) + end.tv_nsec - start.tv_nsec;
    std::cout << "GPU Time Taken in ms " << (double)diff_gpu/MILLION << std::endl;

    ////  Profiling
    clock_gettime(CLOCK_MONOTONIC, &start);

// Start CPU Monte Carlo Sim
    prepCpu();
    runCpuSim();

    ////  Profiling
    clock_gettime(CLOCK_MONOTONIC, &end);
    diff_cpu = BILLION * (end.tv_sec - start.tv_sec) + end.tv_nsec - start.tv_nsec;
    std::cout << "CPU Time Taken in ms " << (double)diff_cpu/MILLION << std::endl;

    std::cout << "Speedup: " << (double)diff_cpu/(double)diff_gpu << std::endl;
}







