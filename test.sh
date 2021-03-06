#!/bin/bash

PARAMETERS_FILE="parameters.json"
PARAMS=($(jq -r '.Parameters[] | [.ParameterKey, .ParameterValue] | "\(.[0])=\(.[1])"' ${PARAMETERS_FILE}))
aws cloudformation deploy --template-file  /codebuild/output/packaged.yaml --region us-east-2 --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND --stack-name InitialSetup --parameter-overrides ${PARAMS[@]}