############################################################################
# Public Subnet
############################################################################

resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.10.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = true
    tags = { Name = "public-subnet-1"}
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block  = "172.26.20.0/24"
    availability_zone = "ap-northeast-2b"
    map_public_ip_on_launch = true
    tags = { Name = "public-subnet-2" }
}


resource "aws_subnet" "public-subnet-3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block  = "172.26.30.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = true
    tags = { Name = "public-subnet-3" }
}

############################################################################
# Private Subnet
############################################################################

resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.40.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.50.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = { Name = "private-subnet-2" }
}

resource "aws_subnet" "private-subnet-3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.60.0/24"
    availability_zone = "ap-northeast-2b"
    map_public_ip_on_launch = false
    tags = { Name = "private-subnet-3" }
}

resource "aws_subnet" "private-subnet-4" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.70.0/24"
    availability_zone = "ap-northeast-2b"
    map_public_ip_on_launch = false
    tags = { Name = "private-subnet-4" }
}

resource "aws_subnet" "private-subnet-5" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.80.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = { Name = "private-subnet-5" }
}

resource "aws_subnet" "private-subnet-6" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "172.26.90.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = { Name = "private-subnet-6" }
}
