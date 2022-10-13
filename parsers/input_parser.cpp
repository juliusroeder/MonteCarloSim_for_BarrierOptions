//
// Created by Julius Roeder on 04/10/2022.
//

#include "input_parser.h"

input_parser::input_parser(boost::filesystem::path file_path, std::vector<SimulationParameters> *pVector) {
    path = std::move(file_path);
    vector = pVector;
}

void input_parser::parse() {

    if (!boost::filesystem::exists(path)){
        std::cout << "File does not exist." << std::endl;
    }
    boost::filesystem::ifstream fileHandler(path);
    std::string header;
    getline(fileHandler, header);

    std::string line;
    std::vector<std::string> res;


    long N_PATH, N_STEPS;

    // option parameters
    float T, K, B, S0, sigma, mu, r;
    std::string type;

    while (getline(fileHandler, line)) {
        boost::split(res, line, boost::is_any_of(","));

        N_PATH = stol(res[0]);
        N_STEPS = stol(res[1]);
        T = stof(res[2]);
        K = stof(res[3]);
        B = stof(res[4]);
        S0 = stof(res[5]);
        sigma = stof(res[6]);
        mu = stof(res[7]);
        r = stof(res[8]);
        type = res[9];
        boost::trim(type);

        vector->emplace_back(N_PATH, N_STEPS, T, K, B, S0, sigma, mu, r, type);
    }
}
