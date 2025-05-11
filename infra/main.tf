# ----------------------
# AWS Provider and Variables
# ----------------------
provider "aws" {
  region = "us-east-1"
}

variable "my_ip" {
  description = "Your public IP address"
  type        = string
}

variable "DB_USER" {
  type = string
}

variable "DB_PASSWORD" {
  type      = string
  sensitive = true
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
  default     = ["aws_subnet.public.id"] # Placeholder
}

# ----------------------
# SSM Parameters for DB Secrets
# ----------------------
resource "aws_ssm_parameter" "DB_USER" {
  name  = "/trade-tracker/DB_USER"
  type  = "SecureString"
  value = var.DB_USER
}

resource "aws_ssm_parameter" "DB_PASSWORD" {
  name  = "/trade-tracker/DB_PASSWORD"
  type  = "SecureString"
  value = var.DB_PASSWORD
}

resource "aws_ssm_parameter" "DB_HOST" {
  name  = "/trade-tracker/DB_HOST"
  type  = "SecureString"
  value = aws_db_instance.postgres.endpoint
}

# ----------------------
# IAM Role for EC2 to Access SSM
# ----------------------
resource "aws_iam_role" "ec2_ssm_role" {
  name = "trade-tracker-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "trade-tracker-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

# ----------------------
# Security Groups
# ----------------------
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow SSH and backend port access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "Backend app"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow access to DB from backend"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# ----------------------
# RDS (PostgreSQL) Setup
# ----------------------
resource "aws_db_subnet_group" "default" {
  name       = "trade-db-subnet-group"
  subnet_ids = [aws_subnet.public.id] # Simplified: using public subnet for now

  tags = {
    Name = "trade-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "trade-tracker-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.DB_USER
  password               = var.DB_PASSWORD
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

# ----------------------
# EC2 Backend Instance
# ----------------------
resource "aws_key_pair" "backend_key" {
  key_name   = "trt-be-key"
  public_key = file("~/.ssh/trt-be-key.pub")
}

resource "aws_instance" "backend" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  key_name                    = aws_key_pair.backend_key.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = file("bootup_backend.sh")

  tags = {
    Name = "backend-server"
  }
}

# ----------------------
# Networking (VPC, Subnet, Gateway, Routing)
# ----------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ----------------------
# Outputs
# ----------------------
output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}

output "DB_ENDPOINT" {
  value = aws_db_instance.postgres.endpoint
}
