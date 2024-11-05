provider "aws" {
  region = "sa-east-1"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform-aws-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "terraform-aws-igw"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "nrt1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "security_group_example_app" {
  name        = "security_group_example_app"
  description = "Allow http and ssh"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP from VPC"
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-aws-sg"
  }
}

resource "aws_instance" "ubun-server" {
  ami                    = "ami-0f16d0d3ac759edfa"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group_example_app.id]
  subnet_id              = aws_subnet.sub1.id
  key_name = "deployer-key"
  tags = {
    Name = "terraform-aws-ubuntu"
  }
}

output "aws_instance_public_ip" {
  value = aws_instance.ubun-server.public_ip
  
}