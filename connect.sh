#!/bin/bash

VM="$1"
IP=$(arp -an | grep "`virsh dumpxml $VM | grep "mac address" | sed "s/.*'\(.*\)'.*/\1/g"`" | awk '{ gsub(/[\(\)]/,"",$2); print $2 }');
echo "$1 has an IP of $IP"
echo "ssh -i cloud/$1/config/sshkey ubuntu@$IP"
#ssh -i cloud/$1/config/sshkey ubuntu@$IP
