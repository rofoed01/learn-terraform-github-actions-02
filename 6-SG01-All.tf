resource "aws_security_group" "salsaSunday-TG01-SG01-80" {
  name        = "salsaSunday-TG01-SG01-80"
  description = "salsaSunday-TG01-SG01-80"
  vpc_id      = aws_vpc.salsaSunday.id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "MyEvilBox"
  #   from_port   = 3389
  #   to_port     = 3389
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "salsaSunday-TG01-SG01-80"
    Service = "application1"
    Owner   = "Luke"
    Planet  = "Musafar"
  }

}





resource "aws_security_group" "salsaSunday-LB01-SG01" {
  name        = "salsaSunday-LB01-SG01"
  description = "salsaSunday-LB01-SG01"
  vpc_id      = aws_vpc.salsaSunday.id

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "salsaSunday-LB01-SG01"
    Service = "application1"
    Owner   = "Luke"
    Planet  = "Musafar"
  }

}
