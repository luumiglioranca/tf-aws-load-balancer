#############################################################################
#
# Data Source - Query's for VPC, Subnet's...
#
#############################################################################

# Get VPC ID
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Get Subnet Ids Private
data "aws_subnet_ids" "subnet_priv" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*Priv*"]
  }
}