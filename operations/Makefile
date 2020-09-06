include .env

export TF_VAR_region=${AWS_REGION}
export TF_VAR_ssh_public_key_path=${SSH_PUBLIC_KEY_PATH}
export TF_VAR_api_container_port=${API_CONTAINER_PORT}
export TF_VAR_web_container_port=${WEB_CONTAINER_PORT}

tf-apply:
	@echo "[+] Provisioning infrastructure"
	cd infra && terraform init && terraform apply

tf-destroy:
	@echo "[+] Destroying infrastructure"
	cd infra && terraform destroy

tf-output:
	@echo "[+] Terraform outpus"
	cd infra && terraform output

provision-graylog:
	@echo "[+] Provisioning graylog"
	@GRAYLOG_IP_ADDR=$$(cd infra; terraform output | grep graylog_public | cut -d " " -f 3); \
		cd conf-mngt ; \
		echo "$${GRAYLOG_IP_ADDR}" ; \
		ansible-playbook -i "$${GRAYLOG_IP_ADDR}", graylog.yml

provision-prometheus:
	@echo "[+] Provisioning prometheus"
	@PROMETHEUS_IP_ADDR=$$(cd infra; terraform output | grep prometheus_public | cut -d " " -f 3); \
		cd conf-mngt ; \
		echo "$${PROMETHEUS_IP_ADDR}" ; \
		ansible-playbook -i "$${PROMETHEUS_IP_ADDR}", prometheus.yml
