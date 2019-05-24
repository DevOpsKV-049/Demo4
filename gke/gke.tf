#############################
### Google Cloud Platform ###
#############################
provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
}
### Reserving External IP ###
resource "google_compute_address" "external" {
  name         = "external"
  address_type = "EXTERNAL"
  region       = "${var.region}"
}
### Output for K8S (Traefik controller) ###
output "external_ip" {
  value     = "${google_compute_address.external.address}"
  sensitive = true
}
# Reserving internal IPs


resource "google_compute_network" "devnet" {
name = "devnet"
auto_create_subnetworks = true
routing_mode = "REGIONAL"
}

data "google_compute_subnetwork" "devnet" {
  name   = "devnet"
  region       = "${var.region}"
}

resource "google_compute_address" "ripmongo" {
name = "ripmongo"
subnetwork = "${data.google_compute_subnetwork.devnet.self_link}"
address_type = "INTERNAL"
address = "10.128.0.10"
region       = "${var.region}"
}
resource "google_compute_address" "ripredis" {
name = "ripredis"
subnetwork = "${data.google_compute_subnetwork.devnet.self_link}"
address_type = "INTERNAL"
address = "10.128.0.12"
region       = "${var.region}"
}
output "ripmongo" {
value = "${google_compute_address.ripmongo.address}"
}
output "ripredis" {
value = "${google_compute_address.ripredis.address}"
}
output "devnet" {
  value = "${google_compute_network.devnet.self_link}"
}

