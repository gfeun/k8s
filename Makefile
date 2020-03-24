DO_TOKEN :=

ifeq ($(DO_TOKEN),)
$(error DO_TOKEN is not set)
endif

.PHONY: create_cluster
create_cluster:
	terraform apply -var do_token=${DO_TOKEN} -input=false -auto-approve
	TF_HOSTNAME_KEY_NAME=name terraform-inventory --inventory ./ > hosts
	cat kubespray-hosts >> hosts
	ansible-playbook -i hosts -u root --private-key ~/.ssh/id_rsa cluster_install.yml
	scp root@controller-1.k8s.hackervaillant.eu:/etc/kubernetes/admin.conf .

.PHONY: destroy_cluster
destroy_cluster:
	terraform destroy -var do_token=${DO_TOKEN} -input=false -auto-approve
