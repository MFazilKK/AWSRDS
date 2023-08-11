terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}


provider "aws" {
  region = "us-east-1a"  # Replace with your desired region
}

resource "aws_kms_key" "database_master_key" {
  description = "KMS key for RDS master user password"
}

resource "aws_db_instance" "rds01" {
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  username            = "admin"
  password            = "your_password" 

  # Reference the KMS Key ID using the variable name aws_kms_key
  master_user_secret_kms_key_id = aws_kms_key.database_master_key.id
}

output "rds_endpoint" {
  value = aws_db_instance.rds01.endpoint
}
