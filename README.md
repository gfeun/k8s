# k8s self training repo

[Terraform](https://www.terraform.io/) is used to setup infrastructure on DigitalOcean:
- VM (droplets)
- DNS A records

[terraform-inventory](https://github.com/adammck/terraform-inventory) is used to create an ansible inventory from the terraform state file

[kubespray](https://github.com/kubernetes-sigs/kubespray) is used to install k8s

## Commands
`make create_cluster DO_TOKEN=...`

`make destroy_cluster DO_TOKEN=...`
