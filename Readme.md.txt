aws cloudformation package --template-file parentstack.yaml --s3-bucket rashmi-ohio-sam-demo --output-template-file packaged.yaml  



aws cloudformation deploy --template-file D:\Projects\API-Gateway\packaged.yaml --region us-east-2 --stack-name nestedlambda --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND  --parameter-overrides S3BucketName=rashmi-ohio-sam-demo S3KeyName=MeghFlow-DBConnMgmt-Lambda-DBConnMgmtFunction.zip  HandlerName=com.xoriant.meghflow.dbconnmgmt.lambda.DBConnMgmtLambda::handleRequest apiGatewayStageName=dev


aws cloudformation package --template-file parentstack.yaml --s3-bucket rashmi-ohio-sam-demo --output-template-file packaged.yaml

aws cloudformation deploy --template-file D:\Projects\MeghFlow\NestedStack\packaged.yaml --region us-east-2 --stack-name testingsetup --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND  --parameter-overrides S3KeyName=MeghFlow-DBConnMgmt-Lambda-DBConnMgmtFunction.zip  HandlerName=com.xoriant.meghflow.dbconnmgmt.lambda.DBConnMgmtLambda::handleRequest AccountName=citi17263 PrimePartitionKey=DataFlowId  PrimePartitionKey1=DataFlowId PrimePartitionKey2=DataFlowId PrimePartitionKey3=ConnectionId