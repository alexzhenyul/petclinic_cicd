terraform {
    required_version = ">= 0.12"
    backend "s3" {
        bucket = "petclinic-bucket"
        key = "petclinic/state.tfstate"
        region = "ap-southeast-4"
    }
}

provider "aws" {
    region = var.region
}

resource "aws_vpc" "petclinic-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "petclinic-subnet-1" {
    vpc_id = aws_vpc.petclinic-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "petclinic-igw" {
    vpc_id = aws_vpc.petclinic-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_default_route_table" "petclinic-rtb" {
    default_route_table_id = aws_vpc.petclinic-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.petclinic-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-petclinic-rtb"
    }
}

resource "aws_default_security_group" "petclinic-sg" {
    vpc_id = aws_vpc.petclinic-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip, var.jenkins_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-petclinic-sg"
    }
}

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "petclinic-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.petclinic-subnet-1.id
    vpc_security_group_ids = [aws_default_security_group.petclinic.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "petclinic-key-pair"

    user_data = file("entry-script.sh")

    tags = {
        Name = "${var.env_prefix}-server"
    }
}

output "ec2_public_ip" {
    value = aws_instance.petclinic-server.public_ip
}
