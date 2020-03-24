DO_TOKEN :=

ifeq ($(DO_TOKEN),)
$(error DO_TOKEN is not set)
endif

.PHONY: create_cluster
create_cluster:
	terraform apply -var do_token=${DO_TOKEN} -input=false -auto-approve
	terraform-inventory --inventory ./ > hosts
	ansible-playbook -i hosts -u root --private-key ~/.ssh/id_rsa cluster_install.yml

.PHONY: destroy_cluster
destroy_cluster:
	terraform destroy -var do_token=${DO_TOKEN} -input=false -auto-approve
