# Extracts the (access) token via regex from oauth2 authentication responses.
# How to use
# The scripts contain a configuration part inside. Just put in the necessary variables and execute the script from a shell.

#!/bin/sh

# Configuration -> START
client_id=<CLIENT_ID>
client_secret=<CLIENT SECRET>
auth_endpoint=<AUTH_ENDPOINT> #e.g. https://www.myendpoint.com/token
authed_target_url=<TARGET_URL> #e.g. https://mybackend.com/endpoint
# Configuration -> END

# Authorize to get the token
printf "\nGetting the access token...\n\n"
response=$(curl -X POST ${auth_endpoint} \
	-H 'content-type: application/x-www-form-urlencoded' \
	-d grant_type=client_credentials \
	-d client_id=${client_id} \
	-d client_secret=${client_secret})

# Regex to filter out the token
regex="\"access_token\":\"([^\"]+)\""

if [[ $response =~ $regex ]]
then
	name="${BASH_REMATCH[1]}"
	printf "\nAccessToken:\n${name}"
	token="${name}"
else
	printf "$response doesn't match" >&2 # this could throw a lot o entries if there are no matches
fi

# Call any endpoint authorized with the token
curl -H "Authorization:Bearer ${token}" ${authed_target_url}