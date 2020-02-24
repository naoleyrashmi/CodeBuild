pipeline {
    agent any
    parameters {
        string(name: 'Region', defaultValue: 'ua-east-2' ,description: 'Please select the AWS Region')
        credentials(name: 'CREDENTIALS', description: 'AWS Credentials', credentialType: "Username with password")
        // booleanParam(name: 'APPLY_CHANGES', description: 'If not opted, it will be dry run')
        string(name: "Prime-Partition-Key", defaultValue: 'DataFlowId', description: "HashType PrimaryKey Name")
        string(name: "Prime-Partition-Key1", defaultValue: 'DataFlowId', description: "HashType PrimaryKey1 Name")
        string(name: "Prime-Partition-Key2", defaultValue: 'DataFlowId', description: "HashType PrimaryKey Name")
        string(name: "Prime-Partition-Key3", defaultValue: 'ConnectionId', description: "HashType PrimaryKey Name")
    }
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.Prime-Partition-Key}"

                echo "Biography: ${params.Region}"

                echo "Toggle: ${params.Prime-Partition-Key1}"

                echo "Choice: ${params.Prime-Partition-Key2}"

                echo "Password: ${params.Prime-Partition-Key3}"
            }
        }
    }
}