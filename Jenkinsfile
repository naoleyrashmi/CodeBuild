node {
   def mvnHome
//    try {
        stage ("Get parameters"){
            // checkout scm
            List props = []
            List params = [
                // string(name: 'Account_Name', description: 'Please Enter the name of the customer.'),
                choice(name: 'Region', description: 'Please select the AWS Region', choices: 'eu-west-1\neu-west-2\neu-west-3\neu-central-1\nus-west-1\nus-west-2\nus-east-2\nus-east-1\nap-northeast-1\nap-northeast-2\nap-northeast-3\nap-south-1\nap-southeast-1\nap-southeast-2\nca-central-1\ncn-north-1\ncn-northwest-1\nsa-east-1'),
                credentials(name: 'CREDENTIALS', description: 'AWS Credentials', credentialType: "Username with password"),
                // string(name: 'Xoriant_ENV_Name', description: 'Please Enter the env for which you want to deploy the db (ref/ci/dev) (Note: Only lowercase values allowed).'),
                booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'If not opted, it will be dry run'),
                string(name: "Prime-Partition-Key", description: "HashType PrimaryKey Name"),
                string(name: "Prime-Partition-Key1", description: "HashType PrimaryKey1 Name"),
                string(name: "Prime-Partition-Key2", description: "HashType PrimaryKey Name"),
                string(name: "Prime-Partition-Key3", description: "HashType PrimaryKey Name")
            ]
        }

        stage("collect params for app deploy") {
            sh (script: '''
                #!/bin/bash
                export AccountName=${Account_Name}
                export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} 
                export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                export REGION=${Region}
            ''')
    }

                
        stage('Preparation') { 
            git 'https://github.com/naoleyrashmi/CodeBuild.git'
    
   }
        stage("Deploy App") {
            sh (script: '''
                #!bin/bash
                aws cloudformation package --template-file parentstack.yaml --s3-bucket rashmi-ohio-sam-demo --output-template-file packaged.yaml
                aws cloudformation deploy --template-file /var/lib/jenkins/workspace/teghds/packaged.yaml --region us-east-2 --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND --stack-name InitialSetup --parameter-overrides PrimePartitionKey=${Prime-Partition-Key}  PrimePartitionKey1=${Prime-Partition-Key1} PrimePartitionKey2=${Prime-Partition-Key2} PrimePartitionKey3=${Prime-Partition-Key3}
            
            ls -lrt
        ''')
    }    

}   