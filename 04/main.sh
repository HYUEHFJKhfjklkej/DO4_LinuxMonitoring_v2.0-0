#!/bin/bash

# Constants
LOGS_DIRECTORY="./logs"

# Response codes and their meanings
response_codes=(
  "200 - OK"
  "201 - Created"
  "400 - Bad Request"
  "401 - Unauthorized"
  "403 - Forbidden"
  "404 - Not Found"
  "500 - Internal Server Error"
  "501 - Not Implemented"
  "502 - Bad Gateway"
  "503 - Service Unavailable"
)

# Methods
methods=(
  "GET"
  "POST"
  "PUT"
  "PATCH"
  "DELETE"
)

# User agents
user_agents=(
  "Mozilla"
  "Google Chrome"
  "Opera"
  "Safari"
  "Internet Explorer"
  "Microsoft Edge"
  "Crawler and bot"
  "Library and net tool"
)

# Create logs directory if it does not exist
if [ ! -d "$LOGS_DIRECTORY" ]; then
  mkdir "$LOGS_DIRECTORY"
fi

# Generate 5 logs, each for a day
for i in {1..5}; do
  log_file="$LOGS_DIRECTORY/log$i.txt"
  entries_count=$((RANDOM % 900 + 100)) # Random number of entries between 100 and 1000
  

  echo "Generating $entries_count log entries in $log_file"

  # Generate log entries
  for j in $(seq 1 $entries_count); do
    # Generate random data
    ip=$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))
    response_code=${response_codes[RANDOM % ${#response_codes[@]}]}
    method=${methods[RANDOM % ${#methods[@]}]}
    user_agent=${user_agents[RANDOM % ${#user_agents[@]}]}
    url="http://www.example.com/$((RANDOM % 1000 + 1))"
    # Write log entry to the file
    time="$(date | awk '{ print $3 }')/$(date | awk '{ print $2 }')/$(date | awk '{ print $6 }'):$((date) | awk '{ print $4 }')"

    echo "$ip - - [$time +0000] \"$method $url HTTP/1.0\" $response_code \"-\" \"$user_agent\"" >> "$log_file"

    # Increment date
    
  done
done

# $(date | awk '{ print $3 }')/$(date | awk '{ print $2 }')/$(date | awk '{ print $6 }') $(date "+%Y:%m:%d")