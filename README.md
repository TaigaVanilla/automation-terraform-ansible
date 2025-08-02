# Azure Infrastructure Automation with Terraform and Ansible

This project implements a fully automated infrastructure and configuration deployment using Terraform and Ansible for Azure cloud resources.

## Project Structure

```
automation-terraform-ansible/
├── terraform/
│   ├── main.tf                  # Main Terraform configuration
│   ├── modules/                 # Terraform modules
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
│   ├── n01708543-playbook.yml   # Main playbook
│   ├── ansible.cfg
│   ├── inventory.ini
│   └── roles/                   # Ansible roles
│       ├── profile-8543/
│       ├── user-8543/
│       ├── datadisk-8543/
│       └── webserver-8543/
└── README.md
```

## Prerequisites

1. **Azure CLI** - Install and authenticate with Azure
2. **Terraform** - Version 1.0 or later
3. **Ansible Core** - Version 2.16.14
4. **SSH Key Pair** - Located at `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

## Features Implemented

### Terraform Infrastructure
- Fully parameterized Terraform code
- All resource names prefixed with "8543"
- Single resource group deployment
- Comprehensive Azure infrastructure including:
  - Resource Group
  - Virtual Network and Subnet
  - Network Security Group
  - Linux VMs (vm1-8543, vm2-8543, vm3-8543)
  - Windows VM
  - Data Disks
  - Load Balancer
  - PostgreSQL Database
  - Log Analytics Workspace
  - Recovery Services Vault
  - Storage Account

### Ansible Integration
- null_resource with local-exec provisioner
- Automatic Ansible playbook execution after VM creation
- Non-interactive deployment
- Proper dependency management

### Ansible Roles Implementation

#### Profile Role
- ✅ Appends test block to `/etc/profile`
- ✅ Sets `export TMOUT=1500`

#### User Role
- ✅ Creates `cloudadmins` group
- ✅ Creates users: user100, user200, user300
- ✅ Adds users to `cloudadmins` and `wheel` groups
- ✅ Generates SSH key pairs for each user (no passphrase)
- ✅ Downloads user100's private key to local machine
- ✅ Sets proper file permissions

#### Data Disk Role
- ✅ Detects 10GB data disk (`/dev/sdc`)
- ✅ Creates 4GB XFS partition mounted to `/part1`
- ✅ Creates 5GB EXT4 partition mounted to `/part2`
- ✅ Configures persistent mounting via `/etc/fstab`

#### Web Server Role
- ✅ Installs and configures Apache HTTPD
- ✅ Creates custom HTML pages with VM FQDN
- ✅ Sets file permissions to 0444
- ✅ Enables and starts Apache service
- ✅ Uses handlers for service management
- ✅ Configures firewall rules

## Usage Instructions

### 1. Prerequisites Setup

```bash
# Install Azure CLI and authenticate
az login

# Install Terraform
brew install terraform  # macOS

# Install Ansible
pip install -r requirements.txt # macOS
ansible-galaxy collection install -r requirements.yml  # macOS

# Generate SSH key pair (if not exists)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

### 2. Deploy Infrastructure

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply --auto-approve
```

### 3. Access Information

- **VM Public IPs**: Available in Terraform outputs
- **SSH Access**: Use `azureuser` with your private key
- **Web Access**: HTTP on port 80
- **User100 Private Key**: Downloaded to `./user100_private_key`

## Cleanup

To destroy all resources:

```bash
cd terraform
terraform destroy --auto-approve
```
