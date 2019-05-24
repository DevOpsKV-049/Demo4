variable "bucket" {
  description = "my bucket"
//  export TF_VAR_bucket=api_app
}

variable "project" {
  description = "my project"
//  export TF_VAR_project=your project ID
}

variable "API" {
  description = "API Key"
//  export TF_VAR_API=your API key
}

variable "ip_tf" {
  description = "ip_TF"
//  export TF_VAR_ip_tf=.....
}
variable "REDIS_PASSWORD" {
  
}
variable "r_pass" {

}

variable "ip_mongo" {
  description = "service IP address"

}
variable "ip_redis" {
  description = "redis IP"
}

variable "region" {
  default = "us-central1"

}

variable "MONGODB_DATABASE" {
  default = "mysinoptik"
}

variable "MONGODB_USERNAME" {
  default = "main_admin"
}

variable "MONGODB_PASSWORD" {}
variable "MONGODB_ROOT_PASSWORD" {}
# variable "int_mip" {}
variable "int_net" {}
