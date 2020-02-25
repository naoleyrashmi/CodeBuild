import boto3, botocore, sys, time

def getBotoClient(aws_service, access_key, secret_key, aws_session_token, region):
    client = boto3.client(aws_service,
            region,
            aws_access_key_id=access_key,
            aws_secret_access_key=secret_key,
            aws_session_token=aws_session_token)
    return client

def scaleRDS(access_key, secret_key, aws_session_token, region, db_identifier, db_instance_class):
    try:
        client = getBotoClient("rds", access_key, secret_key, aws_session_token, region)
        response = client.modify_db_instance(
            DBInstanceClass = db_instance_class,
            DBInstanceIdentifier = db_identifier,
            ApplyImmediately=True
        )
        print "Sleeping for 25 seconds.."
        time.sleep(25)
        print "waiting for the db instance to reach available state..."
        waiter = client.get_waiter('db_instance_available')
        waiter.wait(
            DBInstanceIdentifier = db_identifier,
            #Will wait for 30 mins else throw an error
            WaiterConfig={
                'Delay': 30,
                'MaxAttempts': 60
            } 
        )
    except botocore.exceptions.ClientError as e:
        print "Error occured in scaleRDS"
        print e
        exit(1)

if (len(sys.argv) != 7):
    sys.stderr.write("Improper arguments passed")
    sys.stderr.write("Script Usage accountSetup.py <ACCESS_KEY> <SECRET_KEY> <AWS_SESSION_TOKEN> <REGION> <DB_IDENTIFIER> <DB_INSTANCE_CLASS>")
    exit(1)
else:
    access_key = sys.argv[1]
    secret_key = sys.argv[2]
    aws_session_token = sys.argv[3]
    region = sys.argv[4]
    db_identifier = sys.argv[5]
    db_instance_class = sys.argv[6]
    scaleRDS(access_key, secret_key, aws_session_token, region, db_identifier, db_instance_class)