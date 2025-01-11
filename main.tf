# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = "us-west-1"
}

#4

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "FlemingFriday-RobO"

    workspaces {
      name = "learn-terraform-github-actions"
    }
  }
}


resource "random_pet" "sg" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "web" {
  ami                    = "ami-05576a079321f21f8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd

              # Get the IMDSv2 token
              TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

              # Background the curl requests
              curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
              curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
              curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
              wait

              macid=$(cat /tmp/macid)
              local_ipv4=$(cat /tmp/local_ipv4)
              az=$(cat /tmp/az)
              vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$macid/vpc-id)

              # Create HTML file
              cat <<-HTML > /var/www/html/index.html
              <!doctype html>
              <html lang="en" class="h-100">
              <head>
              <title>Details for port 80 EC2 instance</title>
              </head>
              <body>
              <div>
              <h1>Kora-less Theo</h1>
              <h1>Heading down the mountain in North California</h1>
              
              <div class="tenor-gif-embed" data-postid="18507343" data-share-method="host" data-aspect-ratio="0.525" data-width="50%"><a href="https://tenor.com/view/im-sola-korean-motor-model-asian-gif-18507343">Im Sola Korean GIF</a>from <a href="https://tenor.com/search/im+sola-gifs">Im Sola GIFs</a></div> <script type="text/javascript" async src="https://tenor.com/embed.js"></script>

              <p><b>Instance Name:</b> $(hostname -f) </p>
              <p><b>Instance Private Ip Address: </b> $local_ipv4</p>
              <p><b>Availability Zone: </b> $az</p>
              <p><b>Virtual Private Cloud (VPC):</b> $vpc</p>
              </div>
              </body>
              </html>
              HTML

              # Clean up the temp files
              rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
            EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
