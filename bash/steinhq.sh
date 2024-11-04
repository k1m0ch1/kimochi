#!/bin/bash

api_url=""
username=""
password=""

add_row_healthcheck(){
    local task="$1"
    local status="$2"
    local output="$3"
    local health_of="$4"
    local started_at="$5"
    local finished_at="$6"

    local running_at
    running_at=$(curl -s ipinfo.io/ip)

    json_payload=$(cat <<EOF
[
    {
        "task": "$task",
        "status": "$status",
        "output": "$output",
        "running_at": "$running_at",
        "health_of": "$health_of",
        "started_at": "$started_at",
        "finished_at": "$finished_at"
    }
]
EOF
)

    # Send the POST request to Steinhq
    curl -X POST "$api_url/Healthcheck" \
        -u "$username:$password" \
        -H "Content-Type: application/json" \
        -d "$json_payload"
}

add_row_servercheckup(){
        local started_at="$(date +"%d-%m-%Y %H:%M:%S")"

        local server_name="$1"

        local server_ip
        server_ip=$(curl -s ipinfo.io/ip)

        local cpu_usage
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

        local memory_usage
        memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

        local disk_usage
        disk_usage=$(df -h / | grep '/' | awk '{print $5}' | sed 's/%//')

        local Uuptime
        Uuptime=$(uptime -p)

        local finished_at="$(date +"%d-%m-%Y %H:%M:%S")"

        json_payload=$(cat <<EOF
[
    {
        "server_name": "$server_name",
        "server_ip": "$server_ip",
        "cpu_usage": $cpu_usage,
        "memory_usage": $memory_usage,
        "disk_usage": $disk_usage,
        "uptime": "$Uuptime",
        "started_at": "$started_at",
        "finished_at": "$finished_at"
    }
]
EOF
)

        curl -X POST "$api_url/ServerCheckup" \
        -u "$username:$password" \
        -H "Content-Type: application/json" \
        -d "$json_payload"

}
