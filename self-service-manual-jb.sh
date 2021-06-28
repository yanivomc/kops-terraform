#!/bin/bash
# source ~/.bash_profile

CLIENT_NAME="yaniv-new"
NUMBER_CLUSTERS=$1
VPC="vpc-d7d6e4b1" # jb account
SUBNET_ID_A="subnet-e66c0380" # jb account
DNS_ZONE=Z3S7L7JR4B7VHI


for i in {1..1}

do
    export NAME="$CLIENT_NAME-$i.jb.io"
    echo "the name is $NAME"
    export VPC_ID="vpc-d7d6e4b1"
    export KOPS_STATE_STORE="s3://jb-cloud-terraform-vpc-remote-state"
    export ZONES="eu-west-1b"
    # export NETWORK_CIDR=172.31.32.0/20
    echo "Creating folder"
    mkdir -p ./$CLIENT_NAME/clusters/cluster-$i
    cp *.tf ./$CLIENT_NAME/clusters/cluster-$i
    kops create cluster \
                --master-zones $ZONES \
                --dns private \
                --dns-zone $DNS_ZONE \
                --master-size=t3.large \
                --node-size=t3.large \
                --zones $ZONES \
                --topology public \
                --node-count=1 \
                --master-count=1 \
                --master-volume-size=16 \
                --node-volume-size=16 \
                --networking=calico  \
                --out=./$CLIENT_NAME/clusters/cluster-$i/ \
                --target=terraform \
                --vpc $VPC \
                --ssh-public-key ~/.ssh/id_rsa.pub \
                --subnets $SUBNET_ID_A \
                ${NAME}
    sed -i 's/jb-cloud-infra-k8s/jb-cloud-infra-k8s-'$CLIENT_NAME'-'$i'a/g' ./$CLIENT_NAME/clusters/cluster-$i/s3_state.tf
    
    sed -i '/user_data/a instance_market_options {\n market_type = "spot" \n spot_options {\n  max_price = "0.070"\n}\n}' ./$CLIENT_NAME/clusters/cluster-$i/kubernetes.tf
    
    echo "Welcome ${NAME} cluster number $i"
    
    cd $CLIENT_NAME/clusters/cluster-$i/
    terraform init -input=false
    terraform workspace new jb-eu-west-1 || true
    terraform workspace select jb-eu-west-1 || true
    terraform plan -out=tfplan -input=false 
    terraform apply -input=false tfplan 
    echo "Dir on exit"
    cd ../../../
    pwd
    
done



# echo "Printing all Master IP's for cluster $CLIENT_NAME-$i.jb.io"
aws ec2 describe-instances --region=eu-west-1 --query 'Reservations[*].Instances[*].[PublicIpAddress]' --filters Name=tag:'k8s.io/role/master',Values=1 Name=tag:'KubernetesCluster',Values="$CLIENT_NAME-*.jb.io" --output text | sort -k2f
