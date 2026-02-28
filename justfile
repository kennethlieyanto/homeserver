docker-service-dir := "docker-services"

default:
    @just --choose

edit-secret:
    ansible-vault edit ansible/group_vars/kilisuci/vault.yml

setup-ansible:
    ansible-galaxy install -r ansible/requirements.yaml

play-stage:
    ansible-playbook -i ansible/inventory.yaml ansible/site.yaml --limit staging

lint:
    ansible-lint

start service:
    cd {{ docker-service-dir }}/{{ service }} && docker compose up -d

stop service:
    cd {{ docker-service-dir }}/{{ service }} && docker compose down 

nginx_container_name := "nginx-backup-1"

backup-nginx:
    docker exec {{ nginx_container_name }} backup

actual_container_name := "actual-budget-backup-1"

backup-actual:
    docker exec {{ actual_container_name }} backup
