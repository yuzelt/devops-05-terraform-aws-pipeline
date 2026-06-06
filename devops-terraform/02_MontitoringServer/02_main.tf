resource "aws_instance" "web" {
  ami                    = "ami-091138d0f0d41ff90"
  instance_type          = "t3.large"
  key_name               = "My-Ubuntu-Key"
  vpc_security_group_ids = [aws_security_group.My-Monitoring-Server-SG.id]
  user_data              = templatefile("./03_install.sh", {}) 

  tags = {
    Name = "My-Monitoring-Server" 
  }

  root_block_device {
    volume_size = 15
  }

}


resource "aws_security_group" "My-Monitoring-Server-SG" {
  name        = "My-Monitoring-Server-SG" #
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 9090, 9100, 3000] : {
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
    Name = "My-Monitoring-Server-SG"
  }

}

