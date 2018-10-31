###########################################
################### AWS ###################
###########################################

provider "aws" {

    access_key = "AKIAICYJKFLJVKE3CNBA"
    secret_key = "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"
    region = "us-east-1"
  
}

###########################################
############# Confluent Cloud #############
###########################################

variable "ccloud_bootstrap_servers" {

  default = "pkc-lo09l.us-east-1.aws.confluent.cloud:9092"

}

variable "ccloud_access_key" {

  default = "A5VL5LGKOT7T657J"

}

variable "ccloud_secret_key" {

  default = "Ud++jKkBnm6mWuAzNJVlVPMXqwlM7PkFOKeFyD96IamPkOE8w8ENKiH3kPaQgNAa"

}