DO_TOKEN :=

ifeq ($(DO_TOKEN),)
$(error DO_TOKEN is not set)
endif

.PHONY: create_infra
create_infra:
	terraform apply -var do_token=${DO_TOKEN} -input=false -auto-approve

.PHONY: create_dynamic_inventory
create_dynamic_inventory: SHELL=/bin/bash
create_dynamic_inventory: create_infra
	# Poor man ansible dynamic inventory using jq
	cat > kubespray-inventory \
		<(echo "[workers]") \
		<(terraform show -json |jq -r '.values.root_module.resources[] | select (.type == "digitalocean_droplet" and .name == "workers") | .values.name + " ansible_host=" + .values.ipv4_address ') \
		<(echo "[controllers]") \
		<(terraform show -json |jq -r '.values.root_module.resources[] | select (.type == "digitalocean_droplet" and .name == "controllers") | .values.name + " ansible_host=" + .values.ipv4_address ') \
		kubespray-hosts

.PHONY: install_k8s
install_k8s: create_dynamic_inventory
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i kubespray-inventory -u root --private-key ~/.ssh/id_rsa cluster_install.yml

.PHONY: create_cluster
create_cluster: create_infra create_dynamic_inventory install_k8s
	scp root@controller-1.k8s.hackervaillant.eu:/etc/kubernetes/admin.conf .

.PHONY: destroy_cluster
destroy_cluster:
	terraform destroy -var do_token=${DO_TOKEN} -input=false -auto-approve
