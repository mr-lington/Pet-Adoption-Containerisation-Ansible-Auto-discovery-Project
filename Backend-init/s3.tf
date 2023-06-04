# Creating backend for s3 bucket
resource "aws_s3_bucket" "lington-project-bucket" {
  bucket        = "lington-project-bucket"
  force_destroy = true
  tags = {
    name = "project-bucket"
  }
}

# Creating backend for s3 bucket onwer control
resource "aws_s3_bucket_ownership_controls" "lington-project-bucket" {
  bucket = aws_s3_bucket.lington-project-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Creating backend for s3 bucket acl
resource "aws_s3_bucket_acl" "project-bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lington-project-bucket]

  bucket = aws_s3_bucket.lington-project-bucket.id
  acl    = "private"
}

#####################
#  DYNAMODB TABLE   #  it is used to lock our terraform script to an account
#####################

resource "aws_dynamodb_table" "tflock" {
  name           = "project-dynamodb-table"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Name        = "TF Statefile Lock"
    Environment = "Terraform"
  }
}