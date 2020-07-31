#!/bin/bash

key=$1
message_type=$2
details=$3
logfile="/var/log/zabbix/zabbix-pagerduty.log"

echo "curl -H 'Content-Type: text/plain'  -X PUT --data-binary \"${details}\" \"http://admin:admin@172.18.3.20:4567/zabbix/pagerduty/send/${message_type}\"" >> ${logfile}
curl -H 'Content-Type: text/plain'  -X PUT --data-binary "${details}" "http://admin:admin@172.18.3.20:4567/zabbix/pagerduty/send/${message_type}"


