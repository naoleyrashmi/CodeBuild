```

## NOTE: If the infrastructure is provisioned using the terraform
	we can pick the below from values from the pervious stages, 
	otherwise user need to set TF_VAR_* variables according to
	given the ENV

cd terraform/05-s3

## Set Variables
export TF_VAR_env_name=${ACCOUNT_NAME}
export TF_VAR_aws_region=${REGION}
export TF_VAR_aws_access_key=${ACCESS_KEY}
export TF_VAR_aws_secret_key=${SECRET_KEY}
export TF_VAR_az_zone_1a=${REGION}a
export TF_VAR_az_zone_1b=${REGION}b
export TF_VAR_vpc_cidr=${VPC_CIDR}
export TF_VAR_private_subnet_cidr_az_a=${PRIVATE_SUBNET_CIDR_AZ_A}
export TF_VAR_private_subnet_cidr_az_b=${PRIVATE_SUBNET_CIDR_AZ_B}
export TF_VAR_public_subnet_cidr_az_a=${PUBLIC_SUBNET_CIDR_AZ_A}
export TF_VAR_public_subnet_cidr_az_b=${PUBLIC_SUBNET_CIDR_AZ_B}
export TF_VAR_hosted_zone=${HOSTED_ZONE}

MODULE=00-Infra-Layout/03-s3
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
