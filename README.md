# Azure Infrastructure Automation with Terraform and Ansible

This project implements a fully automated infrastructure and configuration deployment using **Terraform** and **Ansible** for Azure cloud resources.

## 🔧 Technologies

- **Cloud**: Microsoft Azure
- **Provisioning**: Terraform (v1.0+)
- **Configuration Management**: Ansible (Core v2.16)
- **OS**: Linux (CentOS 8.2) & Windows Server 2016

## 📁 Project Structure

```
automation-terraform-ansible/
├── terraform/
│   ├── main.tf
│   ├── modules/
│   │   ├── rgroup-8543/
│   │   ├── network-8543/
│   │   ├── vmlinux-8543/
│   │   ├── vmwindows-8543/
│   │   ├── datadisk-8543/
│   │   ├── loadbalancer-8543/
│   │   ├── database-8543/
│   │   └── common-8543/
│   ├── providers.tf
│   ├── provisioner.tf
│   ├── backend.tf
│   └── outputs.tf
├── ansible/
│   ├── n01708543-playbook.yml
│   ├── ansible.cfg
│   ├── inventory.ini
│   └── roles/
│       ├── profile-8543/
│       ├── user-8543/
│       ├── datadisk-8543/
│       └── webserver-8543/
└── README.md
```

## 🚀 Features

### Terraform Infrastructure

- Modularized and heavily parameterized code
- Single resource group with all resources prefixed by `8543` for uniqueness
- Infrastructure components:
  - VNet, subnet, NSG with custom rules
  - 3 Linux VMs & 1 Windows VM (with availability sets, extensions)
  - 4x 10GB data disks
  - Public Load Balancer with Linux backend
  - Azure Database for PostgreSQL
  - Log Analytics, Recovery Vault, Storage Account


### Ansible Automation

- Triggered post-provisioning via Terraform `null_resource`
- Fully non-interactive and repeatable deployment
- Ansible roles:
  - **`profile-8543`**: Session timeout policy via `/etc/profile`
  - **`user-8543`**: Creates cloudadmin users and SSH keys
  - **`datadisk-8543`**: Partitions and mounts extra disks with persistence
  - **`webserver-8543`**: Apache setup with unique FQDN web pages

## ✅ Requirements

- Azure CLI (authenticated via `az login`)
- Terraform ≥ v1.0
- Ansible Core = 2.16
- SSH key pair (`~/.ssh/id_rsa`, `~/.ssh/id_rsa.pub`)


## 🚀 Usage

### 1. Setup Environment

```bash
# Authenticate with Azure
az login

# (Optional) Generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

### 2. Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply --auto-approve
```

## 🔍 Access Information

- **VM Public IPs**: Output by Terraform
- **SSH Access**: `azureuser@<public-ip>` using your private key
- **Web Access via Load Balancer**: 
  - **URL**:http://`<load-balancer-public-ip>`
  - Routes to Apache servers running on backend Linux VMs
- **Direct Web Access** (Optional): http://`<vm-public-ip>` on port 80
- **User100 Private Key**: Fetched to local path via Ansible

## 🧹 Cleanup

To destroy all resources:

```bash
cd terraform
terraform destroy --auto-approve
```
