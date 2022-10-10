//
// Created by Julius Roeder on 04/10/2022.
//

#ifndef CUDAPROJECTS_INPUT_PARSER_H
#define CUDAPROJECTS_INPUT_PARSER_H

#include <boost/filesystem.hpp>
#include <bits/stdc++.h>
#include <boost/algorithm/string.hpp>
#include "../simulation_params.h"
#include <iostream>

class input_parser {

public:
    input_parser(boost::filesystem::path file_path, std::vector<simulation_params> *pVector);
    ~input_parser() = default;
    void parse();

private:
    boost::filesystem::path path;
    std::vector<simulation_params> * vector;
};


#endif //CUDAPROJECTS_INPUT_PARSER_H
