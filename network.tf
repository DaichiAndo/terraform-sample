# ==================================
# vpc
# ==================================
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.user}-${var.project}-vpc"
    Project = var.project
    User    = var.user
  }
}


# ==================================
# subnet
# ==================================
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.user}-${var.project}-public-subnet-1a"
    Project = var.project
    User    = var.user
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.user}-${var.project}-public-subnet-1c"
    Project = var.project
    User    = var.user
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.user}-${var.project}-private-subnet-1a"
    Project = var.project
    User    = var.user
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.user}-${var.project}-private-subnet-1c"
    Project = var.project
    User    = var.user
    Type    = "private"
  }
}


# ==================================
# route table
# ==================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-public-rt"
    Project = var.project
    User    = var.user
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_association_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_association_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-private-rt-1a"
    Project = var.project
    User    = var.user
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_association_1a" {
  route_table_id = aws_route_table.private_rt_1a.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-private-rt-1c"
    Project = var.project
    User    = var.user
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_association_1c" {
  route_table_id = aws_route_table.private_rt_1c.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}


# ==================================
# internet gateway
# ==================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-internet-gateway"
    Project = var.project
    User    = var.user
  }
}

resource "aws_route" "pubic_route_to_igw" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# ==================================
# nat gateway
# ==================================
resource "aws_eip" "eip_ngw_1a" {
  tags = {
    Name    = "${var.user}-${var.project}-ngw-eip-1a"
    Project = var.project
    User    = var.user
  }
}

resource "aws_nat_gateway" "ngw_1a" {
  allocation_id = aws_eip.eip_ngw_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name    = "${var.user}-${var.project}-ngw-1a"
    Project = var.project
    User    = var.user
  }
}

resource "aws_route" "pubic_route_to_ngw_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_1a.id
}

resource "aws_eip" "eip_ngw_1c" {
  tags = {
    Name    = "${var.user}-${var.project}-ngw-eip-1c"
    Project = var.project
    User    = var.user
  }
}

resource "aws_nat_gateway" "ngw_1c" {
  allocation_id = aws_eip.eip_ngw_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id

  tags = {
    Name    = "${var.user}-${var.project}-ngw-1c"
    Project = var.project
    User    = var.user
  }
}

resource "aws_route" "pubic_route_to_ngw_1c" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_1c.id
}
