 /*******************************************************************************
 Copyright 2006-2012 Lukas Käll <lukas.kall@scilifelab.se>

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 *******************************************************************************/

#ifndef CALLER_H_
#define CALLER_H_
#include <ctime>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include <vector>
#include <set>
#include <map>
#include <string>
#include <memory>
#ifdef HAVE_CONFIG_H
  #include "config.h"
#endif
#include "Globals.h"
#include "Option.h"
#include "SetHandler.h"
#include "DataSet.h"
#include "Scores.h"
#include "SanityCheck.h"
#include "Normalizer.h"
#include "ProteinProbEstimator.h"
#include "FidoInterface.h"
#include "PickedProteinInterface.h"
#include "XMLInterface.h"
#include "CrossValidation.h"

/*
* Main class that starts and controls the calculations.
*
* In addition to the calculation Caller also handles command line
* initialization, parsing input parameters, handling output of the
* calculation results.
* 
*/
class Caller {
 public:
  enum SetHandlerType {
    NORMAL = 1, SHUFFLED = -1, SHUFFLED_TEST = 2, SHUFFLED_THRESHOLD = 3
  };
  
  Caller();
  virtual ~Caller();
  
  static string greeter();
  string extendedGreeter(time_t& startTime);
  bool parseOptions(int argc, char **argv);    
  int run();
  
 protected:    
  Normalizer* pNorm_;
  SanityCheck* pCheck_;
  ProteinProbEstimator* protEstimator_;
  
  // file input parameters
  bool tabInput_;
  bool readStdIn_;
  std::string inputFN_;
  bool xmlSchemaValidation_;
  
  // file output parameters
  std::string tabOutputFN_, xmlOutputFN_;
  std::string weightOutputFN_;
  std::string psmResultFN_, peptideResultFN_, proteinResultFN_;
  std::string decoyPsmResultFN_, decoyPeptideResultFN_, decoyProteinResultFN_;
  bool xmlPrintDecoys_, xmlPrintExpMass_;
  
  // report level parameters
  bool reportUniquePeptides_;
  bool targetDecoyCompetition_;
  bool useMixMax_;
  std::string inputSearchType_;
  
  // SVM / cross validation parameters
  double selectionFdr_, testFdr_;
  unsigned int numIterations_, maxPSMs_;
  double selectedCpos_, selectedCneg_;
  bool reportEachIteration_, quickValidation_;
  
  // reporting parameters
  std::string call_;
  
  void calculatePSMProb(Scores& allScores, bool uniquePeptideRun, 
      time_t& procStart, clock_t& procStartClock, double& diff);
  void calculateProteinProbabilities(Scores& allScores);

#ifdef CRUX
  virtual void processPsmScores(Scores& allScores) {}
  virtual void processPeptideScores(Scores& allScores) {}
  virtual void processProteinScores(ProteinProbEstimator* protEstimator) {}
#endif
    
};

#endif /*CALLER_H_*/
