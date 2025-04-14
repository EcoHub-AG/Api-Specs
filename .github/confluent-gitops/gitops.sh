#!/bin/bash

# Create backup of the current state
cd cli
java -jar schema-registry-gitops.jar --properties=./gitops.properties dump ./registryStateBackup.yaml

# Step 1: Update the "base" subjects that don't have any references themselves to match the version currently in git
cd updateReferenceSchemas
./planUpdate.sh # Optional: Plan update first to see the changes that will be applied
./applyUpdate.sh # Apply the changes to the registry

# Step 2: Get the latest versions of the referenced subjects
cd ../latestReferenceVersions
./getLatestReferenceVersions.sh

# Step 3: Update the events to match the version in git and update all references to the "base" subjects to the latest versions
cd ../updateEvents
./planUpdate.sh # Plan the update to generate the new desired state
./applyUpdate.sh # Apply new state

# Step 4: Get the latest versions of the referenced subjects again as the latest version of the events now changed.
cd ../latestReferenceVersions
./getLatestReferenceVersions.sh

# Step 5: Update all references in the "-value" subjects to the latest version
cd ../updateValueSubjects
./planUpdate.sh # Plan the update to generate the new desired state
./applyUpdate.sh # Apply new state