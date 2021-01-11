echo ------ ARN_CERTIFICATE_AUTHORITY -------------------
#aws configure set credential_source Environment --profile acm-pca-blockchain
aws configure set source_profile default --profile acm-pca-blockchain
aws configure set role_arn arn:aws:iam::872308410481:role/acm-pca-blockchain-dev --profile acm-pca-blockchain
#sudo cat ~/.aws/config

#aws acm-pca describe-certificate-authority  --region "us-east-1" --certificate-authority-arn arn:aws:acm-pca:us-east-1:872308410481:certificate-authority/ee2eadae-1a4e-4034-9f22-cc2626854c20 --profile acm-pca-blockchain
    
openssl ecparam -genkey -out private.pem -name prime256v1
openssl req -new -key private.pem -out request1.csr -subj "/C=CO/ST=ANTIOQUIA/L=MEDELLIN/O=BANCOLOMBIA S.A./OU=orderer/CN=orderer-interoperabilidad-dev.apps.ambientesbc.com"

echo -----solicitud -----
ARN_CERTIFICATE=$(aws acm-pca issue-certificate --region "us-east-1" --certificate-authority-arn arn:aws:acm-pca:us-east-1:872308410481:certificate-authority/ee2eadae-1a4e-4034-9f22-cc2626854c20 --csr file://./request1.csr --signing-algorithm "SHA256WITHECDSA" --template-arn "arn:aws:acm-pca:::template/EndEntityCertificate/V1" --validity Value=365,Type="DAYS" --profile acm-pca-blockchain)
echo $ARN_CERTIFICATE ---
#aws acm-pca get-certificate --region "us-east-1" --certificate-authority-arn arn:aws:acm-pca:us-east-1:872308410481:certificate-authority/ee2eadae-1a4e-4034-9f22-cc2626854c20 --certificate-arn $ARN_CERTIFICATE --profile acm-pca-blockchain

CERTIFICATE_SECRET=nu0094001-blockchain-dev-ECDSATest
aws secretsmanager put-secret-value --secret-id $CERTIFICATE_SECRET --secret-string $ARN_CERTIFICATE