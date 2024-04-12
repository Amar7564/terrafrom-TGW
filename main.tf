provider "aws" {
region = "eu-west-2" 
access_key = "ghhjjj"
secret_key = ""
}

resource "aws_vpc" "vpc1" {
  cidr_block = "171.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "171.0.1.0/24"
  availability_zone = "eu-west-2a" 
}

resource "aws_vpc" "vpc2" {
  cidr_block = "173.1.0.0/16"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = "173.1.1.0/24" 
  availability_zone = "eu-west-2b" 
}

resource "aws_vpc" "vpc3" {
  cidr_block = "174.2.0.0/16"
}

resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.vpc3.id
  cidr_block        = "174.2.1.0/24"
  availability_zone = "eu-west-2c" 
}


resource "aws_ec2_transit_gateway" "tgw1" {
  description = "Transit Gateway"
}

resource "aws_ec2_transit_gateway" "tgw2" {
  description = "Transit Gateway"
}

resource "aws_ec2_transit_gateway" "tgw3" {
  description = "Transit Gateway"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw1.id
  vpc_id             = aws_vpc.vpc1.id
  subnet_ids         = [aws_subnet.subnet1.id]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw2.id
  vpc_id             = aws_vpc.vpc2.id
  subnet_ids         = [aws_subnet.subnet2.id]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc3_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw3.id
  vpc_id             = aws_vpc.vpc3.id
  subnet_ids         = [aws_subnet.subnet3.id]
}


resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
}


resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc2.id
}


resource "aws_route_table" "rt3" {
  vpc_id = aws_vpc.vpc3.id
}


resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
}


resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id
}


resource "aws_internet_gateway" "igw3" {
  vpc_id = aws_vpc.vpc3.id
}

resource "aws_security_group" "sg1" {
  name        = "sg1-security-group"
  description = "Allow inbound traffic on port 22 and 80"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["173.1.0.0/16"]
  }

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["174.2.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "sg2" {
  name        = "sg2-security-group"
  description = "Allow inbound traffic on port 22 and 80"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["171.0.0.0/16"]
  }

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["174.2.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "sg3" {
  name        = "sg3-security-group"
  description = "Allow inbound traffic on port 22 and 80"
  vpc_id      = aws_vpc.vpc3.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["173.1.0.0/16"]
  }

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["171.0.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_route_table_association" "subnet3_association" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.rt3.id
}


resource "aws_route" "route_to_igw1" {
  route_table_id         = aws_route_table.rt1.id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.igw1.id
}


resource "aws_route" "route_to_igw2" {
  route_table_id         = aws_route_table.rt2.id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.igw2.id
}

resource "aws_route" "route_to_igw3" {
  route_table_id         = aws_route_table.rt3.id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.igw3.id
}

resource "aws_ec2_transit_gateway_route_table" "tgwroutetable1" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw1.id
}

resource "aws_ec2_transit_gateway_route_table" "tgwroutetable2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw2.id
}

resource "aws_ec2_transit_gateway_route_table" "tgwroutetable3" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw3.id
}
