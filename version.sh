#!/bin/bash

# process a file
if [[ -f "./pom.xml" ]]; then
  python3 ./version.py "pom.xml"
elif [[ -f "./package.json" ]]; then 
  python3 ./version.py "package.json"     
elif [[ -f "./version" ]]; then  
  cat ./version | tr -d '[:space:]'
else
  echo "v1"
fi