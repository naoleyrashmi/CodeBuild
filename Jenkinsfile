pipeline {
    agent any
    parameters {
        string(name: 'Account_Name', description: 'Please Enter the name of the customer.')
		string(name: 'Region', defaultValue: 'ua-east-2' , description: 'Please select the AWS Region')
        credentials(name: 'CREDENTIALS', description: 'AWS Credentials', credentialType: 'Username with password')       
        string(name: 'PrimePartitionKey', defaultValue: 'DataFlowId' , description: 'HashType PrimaryKey Name')
        string(name: 'PrimePartitionKey1', defaultValue: 'DataFlowId' , description: 'HashType PrimaryKey1 Name')
        string(name: 'PrimePartitionKey2', defaultValue: 'DataFlowId' , description: 'HashType PrimaryKey Name')
        string(name: 'PrimePartitionKey3', defaultValue: 'ConnectionId' , description: 'HashType PrimaryKey Name')
    }
     stages {
        stage('Preparation') {
            steps {
            git 'https://github.com/naoleyrashmi/CodeBuild.git'
            }
        }    
        stage('Deploy App') {
            steps {
                sh (script: '''
                    #!bin/bash
                    aws cloudformation package --template-file parentstack.yaml --s3-bucket rashmi-ohio-sam-demo --output-template-file packaged.yaml
                    aws cloudformation deploy --template-file /var/lib/jenkins/workspace/teghds/packaged.yaml --region us-east-2 --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND --stack-name "InitialSetup-${Account_Name}" --parameter-overrides PrimePartitionKey=${PrimePartitionKey}  PrimePartitionKey1=${PrimePartitionKey1} PrimePartitionKey2=${PrimePartitionKey2} PrimePartitionKey3=${PrimePartitionKey3}
                    ls -lrt
                ''')
            }    
        }
    }
}