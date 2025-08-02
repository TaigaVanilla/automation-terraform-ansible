resource "null_resource" "ansible_provisioning" {
  depends_on = [
    module.linux_vms,
    module.windows_vm,
    module.datadisks,
    module.loadbalancer,
    module.postgres
  ]

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/n01708543-playbook.yml"
  }
}