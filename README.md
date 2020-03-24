# k8s self training repo

[Terraform](https://www.terraform.io/) is used to setup infrastructure on DigitalOcean:
- VM (droplets)
- DNS A records

`terraform show` + `jq`-fu are used to build an ansible inventory from terraform state file

[kubespray](https://github.com/kubernetes-sigs/kubespray) is used to install k8s

## Commands
`make create_cluster DO_TOKEN=...`

`make destroy_cluster DO_TOKEN=...`
