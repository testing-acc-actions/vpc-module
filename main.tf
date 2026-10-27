terraform {
  backend "s3" {
    bucket       = "tf-website-learner-16e6b602c04c23b0e55d892e6f"
    key          = "vpc-project/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}


resource "aws_s3_bucket" "traform_main"{
bucket= "tf-website-learner-16e6b602c04c23b0e55d892e6f"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "terraform-learning-vpc"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "terraform-learning-public-subnet"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "terraform-learning-igw"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "terraform-learning-public-rt"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}




resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = false

  tags = {
    Name        = "terraform-learning-private-subnet"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id



  tags = {
    Name        = "terraform-learning-private-rt"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
