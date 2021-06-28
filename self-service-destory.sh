#!/bin/bash
CLIENT_NAME="y3-new"

NUMBER_CLUSTERS=2

for i in {1..1}
do
    export NAME="$CLIENT_NAME-$i.jb.io"
    echo "the name is $NAME"
    export KOPS_STATE_STORE="s3://jb-cloud-terraform-vpc-remote-state"
    export ZONES="eu-west-1b"
    export NETWORK_CIDR=10.60.0.0/16
    cd $CLIENT_NAME/clusters/cluster-$i/ 
    #terraform destroy -force
    kops delete cluster --name=$CLIENT_NAME-$i.jb.io --yes
    echo "Dir on exit"
    cd ../../../
    pwd
        
done


