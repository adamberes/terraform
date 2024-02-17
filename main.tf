# Define SSH key pair for our instances
resource "aws_key_pair" "deployer" {
  key_name   = "timbuktu"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINs+fDbU0hAdX2yPLs2dsi5BhcvX7n7bEH+o/+vOMQTb info@adamberes.de"
}

# Configuration details for the EC2 instance
resource "aws_instance" "server" {
  ami           = lookup(var.map-ami-name-user, var.selected-ami)
  instance_type = "t3.small"
  key_name      = aws_key_pair.deployer.id
  subnet_id     = aws_subnet.public-subnet.id
  vpc_security_group_ids = [
    aws_security_group.webwerver.id,
  ]
  root_block_device {
    volume_size = 20
  }
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = file("userdata.sh")
  count                       = 1
  private_ip                  = lookup(var.ips_web, count.index)

  tags = {
    Name         = "webserver"
    TimeCreation = timestamp()
  }
}

# Configuration details for the Virtual Private Cloud (VPC)...
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name         = "vpc"
    TimeCreation = timestamp()
  }
}
locals {
  inbound_ports  = [22, 80, 443]
  outbound_ports = [0, 80, 443]
}
# Configuration details for the SSH security group
resource "aws_security_group" "webwerver" {
  name        = "webserver-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = local.outbound_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name         = "Security Groups"
    TimeCreation = timestamp()
  }
}

# Configuration details for the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name         = "Public Subnet"
    TimeCreation = timestamp()
  }
}

# Configuration details for the route table
resource "aws_route_table" "web-public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name         = "Public Subnet Route Table"
    TimeCreation = timestamp()
  }
}

# Configuration details for the internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name         = "VPC Internet Gateway"
    TimeCreation = timestamp()
  }
}

# Configuration details for associating the route table with the public subnet
resource "aws_route_table_association" "web-public-aws_route_table_association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.web-public-route-table.id
}

# Configuration details for DHCP options association
resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

# Configuration details for DHCP options
resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    "Name"       = "dhcp"
    TimeCreation = timestamp()
  }
}



