#!/bin/bash

instanceTagName=$2
nameSpace=$3
region=$4
url=$5


metric(){
res=$(sudo curl "$url")
if [ "$res" == "App status: 200" ];then
    status=1
else
    status=0
fi
aws cloudwatch put-metric-data --region "$region" --metric-name "Container status $instanceTagName"  --value "$status"  --namespace "$nameSpace"
}

init(){
sudo touch crontabs
echo "* * * * * /metric-script.sh metric $instanceTagName $nameSpace $region  $url" >> crontabs
echo "* * * * * sleep 30 && /metric-script.sh metric $instanceTagName $nameSpace $region  $url" >> crontabs
crontab /crontabs
}
$1