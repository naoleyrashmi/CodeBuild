#!/bin/bash

export TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID}
export TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_token=${AWS_SESSION_TOKEN}
export TF_VAR_aws_region=${REGION}
export TF_VAR_db_instance_identifier=${DB_INSTANCE_IDENTIFIER}
export TF_VAR_db_snapshot_identifier=${DB_SNAPSHOT_IDENTIFIER}

../../../ci/run.sh $(dirname $(pwd))