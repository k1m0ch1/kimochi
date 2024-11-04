#!/bin/bash

# Discord webhook URL
webhook_url=""

send_alert() {
    local message_content="$1"

    # JSON payload
    json_payload=$(cat <<EOF
{
    "content": "$message_content"
}
EOF
)

    curl -X POST "$webhook_url" \
        -H "Content-Type: application/json" \
        -d "$json_payload"
}
