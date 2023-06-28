# AWS API Gateway binding to custom domain example using terraform

```
export AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY_HERE>"
export AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_KEY_HERE>"
export TF_VAR_HOSTED_ZONE_ID="<YOUR_ROUTE53_HOSTED_ZONE_ID_HERE>"
export TF_VAR_SUBDOMAIN="apigw-test"

terraform init
terraform plan -out apigw.tfplan
terraform apply apigw.tfplan
```
