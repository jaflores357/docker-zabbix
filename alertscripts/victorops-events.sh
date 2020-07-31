#!/bin/bash

to=$1
type_subject=$2
body=$3
log="/var/log/zabbix/victorops.$(date +"%Y%m%d".log)"

REST_ENDPOINT_KEY=${to}
ROUTING_KEY="Example"

type=$(echo "${type_subject}" | cut -d":" -f1)
subject=$(echo "${type_subject}" | cut -d":" -f2-)

incident_id="${subject}"


case $type in
"t")
  incident_type="CRITICAL"
;;
"a")
  incident_type="ACKNOWLEDGEMENT"
;;
"r")
  incident_type="RECOVERY"
;;
"i")
  incident_type="INFO"
;;
esac

echo -e "\n$(date +"%F %T") -- ${incident_type}" >> ${log}
cat <<EOF | /bin/bash  >> ${log}
curl -s -X POST -d '{ \
    "entity_id":"${incident_id}", \
    "message_type":"${incident_type}", \
    "state_message":"${body}" \
}' https://alert.victorops.com/integrations/generic/20131114/alert/${REST_ENDPOINT_KEY}/${ROUTING_KEY}
EOF

