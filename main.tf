provider "aws" {
  region  = var.region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_vpc" "base_vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "${var.prefix}_vpc"
  }
}

resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.base_vpc.default_route_table_id
  depends_on = [
    aws_vpc.base_vpc
  ]
  tags = {
    Name = "${var.prefix}_rt"
  }
}

resource "aws_route" "base_route" {
  route_table_id         = aws_default_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on = [
    aws_default_route_table.rt
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.base_vpc.id
  tags = {
    Name = "${var.prefix}_igw"
  }
  depends_on = [
    aws_vpc.base_vpc
  ]
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.base_vpc.id
  cidr_block              = var.subnet
  map_public_ip_on_launch = true
  depends_on = [
    aws_vpc.base_vpc
  ]
  tags = {
    Name = "${var.prefix}_base_sub"
  }
}

resource "aws_security_group" "base_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.base_vpc.id
  tags = {
    Name = "${var.prefix}_base_sg"
  }
}

resource "aws_security_group_rule" "inbound_rules" {
  security_group_id = aws_security_group.base_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  depends_on = [
    aws_security_group.base_sg
  ]
}

resource "aws_security_group_rule" "outbound_rules" {
  security_group_id = aws_security_group.base_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  depends_on = [
    aws_security_group.base_sg
  ]
}

resource "aws_instance" "ec2_instances" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  key_name               = var.key_pair_name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.base_sg.id]
  subnet_id              = aws_subnet.subnet.id
  tags = {
    Name = "${var.prefix}_ec2_${count.index}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  tags = {
    Name = "${var.prefix}_rds_instance"
  }
}

resource "aws_s3_bucket" "private_s3_bucket" {
  bucket = "private-test-s3-bucket"

  tags = {
    Name        = "${var.prefix}_s3_bucket"
  }
}

resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.private_s3_bucket.id
  acl    = "private"
}

output "ips" {
  value = aws_instance.ec2_instances[*].public_ip
  description = "External IPs for EC2 instances"
}