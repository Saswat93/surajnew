provider "aws" {
  region = "us-west-2"
  access_key = "AKIAXWKE2HUDAZSICS5W"
  secret_key = "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"
}
resource "aws_instance" "myInstance2" {
  ami           = "ami-0cf6f5c8a62fa5da6"
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  sudo yum -y update
                  sudo yum -y install docker
				  sudo service docker start 
				  sudo docker pull saswatpattnaik21/suraj:latest
				  sudo docker run -d -p 80:80 saswatpattnaik21/suraj:latest
				  echo "Hello World!" > text.txt
				  EOF
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "DNS" {
  value = aws_instance.myInstance2.public_dns
}
