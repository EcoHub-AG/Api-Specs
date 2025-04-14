#!/bin/bash
cd ./../cli

java -jar schema-registry-gitops.jar --properties=./gitops.properties dump ./registryState.yaml
./yq.exe eval '.subjects |= map(select(.name | test("-value")))' "registryState.yaml" > "./../updateValueSubjects/valueSubjectsState.yaml"

# Store the YAML in an environment variable
LATEST_VERSIONS_YAML=$(cat "./../latestReferenceVersions/latest_reference_versions.yaml" | ./yq.exe eval -P -)
export LATEST_VERSIONS_YAML

./yq.exe '.subjects[].references[] |= (.version = env(LATEST_VERSIONS_YAML)[.subject])' "./../updateValueSubjects/valueSubjectsState.yaml" > "./../updateValueSubjects/newValueSubjectsState.yaml"

java -jar schema-registry-gitops.jar --properties=./gitops.properties plan ./../updateValueSubjects/newValueSubjectsState.yaml
