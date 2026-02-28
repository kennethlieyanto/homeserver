docker-service-dir := "docker-services"

default:
    @just --choose

edit-secret:
    ansible-vault edit ansible/group_vars/kilisuci/vault.yml

setup:
    ansible-galaxy install -r ansible/requirements.yaml

play:
    ansible-playbook -i ansible/inventory/production.yaml ansible/site.yaml 

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
