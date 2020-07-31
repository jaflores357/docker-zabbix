#!/bin/bash

to=$1
type_subject=$2
body=$3
log="/var/log/zabbix/pagerduty-events.$(date +"%Y%m%d".log)"

type=$(echo "${type_subject}" | cut -d":" -f1)
dedup_key=$(echo "${type_subject}" | cut -d":" -f2)
hostname=$(echo "${type_subject}" | cut -d":" -f3)
trigger_desc=$(echo "${type_subject}" | cut -d":" -f4-)
subject="${hostname%%.*} - ${trigger_desc}"

case $type in
"t")
echo -e "\n$(date +"%F %T") -- Trigger" >> ${log}
cat <<EOF | tee -a ${log} | /bin/bash
curl -s -X POST \
--header 'Content-Type: application/json' \
-d '{
"routing_key": "${to}", 
"event_action": "trigger", 
"dedup_key": "${dedup_key}", 
"payload": {
    "summary": "${subject}", 
    "severity": "critical", 
    "source": "api",
    "custom_details": {
    ${body}
    }
}
}' 'https://events.pagerduty.com/v2/enqueue'
EOF
;;
"a")
echo -e "\n$(date +"%F %T") -- Acknowledge" >> ${log}
cat <<EOF | tee -a ${log} | /bin/bash
curl -s -X POST --header 'Content-Type: application/json' \
-d'{
    "routing_key": "${to}", 
    "event_action": "acknowledge", 
    "dedup_key": "${dedup_key}" 
}' 'https://events.pagerduty.com/v2/enqueue'
EOF
;;
"r")
echo -e "\n$(date +"%F %T") -- Resolve" >> ${log}
cat <<EOF | tee -a ${log} | /bin/bash
curl -s -X POST --header 'Content-Type: application/json' \
-d'{
    "routing_key": "${to}", 
    "event_action": "resolve", 
    "dedup_key": "${dedup_key}" 
}' 'https://events.pagerduty.com/v2/enqueue'
EOF
;;
esac




