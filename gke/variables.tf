#################
### Variables ###
#################
variable "project" {}

variable "region" {
  default = "us-central1"
}

variable "username" {
  default = "admin"
}

variable "password" {}

# variable "ipmongo"{
#   default = "10.128.0.3"
# }