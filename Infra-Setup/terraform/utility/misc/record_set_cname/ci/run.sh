#!/bin/bash

export TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID}
export TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_token=${AWS_SESSION_TOKEN}
export TF_VAR_aws_region=${REGION}
export TF_VAR_hosted_zone_type=${HOSTED_ZONE_TYPE}
export TF_VAR_record_set_name=${RECORD_SET_NAME}
export TF_VAR_record_set_record=${RECORD_SET_RECORD}
export TF_VAR_record_set_ttl=300
export TF_VAR_hosted_zone_backend_bucket=tieto-${ACCOUNT_NAME}-tfstate
export HOSTED_ZONE_MODULE=00-Infra-Layout/04-hosted-zone/
export TF_VAR_hosted_zone_backend_key=env/${REGION}/${ACCOUNT_NAME}/${HOSTED_ZONE_MODULE}/terraform.tfstate
export TF_VAR_hosted_zone_backend_region=${REGION}

../../../ci/run.sh $(dirname $(pwd))
