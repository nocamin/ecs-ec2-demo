# --- VPC ---

data "aws_availability_zones" "available" { state = "available" }

locals {
  azs_count = 1
  azs_names = data.aws_availability_zones.available.names
}

resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  assign_generated_ipv6_cidr_block = true
  tags                 = { Name = "demo-vpc" }
}

resource "aws_subnet" "public" {
  count                   = local.azs_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = local.azs_names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 10 + count.index)
  ipv6_cidr_block         = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = true
  tags                    = { Name = "demo-public-${local.azs_names[count.index]}" }
}

# --- Internet Gateway ---

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "demo-igw" }
}


# --- Public Route Table ---

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "demo-rt-public" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block   = "::/0"
    gateway_id        = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count          = local.azs_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# --- ENI CREATION FOR EACH AZ ---

resource "aws_network_interface" "main" {
  count      = local.azs_count
  subnet_id  = aws_subnet.public[count.index].id          # Use one ENI per public subnet
  security_groups = [aws_security_group.ecs_node_sg.id]
  description = "ENI for ECS EC2 instances in ${local.azs_names[count.index]}"
  tags       = { Name = "demo-eni-${local.azs_names[count.index]}" }
}

# --- EIP CREATION  ---

resource "aws_eip" "main" {
  count      = local.azs_count
  domain     = "vpc"  # VPC-based Elastic IP
  depends_on = [aws_internet_gateway.main]  # Ensures IGW is created first
  tags       = { Name = "demo-eip-${local.azs_names[count.index]}" }
}

# --- EIP ASSOCIATION TO ENI ---

resource "aws_eip_association" "eni_eip_assoc" {
  count                = local.azs_count
  allocation_id        = aws_eip.main[count.index].id  # Attach each EIP to its respective ENI
  network_interface_id = aws_network_interface.main[count.index].id
}
