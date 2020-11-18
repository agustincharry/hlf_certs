#!/bin/bash
instanceTagName=$1
nameSpace=$2
region=$3
arnTopic=$4
aws cloudwatch put-metric-alarm  --region $region --alarm-name "Container status $instanceTagName" \
    --alarm-description "If the container named $instanceTagName is down this alarm is triggered" \
    --metric-name "Container status $instanceTagName" --namespace $nameSpace \
    --statistic Average --period 30 --threshold 1 --comparison-operator LessThanThreshold \
    --evaluation-periods 1  --alarm-actions $arnTopic