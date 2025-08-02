resource "null_resource" "show_hostname" {
  for_each = var.vm_names

  connection {
    type        = "ssh"
    user        = var.admin_username
    host        = azurerm_public_ip.public_ips[each.key].ip_address
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = ["hostname"]
  }
}