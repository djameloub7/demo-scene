###########################################
################## AWS ####################
###########################################
locals {
  resdource_prefix = "${var.global_prefix}${random_string.random_string2.result}"
  bucket_pacman = "%{ if var.bucket_name != "" }${var.bucket_name}%{ else }${var.global_prefix}${random_string.random_string.result}%{ endif }"
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_string" "random_string" {
  length = 8
  special = false
  upper = false
  lower = true
  numeric = false
}

resource "random_string" "random_string2" {
  length = 2
  special = false
  upper = false
  lower = true
  numeric = false
}




resource "aws_s3_bucket" "pacman" {
  bucket = local.bucket_pacman
  acl = "public-read"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
  }
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${local.bucket_pacman}"
        }
    ]
}
EOF
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

###########################################
############## AWS Variables ##############
###########################################

variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

###########################################
############ CCloud Variables #############
###########################################

variable "bootstrap_server" {
  type = string
}

variable "cluster_api_key" {
  type = string
}

variable "cluster_api_secret" {
  type = string
}

variable "scoreboard_topic" {
  type = string
  default = "SCOREBOARD"
}

###########################################
############ Alexa Variables ##############
###########################################

# variable "alexa_enabled" {
#   type = bool
#   default = false
# }

# variable "pacman_players_skill_id" {
#   type = string
#   default = ""
# }

###########################################
############ Other Variables ##############
###########################################

variable "global_prefix" {
  type = string
  default = "streaming-pacman"
}

variable "bucket_name" {
  type = string
  default = ""
}

variable "ksql_endpoint" {
  type = string
}

variable "ksql_basic_auth_user_info" {
  type = string
}

