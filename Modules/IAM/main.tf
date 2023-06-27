# Create IAM role with a policy document that will allow ansible Node to a assumed role
data "aws_iam_policy_document" "ansible-policy-doc-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
     actions = ["sts:AssumeRole"]
  }
}

# connect the assume role policy document to assume role policy
resource "aws_iam_role" "ansible-role" {
  name               = "ansible-aws-role"
  assume_role_policy = data.aws_iam_policy_document.ansible-policy-doc-assume-role.json
}

# Create IAM policy with a policy document which allow ansible perform certain task on aws account
# what ansible privileged will ansible have when it connects to ec2 instances created by ASG
data "aws_iam_policy_document" "ansible-policy-doc-aws" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*",
                 "autoscaling:Describe*",
                 "ec2:DescribeTags*"
                 ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ansible-policy" {
  name        = "policy-aws-cli"
  description = "This is that ansible will perform in aws account"
  policy      = data.aws_iam_policy_document.ansible-policy-doc-aws.json
}

# Attach the ansible IAM policy to role created
resource "aws_iam_policy_attachment" "test-attach" {
  name = "ansible role attachment"
  roles      = [aws_iam_role.ansible-role.name]
 # path               = "/"  # can be commented out too
  policy_arn = aws_iam_policy.ansible-policy.arn
}

# create instance profile for the IAM
resource "aws_iam_instance_profile" "ansible-iam-instance" {
  name = "IAM_profile"
  role = aws_iam_role.ansible-role.name
}



# #Create an EC2 Instance
# resource "aws_instance" "Set14_Team1_Web_App_Server" {
#   ami                         = "ami-06a566ca43e14780d"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.Set14_Team1_Key.key_name
#   iam_instance_profile        = aws_iam_instance_profile.set14-Team1-ec2_profile.name
#   subnet_id                   = aws_subnet.set14-team1-pubsub01.id
#   availability_zone           = "eu-west-2a"
#   vpc_security_group_ids      = [aws_security_group.set14_team1_FrontEndSG.id]