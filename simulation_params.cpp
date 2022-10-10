//
// Created by Julius Roeder on 04/10/2022.
//

#include "simulation_params.h"
#include <math.h>

simulation_params::simulation_params(long N_PATH, long N_STEPS, float T, float K, float B, float S0, float sigma, float mu, float r)
: c_nPath(N_PATH), c_nSteps(N_STEPS), c_T(T), c_K(K), c_B(B), c_S0(S0), c_sigma(sigma), c_mu(mu), c_r(r) {
    m_nRandNum = c_nPath * c_nSteps;
    m_dt = c_T/(float)c_nSteps;
    m_sqrt_dt = sqrt(m_dt);
    m_exponent = exp(-c_r*c_T);
}
