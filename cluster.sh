#!/bin/bash

#brew install multipass jq

# multipass delete k3s-controller node1 node2 && multipass purge

# multipass launch --name k3s-controller --cpus 2 --mem 2048M --disk 10G \
# --cloud-init k3s-init
# multipass launch --name node1 --cpus 2 --mem 1024M --disk 10G \
# --cloud-init k3s-init
# multipass launch --name node2 --cpus 2 --mem 1024M --disk 10G \
# --cloud-init k3s-init

output=`multipass list --format json`
length=`echo $output | jq '.list | length'`

hosts="\n"
for ((i=0; i<length; i++))
do
    q=".list[$i].name"; name=`jq -r $q <<< $output`
    q=".list[$i].ipv4[0]"; ipv4=`jq -r $q <<< $output`
    printf -v line "%s %s" $ipv4 $name
    hosts+="${line}\n\r"
    multipass exec $name -- /home/ubuntu/inital-setup.sh "$hosts"
    multipass exec $name -- /home/ubuntu/setup-docker.sh
    multipass exec $name -- /home/ubuntu/setup-kubernetes.sh
done
echo -en "hosts:${hosts}"
