#!/bin/bash
app="cdsw_xgboost:v0.3"
docker build -t ${app} .
docker run -d -p 5000:80 \
  --name=${app} \
  -v $PWD:/app ${app} 
