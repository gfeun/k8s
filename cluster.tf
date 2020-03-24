variable "nb_controllers" {
  type = number
  default = 2
}

variable "nb_workers" {
  type = number
  default = 3
}

data "digitalocean_ssh_key" "default" {
  name = "default"
}

data "digitalocean_domain" "k8s" {
  name = "k8s.hackervaillant.eu"
}


resource "digitalocean_droplet" "controllers" {
  count = var.nb_controllers

  name = "controller-${count.index}.k8s.hackervaillant.eu"
  image = "debian-10-x64"
  region = "ams3"
  size = "s-1vcpu-3gb"
  ssh_keys = [data.digitalocean_ssh_key.default.fingerprint]
}

resource "digitalocean_droplet" "workers" {
  count = var.nb_workers

  name = "worker-${count.index}.k8s.hackervaillant.eu"
  image = "debian-10-x64"
  region = "ams3"
  size = "s-1vcpu-3gb"
  ssh_keys = [data.digitalocean_ssh_key.default.fingerprint]
}

resource "digitalocean_record" "controllers" {
  count = var.nb_controllers

  domain = data.digitalocean_domain.k8s.name
  type   = "A"
  name   = "controller-${count.index}"
  value  = digitalocean_droplet.controllers[count.index].ipv4_address
}

resource "digitalocean_record" "workers" {
  count = var.nb_workers

  domain = data.digitalocean_domain.k8s.name
  type   = "A"
  name   = "worker-${count.index}"
  value  = digitalocean_droplet.workers[count.index].ipv4_address
}
