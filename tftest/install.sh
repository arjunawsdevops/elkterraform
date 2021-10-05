#!/bin/bash
VarFile=$(pwd)/var.tfvars

#To initiate the process of launching instance and resource gathering
terraform init
terraform plan -var-file=$VarFile

#To launch instance with all the requirements
terraform apply -var-file=$VarFile
