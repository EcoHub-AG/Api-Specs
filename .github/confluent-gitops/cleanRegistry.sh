cd ./cli

while true; do

  subjects=$(confluent schema-registry subject list -o yaml | ./yq.exe e '.[] | .subject' -)

  if [ -z "$subjects" ]; then
      echo "No subjects remaining. Exiting loop."
      break
  fi

  for subject in $subjects; do
#    if [ "$subject" = "ClemensTestSubject" ]; then
      echo "Try deleting subject: $subject"
      # use cli
#      confluent schema-registry schema delete --subject $subject --version all --force
#      confluent schema-registry schema delete --subject $subject --version all --permanent --force

      # or use http
      curl -X DELETE -u <API_KEY>:<API_KEY_SECRET>  https://psrc-qrk9d.westeurope.azure.confluent.cloud/subjects/$subject
      curl -X DELETE -u <API_KEY>:<API_KEY_SECRET>  https://psrc-qrk9d.westeurope.azure.confluent.cloud/subjects/$subject?permanent=true
#    fi
  done

  echo "Completed one iteration. Checking for remaining subjects..."
  sleep 1  # Add a small delay to avoid hammering the server
done

