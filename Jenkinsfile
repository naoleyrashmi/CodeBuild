pipeline {
    agent any
    parameters {
		string(name: 'Region', defaultValue: 'ua-east-2' ,description: 'Please select the AWS Region')
        credentials(name: 'CREDENTIALS', description: 'AWS Credentials', credentialType: 'Username with password')       
        string(name: 'Prime-Partition-Key', defaultValue: 'DataFlowId', description: 'HashType PrimaryKey Name')
        string(name: 'Prime-Partition-Key1', defaultValue: 'DataFlowId', description: 'HashType PrimaryKey1 Name')
        string(name: 'Prime-Partition-Key2', defaultValue: 'DataFlowId', description: 'HashType PrimaryKey Name')
        string(name: 'Prime-Partition-Key3', defaultValue: 'ConnectionId', description: 'HashType PrimaryKey Name')
    }
    stages {
        stage('Example') {
            steps {
                echo "${params.Prime-Partition-Key}"
				echo "${params.Prime-Partition-Key1}"
				echo "${params.Prime-Partition-Key2}"
				echo "${params.Prime-Partition-Key3}"
            }
        }
        stage('Preparation') {
            steps {
            git 'https://github.com/naoleyrashmi/CodeBuild.git'
            }
        }    
        stage('Deploy App') {
			environment {
				dynamodbkey = "${params.Prime-Partition-Key}"
				dynamodbkey1 = "${params.Prime-Partition-Key1}"
				dynamodbkey2 = "${params.Prime-Partition-Key2}"
				dynamodbkey3 = "${params.Prime-Partition-Key3}"
				
				
			}
            steps {
                sh (script: '''
                    #!bin/bash
                    aws cloudformation package --template-file parentstack.yaml --s3-bucket rashmi-ohio-sam-demo --output-template-file packaged.yaml
                    aws cloudformation deploy --template-file /var/lib/jenkins/workspace/teghds/packaged.yaml --region us-east-2 --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND --stack-name InitialSetup --parameter-overrides PrimePartitionKey=${dynamodbkey}  PrimePartitionKey1=${dynamodbkey1} PrimePartitionKey2=${dynamodbkey2} PrimePartitionKey3=${dynamodbkey3}
                    ls -lrt
                ''')
            }    
        }
    }
}