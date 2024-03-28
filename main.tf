# ==================================
# terraform設定
# ==================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# ==================================
# provider設定
# ==================================
provider "aws" {
  # profile = "kdl_hardening"
  region = "ap-northeast-1"
}

# ==================================
# 変数
# ==================================
variable "project" {
  type = string
}
variable "user" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_port" {
  type = number
}
variable "db_name" {
  type = string
}
variable "route_53_zone_id" {
  type = string
}
variable "us_east_1_cert_arn" {
  type = string
}
variable "ap_northeast_1_cert_arn" {
  type = string
}
variable "ecr_image" {
  type = string
}
variable "domain" {
  type = string
}
