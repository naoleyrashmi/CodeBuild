```

## NOTE: If the infrastructure is provisioned using the terraform
	we can pick the below from values from the pervious stages, 
	otherwise user need to set TF_VAR_* variables according to
	given the ENV

cd terraform/06-iam

## Set Variables
export VPC_MODULE=00-Infra-Layout/06-iam
export TF_VAR_env_name=${ACCOUNT_NAME}
export TF_VAR_aws_region=${REGION}
export TF_VAR_aws_access_key=${ACCESS_KEY}
export TF_VAR_aws_secret_key=${SECRET_KEY}
export TF_VAR_vpc_backend_bucket=tieto-${ACCOUNT_NAME}-tfstate
export TF_VAR_vpc_backend_key=env/${REGION}/${ACCOUNT_NAME}/${VPC_MODULE}/terraform.tfstate
export TF_VAR_vpc_backend_region=${REGION}

MODULE=00-Infra-Layout/06-iam
terraform init \
	-backend-config="bucket=tieto-${ACCOUNT_NAME}-tfstate" \
	-backend-config="key=env/${REGION}/${ACCOUNT_NAME}/${MODULE}/terraform.tfstate" \
	-backend-config="region=${REGION}"

## Using Plan
terraform plan

## Using Apply
terraform apply

## Using Show
terraform show

```
