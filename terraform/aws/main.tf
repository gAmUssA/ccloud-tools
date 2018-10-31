###########################################
################### AWS ###################
###########################################

provider "aws" {

    access_key = "<YOUR_AWS_ACCESS_KEY>"
    secret_key = "<YOUR_AWS_SECRET_KEY>"
    region = "us-east-1"
  
}

###########################################
############# Confluent Cloud #############
###########################################

variable "ccloud_bootstrap_servers" {

  default = "<CONFLUENT_CLOUD_BOOTSTRAP_SERVERS>"

}

variable "ccloud_access_key" {

  default = "<YOUR_CONFLUENT_CLOUD_ACCESS_KEY>"

}

variable "ccloud_secret_key" {

  default = "<YOUR_CONFLUENT_CLOUD_SECRET_KEY>"

}