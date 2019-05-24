###############
### Modules ###
###############

module "gke" {
  source   = "gke"
  project  = "${var.project}"
  region   = "${var.region}"
  username = "${var.username}"
  password = "${var.password}"
  # ipmongo  = "${var.ipmongo}"
}
module "traefik" {
  source                 = "k8s/traefik"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  lb_ext_ip              = "${module.gke.external_ip}"
}

module "mongo" {
  source                 = "k8s/mongo"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  MONGODB_DATABASE       = "${var.MONGODB_DATABASE}"
  MONGODB_USERNAME       = "${var.MONGODB_USERNAME}"
  MONGODB_PASSWORD       = "${var.MONGODB_PASSWORD}"
  MONGODB_ROOT_PASSWORD  = "${var.MONGODB_ROOT_PASSWORD}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  # ipmongo                = "${var.ipmongo}"
  region                 = "${var.region}"
  nipmongo               = "${module.gke.ripmongo}"
}

module "redis" {
  source                 = "k8s/redis"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  REDIS_PASSWORD         = "${var.REDIS_PASSWORD}"
  # ipredis                = "${var.ipredis}"
  region                 = "${var.region}"
  nipredis               = "${module.gke.ripredis}"
}

module "tf" {
  source                 = "k8s/tensorflow"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
}

module "jypiter" {
  source                 = "k8s/jypiter"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  project                = "${var.project}"
  region                 = "${var.region}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  j_token = "${var.jtoken}"
}

module "bot" {
  source                 = "k8s/bot"
  host                   = "${module.gke.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${module.gke.client_certificate}"
  client_key             = "${module.gke.client_key}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
  api_telegram           = "${var.api_telegram}"
  ip_redis               = "${module.gke.external_ip}"
  r_pass = "${var.REDIS_PASSWORD}"
}

module "functions" {
  project               = "${var.project}"
  source                = "functions"
  region                = "${var.region}"
  bucket                = "${var.bucket}"
  API                   = "${var.API}"
  ip_mongo              = "${module.gke.ripmongo}"
  ip_redis              = "${module.gke.ripredis}"
  ip_tf                 = "${module.gke.external_ip}"
  MONGODB_PASSWORD      = "${var.MONGODB_PASSWORD}"
  MONGODB_ROOT_PASSWORD = "${var.MONGODB_ROOT_PASSWORD}"
  REDIS_PASSWORD = "${var.REDIS_PASSWORD}"
  r_pass = "${var.REDIS_PASSWORD}"
  int_net = "${module.gke.devnet}"
}


