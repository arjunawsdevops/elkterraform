###################### Ec2 Instance with ELK Stack ################################
Prerequirements:
Terraform, IAM user with AccessKey SecretKey

#################### To Install Terraform and Packer ############################

$apt install terraform
$terraform init
Copy Pem File to terraform-elk folder (main folder)
#################################################################################
Changes in main.tf file:
Change Password as required in line 53 htaccess

#################################################################################
Changes in var.tfvars file:

region                 : AWS Region             
access_key             : Access Key 
secret_key             : Secret Key
instance_type          : Instance Type ex: m5.large
server_count           : By Default 1
ami 		           : AMI ID for specific refion
subnet_id              : required subnet ID
key_name               : KeyPair Name
security_group_id      : Security Group ID
public_ip_boolean      : Boolean Value (True or False)
volume_type            : Ex: gp2, iops
#iops              
volume_size            : Size in GBs
delete_on_termination_boolean   : Boolean Value (True or False)

#################################################################################
Changes in configfiles/cloudwatch-input.json

log_group              : Cloudwatch Log Group path (ex: /aws/codebuild/marketplaces)
Access_key             : AWS Access Key
Secret_key             : AWS Secret Key
Region                 : AWS Region

######## To Run The Process #####################################################
$sh install.sh
#################################################################################