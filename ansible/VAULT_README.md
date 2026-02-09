# Ansible Vault Setup for Home Server

This setup uses ansible-vault to securely manage secrets and Jinja2 templates to generate .env files for Docker Compose services.

## Structure

```
ansible/
├── group_vars/
│   └── kilisuci/
│       ├── vars.yml       # Non-secret variables
│       └── vault.yml      # Encrypted secrets (ansible-vault)
├── roles/
│   └── internal/docker-compose-service/
│       ├── tasks/main.yaml
│       └── templates/     # Jinja2 templates for .env files
│           ├── immich.env.j2
│           ├── minio.env.j2
│           ├── paperless.env.j2
│           ├── n8n.env.j2
│           ├── grafana.env.j2
│           └── prometheus.env.j2
```

## Managing Secrets

### View Encrypted Secrets

```bash
uv run ansible-vault view ansible/group_vars/kilisuci/vault.yml
```

### Edit Encrypted Secrets

```bash
uv run ansible-vault edit ansible/group_vars/kilisuci/vault.yml
```

### Create New Encrypted File

```bash
uv run ansible-vault create ansible/group_vars/kilisuci/vault.yml
```

### Encrypt an Existing File

```bash
uv run ansible-vault encrypt ansible/group_vars/kilisuci/secrets.yml
```

## Running Playbooks with Vault

When running playbooks that use vaulted secrets, provide the vault password:

```bash
# Interactive password prompt
uv run ansible-playbook -i ansible/inventory/production.yaml ansible/site.yaml --ask-vault-pass

# Or use a password file (add to .gitignore!)
echo "your_vault_password" > .vault_pass
uv run ansible-playbook -i ansible/inventory/production.yaml ansible/site.yaml --vault-password-file .vault_pass
```

## Adding a New Secret

1. Add the variable name (without `vault_` prefix) to `group_vars/kilisuci/vars.yml`
2. Add the secret value with `vault_` prefix to the encrypted `group_vars/kilisuci/vault.yml`
3. Reference it in templates as `{{ vault_<variable_name> }}`

Example:

**vars.yml:**
```yaml
minio_root_user: minioadmin
```

**vault.yml (encrypted):**
```yaml
vault_minio_root_password: supersecretpassword123
```

**template.env.j2:**
```
MINIO_ROOT_USER={{ minio_root_user }}
MINIO_ROOT_PASSWORD={{ vault_minio_root_password }}
```

## Services Configuration

Each service has its variables defined in `group_vars/kilisuci/vars.yml` and secrets in the encrypted vault file.

### Immich
- `immich_upload_location`: Path to media storage
- `immich_db_data_location`: Path to database storage
- `vault_immich_db_password`: Database password

### MinIO
- `minio_root_user`: Admin username
- `vault_minio_root_password`: Admin password
- `minio_data_path`: Data storage path

### Paperless
- `paperless_url`: Public URL
- `paperless_timezone`: Timezone setting
- `paperless_ocr_language`: Primary OCR language

### n8n
- `n8n_domain_name`: Domain name
- `n8n_subdomain`: Subdomain
- `n8n_ssl_email`: SSL certificate email

## Security Notes

- Never commit unencrypted vault files
- Add `.vault_pass` to `.gitignore` if using a password file
- Regularly rotate secrets
- Use strong, unique passwords for each service
