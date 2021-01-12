#!/bin/bash
OU=$1
CN=$2
#arn:aws:acm-pca:us-east-1:872308410481:certificate-authority/ee2eadae-1a4e-4034-9f22-cc2626854c20
CERTIFICATE_AUTHORITY_ARN=$3
#"us-east-1"
REGION=$4
#arn:aws:acm-pca:::template/EndEntityCertificate/V1
TEMPLATE_ARN=$5
#365
EXPIRACION=$6
CERTIFICATE_SECRET=$7

openssl ecparam -genkey -out private.pem -name prime256v1
openssl req -new -key private.pem -out request1.csr -subj "/C=CO/ST=ANTIOQUIA/L=MEDELLIN/O=BANCOLOMBIA S.A./OU=$OU/CN=$CN"
echo ----- REQUEST CERTIFICATE $CN-----
ARN_CERTIFICATE=$(aws acm-pca issue-certificate --region $REGION --certificate-authority-arn $CERTIFICATE_AUTHORITY_ARN --csr file://./request1.csr --signing-algorithm "SHA256WITHECDSA" --template-arn $TEMPLATE_ARN  --validity Value=$EXPIRACION,Type="DAYS" --profile acm-pca-blockchain | jq -r .CertificateArn)
echo $ARN_CERTIFICATE
aws secretsmanager put-secret-value --region $REGION --secret-id $CERTIFICATE_SECRET --secret-string $ARN_CERTIFICATE