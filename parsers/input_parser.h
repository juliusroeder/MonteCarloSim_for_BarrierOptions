//
// Created by Julius Roeder on 04/10/2022.
//

#ifndef CUDAPROJECTS_INPUT_PARSER_H
#define CUDAPROJECTS_INPUT_PARSER_H

#include <boost/filesystem.hpp>
#include <bits/stdc++.h>
#include <boost/algorithm/string.hpp>
#include "../SimulationParameters.h"
#include <iostream>

class input_parser {

public:
    input_parser(boost::filesystem::path file_path, std::vector<SimulationParameters> *pVector);
    ~input_parser() = default;
    void parse();

private:
    boost::filesystem::path path;
    std::vector<SimulationParameters> * vector;
};


#endif //CUDAPROJECTS_INPUT_PARSER_H
