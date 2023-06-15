#!/bin/bash

if [[ $# -eq 0 ]];
then
    exit 1
fi


ips=$1
subs=$2


for ip in $(cat $ips);do echo $ip &&  ffuf -w $subs -u http://$ip -H "Host: FUZZ" -s -mc 200 >>/tmp/origin-ips; done
