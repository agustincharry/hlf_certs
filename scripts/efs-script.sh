#!/bin/bash
applicationcode=$1
project=$2
environment=$3
region=$4
pInstanceTagName=$5


sudo yum install -y amazon-efs-utils
sudo yum install -y nfs-utils

export MOUNT_POINT=/var/hyperledger/production/
sudo mkdir -p $MOUNT_POINT
sudo mkdir -p /etc/efs/
export FILE_SYSTEM_PARAMETER="/$applicationcode-$project-$environment-arn/efs_file_system"
export FILE_SYSTEM_ARN=$(aws ssm get-parameter --name $FILE_SYSTEM_PARAMETER | jq -r ".Parameter.Value" )
export MOUNT_TARGET_DNS=$FILE_SYSTEM_ARN.efs.$region.amazonaws.com
echo ------------MOUNT_TARGET_DNS------------------
echo $MOUNT_TARGET_DNS
echo ----------------------------------------------
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $MOUNT_TARGET_DNS:/ /etc/efs/
sudo mkdir -p /etc/efs/$pInstanceTagName
sudo umount $MOUNT_TARGET_DNS:/
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $MOUNT_TARGET_DNS:/$pInstanceTagName $MOUNT_POINT
echo $FILE_SYSTEM_ARN:/$pInstanceTagName $MOUNT_POINT efs _netdev,tls,iam 0 0 >> /etc/fstab
echo -------------/etc/fstab-----------------
cat /etc/fstab
echo ----------------------------------------