#!/bin/bash

# Step 1: Disable SSL warnings
export PYTHONWARNINGS="ignore:Unverified HTTPS request"

# Step 2: Set variables for the components of the request
IP_ADDRESS="192.168.56.107"
RESTCONF_USERNAME="cisco"
RESTCONF_PASSWORD="cisco123!"
API_URL="https://${IP_ADDRESS}/restconf/data/ietf-interfaces:interfaces"

# Step 3: Send the request and store the JSON response
RESPONSE=$(curl -v -k -u "${RESTCONF_USERNAME}:${RESTCONF_PASSWORD}" -H "Accept: application/yang-data+json" -H "Content-type: application/yang-data+json" "${API_URL}")

# Print the response for debugging
echo "Response:"
echo "${RESPONSE}"

# Step 4: Format and display the JSON data received
echo "${RESPONSE}" | jq .