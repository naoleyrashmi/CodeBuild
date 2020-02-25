#Work In Progress# This Python file uses the following encoding: utf - 8

import boto3, botocore, sys, yaml, os
from pathlib import Path

#################### Download the file from S3####################
def download_file_from_S3(access_key, secret_key, aws_session_token, region, bucket_name, key_of_folder, file_name):
	session = boto3.Session(
		aws_access_key_id = access_key,
		aws_secret_access_key = secret_key,
		aws_session_token = aws_session_token,
		region_name = region
	)

	s3 = session.resource('s3')
	bucket = s3.Bucket(bucket_name)
	if not(key_of_folder.endswith("/")):
		key_of_folder = key_of_folder + "/"

	db_dump_info_key = key_of_folder + file_name
	print "file to download is " + db_dump_info_key

	try:
		s3.Bucket(bucket_name).download_file(db_dump_info_key, file_name)
	except botocore.exceptions.ClientError as e:
		if e.response['Error']['Code'] == "404":
			sys.stderr.write("File " + file_name + " not present in the S3 bucket " + bucket_name + " at location " +key_of_folder)
			exit(1)
		else :
			sys.stderr.write("Error occured while downloading " + file_name + "from S3 bucket " + bucket_name)
			print e
			print e.response
			sys.stderr.write("One of the Possible reason invalid Credentials")
			exit(1)
	return


funname = sys.argv[1]
if( funname in ["download_file_from_s3"]):
	if (len(sys.argv) != 9):
		sys.stderr.write("Improper arguments passed")
		sys.stderr.write("Script Usage migration.py "+ funname +" <ACCESS_KEY> <SECRET_KEY> <SESSION_TOKEN> <REGION> <bucket_name> <key_of_folder> <file_name>")
		exit(1)
	else:
		access_key = sys.argv[2]
		secret_key = sys.argv[3]
		aws_session_token = sys.argv[4]
		region = sys.argv[5]
		bucket_name = sys.argv[6]
		key_of_folder = sys.argv[7]
		file_name = sys.argv[8]

else:
	sys.stderr.write("Function " + funname + " not supported \n ")
	sys.stderr.write("Supported functions are validate_dump_info, get_ami, get_rds_size, get_bridge_instance_size, get_tablespaces, download_file_from_s3, get_all_sql, get_impdp_command, get_default_tablespace_names")
	exit(1)


if (funname == "download_file_from_s3"):
	download_file_from_S3(access_key, secret_key, aws_session_token, region, bucket_name, key_of_folder, file_name)

else:
    sys.stderr.write("Function " + funname + " not supported \n ")
exit()
