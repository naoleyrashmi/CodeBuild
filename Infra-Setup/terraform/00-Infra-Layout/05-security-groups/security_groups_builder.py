# This Python file uses the following encoding: utf-8
import yaml, sys

# please note, do not change indentation, 
# terraform job is failing if it not genearate main.yml in propper format

############################# Read the data file ###################################
# sg_data = yaml.load(urllib2.urlopen(sys.argv[1]).read())
with open(sys.argv[1]) as sg_file:
	sg_data = yaml.load(sg_file)
############################# Required Security groups #############################
sg_keys = ('vpn_sg', 'app_sg', 'db_sg', 'rds_migration_sg', 'app_lb_sg')
sg_rule_keys_cidr = ('description', 'type', 'from_port', 'to_port', 'protocol', 'cidr_blocks')
sg_rule_keys_source_sg = ('description', 'type', 'from_port', 'to_port', 'protocol', 'source_sg')

############################# Main TF file ######################################
main_tf_file_contents = open("main_template.txt").read()

############################# Security group template ######################################
aws_security_group_template = '''
resource "aws_security_group" "{sg_name}" {openingBrace}
  name        = "{sg_name}"
  vpc_id      = "${openingBrace}data.terraform_remote_state.vpc.aws_vpc.vpc.id{closingBrace}"
  description = "{sg_description}"

  tags {openingBrace}
    Name = "{sg_name}"
    project_id         = "${openingBrace}var.project_id{closingBrace}"
    assets_expity_date = "${openingBrace}var.assets_expity_date{closingBrace}"
    build_user         = "${openingBrace}var.build_user{closingBrace}"
    build_user_email   = "${openingBrace}var.build_user_email{closingBrace}"
  {closingBrace}
{closingBrace}
'''

############################# Security group rule template ######################################
aws_security_group_rule_cidr = '''
resource "aws_security_group_rule" "{rule_name}" {openingBrace}
  type        = "{type}"
  from_port   = {from_port}
  to_port     = {to_port}
  protocol    = "{protocol}"
  cidr_blocks = {cidr_blocks}
  description = "{description}"

  security_group_id = "${openingBrace}aws_security_group.{sg_name}.id{closingBrace}"
{closingBrace}
'''

aws_security_group_rule_source_sg = '''
resource "aws_security_group_rule" "{rule_name}" {openingBrace}
  type        = "{type}"
  from_port   = {from_port}
  to_port     = {to_port}
  protocol    = "{protocol}"
  source_security_group_id = "${openingBrace}aws_security_group.{source_sg}.id{closingBrace}"
  description = "{description}"

  security_group_id = "${openingBrace}aws_security_group.{sg_name}.id{closingBrace}"
{closingBrace}
'''

#######################################################################################
# check if required security groups are available in yml data or return
# if all security groups got itterate through it and make aws_security_groups
# then iterrate through sg rules and check for keys. If it is valid add it in main file
#######################################################################################

if set(sg_keys).issubset(sg_data):
    for sg_name, sg in sg_data.items():
        sg["description"] = sg["description"] or (sg_name + " description")
        sg["sg_rules"] = sg["sg_rules"] or []
        var_map = { "sg_name": sg_name, "sg_description": sg["description"], "openingBrace": "{", "closingBrace": "}" }
        main_tf_file_contents += aws_security_group_template.format(**var_map)
        
        for sg_rule in sg["sg_rules"]:
            sg_rule["openingBrace"] = "{"
            sg_rule["closingBrace"] = "}"
            sg_rule["sg_name"] = sg_name

            if set(sg_rule_keys_cidr).issubset(sg_rule):
                sg_rule["cidr_blocks"] = '["' + '","'.join(sg_rule["cidr_blocks"]) + '"]'
                main_tf_file_contents += aws_security_group_rule_cidr.format(**sg_rule)
            elif set(sg_rule_keys_source_sg).issubset(sg_rule):
                main_tf_file_contents += aws_security_group_rule_source_sg.format(**sg_rule)
            else:
                print("Security group rules are not valid :" + sg_name)
                sys.exit(1)
else:
    print("Required Security groups not found in YML data")
    sys.exit(1)

main_file = open("main.tf", "w")
main_file.write(main_tf_file_contents)
main_file.close()

print "main file written"