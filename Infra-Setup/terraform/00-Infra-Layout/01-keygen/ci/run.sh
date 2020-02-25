#!/bin/bash

export TF_VAR_aws_region=${REGION}
export TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID}
export TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_token=${AWS_SESSION_TOKEN}
export TF_VAR_aws_key_name=${KEY_NAME}
export TF_VAR_aws_public_key_path=${PUBLIC_KEY_PATH}

../../../utility/ci/run.sh $(dirname $(pwd))
