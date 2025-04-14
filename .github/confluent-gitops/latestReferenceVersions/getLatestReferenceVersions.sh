cd ./../cli

# Fetch the list of subjects from the Confluent Schema Registry, excluding those ending in -value or -key and save to file
confluent schema-registry subject list -o yaml | grep -Ev '(-value|-key)$' > ./../latestReferenceVersions/referenceSubjects.yaml

# use yq to read the subject names into a variable
subject_list=$(./yq.exe eval '.[].subject' "./../latestReferenceVersions/referenceSubjects.yaml")

# Initialize an empty YAML string
LATEST_VERSIONS_YAML=""

# Loop the subjects and get the latest version
for subject in $subject_list; do
  latest_version=$(confluent schema-registry subject describe "$subject" -o yaml | ./yq.exe eval '.[] | .version' | sort -nr | head -n1)

  # Add to YAML string immediately
  LATEST_VERSIONS_YAML+="$subject: $latest_version"$'\n'

  echo "Subject: $subject, Latest Version: $latest_version"
done

# Write the YAML content to a file
echo -e "$LATEST_VERSIONS_YAML" > ./../latestReferenceVersions/latest_reference_versions.yaml

# Store the final YAML in an environment variable
LATEST_VERSIONS_YAML=$(echo -e "$LATEST_VERSIONS_YAML" | ./yq.exe eval -P -)
export LATEST_VERSIONS_YAML