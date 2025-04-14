#!/bin/bash
cd ./../cli
java -jar ./schema-registry-gitops.jar --properties=./gitops.properties plan ./../updateReferenceSchemas/event-generic-state.yaml