/*******************************************************************************
 Copyright 2006-2009 Lukas Käll <lukas.kall@cbr.su.se>

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


#ifndef MSGFDBREADER_H
#define MSGFDBREADER_H

#include "Reader.h"

class msgfdbReader: public Reader
{

public:
  
  msgfdbReader(ParseOptions po);
  
  virtual ~msgfdbReader();
  
  virtual void read(const std::string fn, bool isDecoy,boost::shared_ptr<FragSpectrumScanDatabase> database);
  
  virtual bool checkValidity(const std::string file);
 
  virtual void getMaxMinCharge(std::string fn);
  
  virtual void addFeatureDescriptions(bool doEnzyme,const std::string& aaAlphabet,std::string fn);
  
private:
  std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
  std::vector<std::string> split(const std::string &s, char delim);
  void remove_endl(std::string s);
  
  void readPSM(std::string line,bool isDecoy,std::string fileId,
	       boost::shared_ptr<FragSpectrumScanDatabase> database, std::vector<std::string> column_names);
};

#endif //MSGFDBREADER_H
