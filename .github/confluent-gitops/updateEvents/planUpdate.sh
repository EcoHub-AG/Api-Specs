#!/bin/bash
cd ./../cli

# Store the YAML in an environment variable
LATEST_VERSIONS_YAML=$(cat "./../latestReferenceVersions/latest_reference_versions.yaml" | ./yq.exe eval -P -)
export LATEST_VERSIONS_YAML

./yq.exe '.subjects[].references[] |= (.version = env(LATEST_VERSIONS_YAML)[.subject])' "./../updateEvents/events-state-template.yaml" > "./../updateEvents/updated-events-state.yaml"

java -jar schema-registry-gitops.jar --properties=./gitops.properties plan ./../updateEvents/updated-events-state.yaml

