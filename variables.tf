#################
### Variables ###
#################
variable "username" {
  default = "admin"
}

variable "password" {}

variable "MONGODB_DATABASE" {
  default = "mysinoptik"
}

variable "MONGODB_USERNAME" {
  default = "main_admin"
}

variable "MONGODB_PASSWORD" {}
variable "MONGODB_ROOT_PASSWORD" {}
variable "REDIS_PASSWORD" {}
variable "r_pass" {}
variable "project" {}
# variable "ipmongo"{
#   default = "10.128.0.3"
# }
# variable "ipredis"{
#   default = "10.128.0.4"
# }
variable "region" {
  default = "us-central1"
}

variable "api_telegram" {}

variable "bucket" {
  description = "my bucket"
}

variable "API" {
  description = "API Key"
}

variable "jtoken" {
  
}
