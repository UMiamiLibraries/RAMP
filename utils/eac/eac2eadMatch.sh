#!/bin/bash

#   Author: Jamie Little and Timothy A. Thompson, with assistance from Ansgar Wiechers (http://stackoverflow.com/questions/18166893/outputting-multiple-files-using-xpath-in-bash) and Jester (http://stackoverflow.com/questions/19082066/using-xpath-in-bash-with-not)
#   University of Miami Libraries
#   Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
#   
#   eac2eadMatch.sh can be used to rename a set of EAC-CPF files exported from Archon. 
#   The script matches each EAC-CPF file in a directory with related resources (books or archival collections) specified in the @xlink:href attribute of resourceRelation elements.
#   It then outputs a new copy of the file for each resourceRelation element. 
#   The new copies are renamed by iterating through the resourceRelation elements and concatenating the file's recordId with the unique ID specified in the @xlink:href attribute.

mkdir books
mkdir other
for f in *.xml; do
  fid=$(xpath -e '//recordId/text()' "$f" 2>/dev/null)   
  for uid in $(xpath -e '//resourceRelation[relationEntry[@localType="papers"]]/@xlink:href' "$f" 2>/dev/null | awk -F= '{gsub(/"/,"",$0); print $4}'); do
    echo  "Moving $f to ${fid:3}_${uid}.xml"
    cp "$f" "${fid:3}_${uid}.xml"    
  done
  for uid2 in $(xpath -e '//resourceRelation[relationEntry[@localType="book"]]/@xlink:href' "$f" 2>/dev/null | awk -F= '{gsub(/"/,"",$0); print $4}'); do
    echo  "Moving $f to books/${fid:3}-${uid2}.xml"
    cp "$f" "books/${fid:3}-${uid2}.xml"    
  done  
  if [ -z "$(xpath -q -e '//resourceRelation' "$f" 2>/dev/null)" ]; then         
    echo  "Moving $f to other/${fid:3}.xml"
    cp "$f" "other/${fid:3}.xml"              
  fi  
  rm "$f"    
done

