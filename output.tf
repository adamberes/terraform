
output "public-ips-wb" {
  value = ["${join(", ", aws_instance.server.*.public_ip)}"]
}
output "selected-ami-with-name" {
  value = format("ami-by-name: %s ;ami-id: %s", var.selected-ami, lookup(var.map-ami-name-user, var.selected-ami))
}
