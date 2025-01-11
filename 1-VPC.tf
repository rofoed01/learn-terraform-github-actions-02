# this  makes  vpc.id which is aws_vpc.salsaSunday.id
resource "aws_vpc" "salsaSunday" {
  cidr_block = "10.32.0.0/16"

  tags = {
    Name = "salsaSunday"
    Service = "application1"
    Owner = "Chewbacca"
    Planet = "Mustafar"
  }
}
