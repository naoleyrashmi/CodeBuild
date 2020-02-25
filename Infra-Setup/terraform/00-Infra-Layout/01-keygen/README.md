
```
## Note: 
We are not using this step for now. This step kept here for ssh key management (In Jenkinsfile commented run.sh). 
There are 2 ways to manage keys. First, one is imported a key in aws console (Upload our public key) and second is let aws create key and we download the private key (But this download allows only once.)

Here 2 shell script files present 
key_create_local.sh creates the key pair locally. We can upload it in aws with help of terraform script written in main.tf
aws_key_create.sh creates the key with aws-cli and save the private key locally (in JSON format)

We need to decide where we want to manage keys manually or in an automated way. If we choose automation, we need to decide which way we will create keys. 


## NOTE: If the infrastructure is provisioned using the terraform
	we can pick the below from values from the pervious stages, 
	otherwise user need to set TF_VAR_* variables according to
	given the ENV

cd terraform/01-keygen

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

MODULE=00-Infra-Layout/01-keygen
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
