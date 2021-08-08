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
      echo "db_host: ${aws_db_instance.mydb.endpoint}" >> group_vars/all.yaml
      sudo apt-get update
      EOF
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini deploy_roles.yaml -b"
  }
  depends_on = [aws_db_instance.mydb]
}
resource "aws_db_instance" "mydb" {
  allocated_storage     = 10
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t3.micro"
  name                  = "mydb"
  username              = "wordpress"
  password              = "wordpress"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  publicly_accessible   = true
  port                  = 3306
  vpc_security_group_ids = [aws_security_group.my_rds_sg.id]
}

resource "aws_key_pair" "my_sshkey" {
  key_name   = "my_sshkey"
  public_key = file("./my_sshkey.pub")
}


