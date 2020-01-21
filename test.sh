#!/bin/bash

PARAMETERS_FILE="parameters.json"
PARAMS=($(jq -r '.Parameters[] | [.ParameterKey, .ParameterValue] | "\(.[0])=\(.[1])"' ${PARAMETERS_FILE}))
aws cloudformation deploy --template-file  C:\codebuild\tmp\output\packaged.yaml --region us-east-2 --capabilities CAPABILITY_IAM --stack-name test1234 --parameter-overrides ${PARAMS[@]}