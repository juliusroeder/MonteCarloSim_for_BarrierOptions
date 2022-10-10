#include <iostream>
#include <stdio.h>

#include <boost/filesystem.hpp>
#include "parsers/input_parser.h"
#include "simulation_params.h"
#include "simulators/Simulator.cuh"



int main(int argc, char ** argv) {

    assert(argc > 0 && "Need path to input csv file");
    boost::filesystem::path csv_path = argv[1] ;
    std::vector<simulation_params> simulation_parameters;

    auto parser = std::make_unique<input_parser>(csv_path, &simulation_parameters);
    parser->parse();


    for (auto sp: simulation_parameters){
        auto sim = std::make_unique<Simulator>(&sp);
        sim->runSimulation();
        std::cout << "-------------" << std::endl;
    }

    return 0;
}
