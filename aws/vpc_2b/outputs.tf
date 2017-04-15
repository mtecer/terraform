output "bastion_private_ip" {
  value = "${join(",", aws_instance.bastion.*.private_ip)}"
}

output "bastion_public_ip" {
  value = "${join(",", aws_instance.bastion.*.public_ip)}"
}

output "web_public_ip" {
  value = "${join(",", aws_instance.web.*.public_ip)}"
}

output "web_private_ip" {
  value = "${join(",", aws_instance.db.*.private_ip)}"
}

output "db_private_ip" {
  value = "${join(",", aws_instance.db.*.private_ip)}"
}
