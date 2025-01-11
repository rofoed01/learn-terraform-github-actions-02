resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.salsaSunday.id

  tags = {
    Name    = "salsaSunday_IG"
    Service = "application1"
    Owner   = "Luke"
    Planet  = "Musafar"
  }
}
