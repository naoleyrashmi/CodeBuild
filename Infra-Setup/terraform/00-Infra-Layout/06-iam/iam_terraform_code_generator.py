# This Python file uses the following encoding: utf-8
import yaml, sys, urllib2

# please note, do not change indentation, 
# terraform job is failing if it not genearate main.yml in propper format

############################# Read the data file ###################################
with open(sys.argv[1]) as iam_yaml_data:
	iam_data = yaml.load(iam_yaml_data)

############################# iam policy template ######################################
# Note here: while parsing templete it confuses with '{' and '}', 
# handeled this with openingBrace and closingBrace variables

aws_iam_policy_template = '''
resource "aws_iam_policy" "{policy_name}" {openingBrace}
	name = "{policy_name}"
	description = "My test policy"
	policy = <<EOF
{openingBrace} 
	"Version": "2012-10-17", 
	"Statement": [{openingBrace}
		"Action": [{actions}],
		"Effect": "Allow",
		"Resource": "*"
    {closingBrace}]
{closingBrace}
EOF
{closingBrace}

'''

############################# iam group template ######################################
aws_iam_group_template = '''
resource "aws_iam_group" "{group_name}" {openingBrace}
  name = "{group_name}"
{closingBrace}

'''

############################# iam group policy attachement template #####################
aws_iam_group_policy_attachment_template = '''
resource "aws_iam_group_policy_attachment" "{attach_name}" {openingBrace}
  group     = "${openingBrace}aws_iam_group.{group_name}.name{closingBrace}"
  policy_arn = "${openingBrace}aws_iam_policy.{policy_name}.arn{closingBrace}"
{closingBrace}

'''

############################# iam group membership template ############################
aws_iam_group_membership = '''
resource "aws_iam_group_membership" "{membership_name}" {openingBrace}
  name = "{membership_name}"
  users = [{user_names}]
  group = "${openingBrace}aws_iam_group.{group_name}.name{closingBrace}"
{closingBrace}

'''

############################# generate main file ########################################
# itterate through groups and add parsed content in terraform file string
main_tf_file_contents = '''
terraform {
  backend "s3" {}
}

provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token      = "${var.token}"
}

'''

for group_name, group_data in iam_data["groups"].items():
	group_data = group_data or {}
	group_data = { True:{}, False: group_data}[isinstance(group_data, list)]
	users = group_data.get('users', [])
	var_map = {
		"group_name": group_name,
		"user_names": '"' + '","'.join(users) + '"',
		"membership_name": group_name + "-users",
		"openingBrace": "{",
		"closingBrace": "}"
	}
	
	main_tf_file_contents += aws_iam_group_template.format(**var_map)
	
	if len(users) > 0:
		main_tf_file_contents += aws_iam_group_membership.format(**var_map)
	

# itterate through policies and add parsed content in terraform file string
for policy_name, policy_rules in iam_data["policies"].items():
	var_map = {
		"policy_name": policy_name,
		"actions": '"' + '","'.join(policy_rules) + '"',
		"openingBrace": "{",
		"closingBrace": "}"
	}
	main_tf_file_contents += aws_iam_policy_template.format(**var_map)

# attach policies to the groups
for group_name, group_data in iam_data["groups"].items():
	group_data = group_data or {}
	group_data = { True:{}, False: group_data}[isinstance(group_data, list)]
	policies = group_data.get('policies', [])
	var_map = {
		"group_name": group_name,
		"openingBrace": "{",
		"closingBrace": "}",
	}
	for policy in policies:
		var_map["policy_name"] = policy
		var_map["attach_name"] = policy + "-" + group_name
		main_tf_file_contents += aws_iam_group_policy_attachment_template.format(**var_map)

############################ Write data to main file ##################################
main_tf_file = open("main.tf", "w")
main_tf_file.writelines(main_tf_file_contents)
main_tf_file.close()
print("terraform file for Iam written successfully.")
