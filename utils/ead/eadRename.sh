#!/bin/bash

#   Author: Jamie Little
#   University of Miami Libraries
#   Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
#   
#   eadRename.sh can be used to rename a set of EAD files exported from Archon. 
#   The script renames each file in the directory using the unique ID specified in the @identifier attribute of the eadid element.

for f in *.xml; 
    do 
        name=`xpath -e 'string(//eadid/@identifier)' $f 2> /dev/null`
        echo "Moving" $f "to" ${name:27}.xml
        echo $name
        mv $f ${name:27}.xml
    done
