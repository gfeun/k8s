variable "nb_controllers" {
  type = number
  default = 2
}

variable "nb_workers" {
  type = number
  default = 2
}

data "digitalocean_ssh_key" "default" {
  name = "default"
}

resource "digitalocean_droplet" "controllers" {
  count = var.nb_controllers

  name = "controller-${count.index}"
  image = "debian-10-x64"
  region = "ams3"
  size = "s-1vcpu-3gb"
  ssh_keys = [data.digitalocean_ssh_key.default.fingerprint]
}

resource "digitalocean_droplet" "workers" {
  count = var.nb_workers

  name = "worker-${count.index}"
  image = "debian-10-x64"
  region = "ams3"
  size = "s-1vcpu-3gb"
  ssh_keys = [data.digitalocean_ssh_key.default.fingerprint]
}
