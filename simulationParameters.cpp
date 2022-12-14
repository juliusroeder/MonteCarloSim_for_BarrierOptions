//
// Created by Julius Roeder on 04/10/2022.
//

#include "SimulationParameters.h"
#include <cmath>
#include <utility>

SimulationParameters::SimulationParameters(long N_PATH, long N_STEPS, float T, float K, float B, float S0, float sigma, float mu, float r, std::string option_type)
: c_nPath(N_PATH), c_nSteps(N_STEPS), c_T(T), c_K(K), c_B(B), c_S0(S0), c_sigma(sigma), c_mu(mu), c_r(r), c_type(std::move(option_type)) {
    m_nRandNum = c_nPath * c_nSteps;
    m_dt = c_T/(float)c_nSteps;
    m_sqrt_dt = std::sqrt(m_dt);
    m_exponent = std::exp(-c_r*c_T);
}
