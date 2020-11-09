#!/bin/bash

instanceTagName=$2
nameSpace=$3
region=$4
url=$5
path=$6


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
sudo touch /ruta2.txt
sudo echo $path/metric-script.sh >> /ruta2.txt
sudo echo $region >> /ruta2.txt
sudo touch $path/crontabs
echo "* * * * * $path/metric-script.sh metric $instanceTagName $nameSpace "$region"  $url" >> $path/crontabs
echo "* * * * * sleep 30 && $path/metric-script.sh metric $instanceTagName $nameSpace "$region"  $url" >> $path/crontabs
crontab $path/crontabs
}
$1
