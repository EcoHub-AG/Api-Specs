#!/bin/bash
cd ./../cli
java -jar schema-registry-gitops.jar --properties=./gitops.properties apply ./../updateEvents/updated-events-state.yaml

