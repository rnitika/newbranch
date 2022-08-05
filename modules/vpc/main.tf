provider "aws" {
	region = "us-east-1"
	access_key = "AKIAXRGVXBCCW2WUWVXE"
	secret_key = "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"
}

resource "aws_vpc" "my-vpc"{

	cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my-subnet"{
	vpc_id = aws_vpc.my-vpc.id
	map_public_ip_on_launch = true
	cidr_block = "10.0.1.0/24"
}

data "aws_ssm_parameter" "this"{
	name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_internet_gateway" "customvpc-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "customvpc-igw"
  }
}

# Define routing table for the custom VPC

resource "aws_route_table" "customvpc-route-public" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.customvpc-igw.id
  }

  tags = {
    Name = "customvpc-route-public"
  }
}

# route association public

resource "aws_route_table_association" "customvpc-public1-ra" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.customvpc-route-public.id
}



