variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "admin_user" {}
variable "admin_passwd" {}

provider "digitalocean" {
    token = "${var.do_token}"
}

resource "digitalocean_droplet" "node" {
    count = 2
    image = "centos-7-2-x64"
    name = "node-${count.index+1}"
    region = "sfo1"
    size = "512mb"
    private_networking = true
    ssh_keys = [ "${var.ssh_fingerprint}" ]

    connection {
        user = "root"
        type = "ssh"
        key_file = "${var.pvt_key}"
        timeout = "1m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum -y update",
            "sudo yum -y install ansible",
            "useradd ${var.admin_user}",
            "echo '${var.admin_user}:${var.admin_passwd}' | chpasswd",
            "gpasswd -a ${var.admin_user} wheel",
            "mkdir /home/${var.admin_user}/.ssh/"
        ]
    }

    provisioner "file" {
        source = "${var.pub_key}"
        destination = "/home/${var.admin_user}/.ssh/authorized_keys"
    }

    provisioner "remote-exec" {
        inline = [
            "chown ${var.admin_user} /home/${var.admin_user}/.ssh",
            "chgrp ${var.admin_user} /home/${var.admin_user}/.ssh",
            "chmod 700 /home/${var.admin_user}/.ssh",
            "chown ${var.admin_user} /home/${var.admin_user}/.ssh/authorized_keys",
            "chgrp ${var.admin_user} /home/${var.admin_user}/.ssh/authorized_keys",
            "chmod 600 /home/${var.admin_user}/.ssh/authorized_keys",
            "sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config",
            "systemctl reload sshd",
        ]
    }
}
