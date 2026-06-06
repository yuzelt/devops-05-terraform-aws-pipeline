resource "aws_instance" "web" {
  ami                    = "ami-091138d0f0d41ff90"
  instance_type          = "t3.xlarge"
  region                 = "us-east-2"
  key_name               = "My-Ubuntu-Key"
  vpc_security_group_ids = [aws_security_group.My-Jenkins-Server-SG.id]
  user_data              = templatefile("./03_install.sh", {}) 

  tags = {
    Name = "My-Jenkins-Server"
  }

  root_block_device {
    volume_size = 20
  }
}


// GÖREV 1:
// IP sabitleme Terraform ile yapılacak.


// GÖREV 2:
// Admin Rolü tamınlanacak.
// EKS'yi kuracak bu makineye EC2 Admin Rolü verilecek.


resource "aws_security_group" "My-Jenkins-Server-SG" {
  name        = "My-Jenkins-Server-SG" #
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My-Jenkins-Server-SG"
  }

}







# EKSyi otomatikten kurmak için Create role EC2
# Add permissions kısmından Permissions policies bu yetkiyi AdministratorAccess vereceğiz.
# Role name : EKS_EC2_ROLE
# Modify IAM role  - Attach an IAM role to your instance.

