#################
### Variables ###
#################
variable "username" {
  default = "admin"
}

variable "password" {}
variable "host" {}
variable client_certificate {}
variable client_key {}
variable cluster_ca_certificate {}

variable "MONGODB_DATABASE" {
  default = "mysinoptik"
}

variable "MONGODB_USERNAME" {
  default = "main_admin"
}

variable "MONGODB_PASSWORD" {}
variable "MONGODB_ROOT_PASSWORD" {}

# variable "ipmongo" {}

variable "region" {}

variable "nipmongo" {}