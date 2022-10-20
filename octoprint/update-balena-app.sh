#!/bin/sh

set -e

if [ -z $BALENA_API_KEY ]; then
    echo "BALENA_API_KEY is not set. Exiting."
    exit 1
fi

SLEEP_FOR=1
while [ -z $OCTOPRINT_API_KEY ]
do
    echo "OctoPrint API Key not set. Sleeping ${SLEEP_FOR}s..."
    sleep $SLEEP_FOR

    SLEEP_FOR=5
    OCTOPRINT_API_KEY="$(cat /data/config.yaml | grep key: | awk 'BEGIN {OFS = ":"} { print $2 }')"
done


OCTODASH_SI=$(curl -Ss \
    --header "Authorization: Bearer ${BALENA_API_KEY}" \
    --request GET \
    'https://api.balena-cloud.com/v5/service_install?$top=1&$select=id&$filter=device/any(d:d/uuid%20eq%20%27'${BALENA_DEVICE_UUID}'%27)%20and%20installs__service/any(s:s/service_name%20eq%20%27octodash%27)' \
    | jq .d[0].id)

create_api_key() {
    curl -f -Ss \
        --header 'Accept: application/json' \
        --header "Authorization: Bearer ${BALENA_API_KEY}" \
        --header "Content-Type: application/json" \
        --data-raw '{"service_install":'$OCTODASH_SI', "name":"OCTOPRINT_APIKEY", "value":"'$OCTOPRINT_API_KEY'"}' \
        --request POST \
        https://api.balena-cloud.com/v5/device_service_environment_variable
}

patch_api_key() {
    curl -Ss \
        --header 'Accept: application/json' \
        --header "Authorization: Bearer ${BALENA_API_KEY}" \
        --header "Content-Type: application/json" \
        --data-raw '{"value":"'$OCTOPRINT_API_KEY'"}' \
        --request PATCH \
        'https://api.balena-cloud.com/v5/device_service_environment_variable?$top=1&$filter=service_install%20eq%20'$OCTODASH_SI'%20and%20name%20eq%20%27OCTOPRINT_APIKEY%27'
}

create_api_key || patch_api_key

while [ true ]
do
    sleep 1
done
