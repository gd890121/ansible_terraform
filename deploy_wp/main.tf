resource "aws_instance" "my_instance" {
  ami                    = "ami-0b329fb1f17558744"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]
  key_name               = aws_key_pair.my_sshkey.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./my_sshkey")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "roles"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source      = "deploy_roles.yaml"
    destination = "/home/ubuntu/deploy_roles.yaml"
  }

  provisioner "local-exec" {
    command = <<-EOF
      ssh-keyscan -t ssh-rsa ${self.public_ip} >> ~/.ssh/known_hosts
      echo "${self.public_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=./my_sshkey" > inventory.ini
      EOF
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini deploy_roles.yaml -b"
  }
}

resource "aws_key_pair" "my_sshkey" {
  key_name   = "my_sshkey"
  public_key = file("./my_sshkey.pub")
}


