module "eks" {

  source = "../../modules/eks"

  providers = {
    aws = aws.prod
  }

  cluster_name = "prod-eks"

  cluster_version = "1.33"

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnets

  endpoint_private_access = true
  endpoint_public_access = false

  node_instance_types = [
    "m6i.large"
  ]

  desired_size = 10

  min_size = 10

  max_size = 30
}

resource "aws_vpc_security_group_ingress_rule" "eks_from_management" {
  security_group_id = module.eks.cluster_security_group_id

  cidr_ipv4   = "10.0.0.0/16" // management VPC CIDR
  from_port   = 443 
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow Argo CD management VPC to access private EKS API"
}

resource "aws_ec2_transit_gateway" "main" {
  description = "Banking platform Transit Gateway"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "banking-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  vpc_id = module.prod_vpc.vpc_id

  subnet_ids = module.prod_vpc.private_subnet_ids

  tags = {
    Name = "prod-tgw-attachment"
  }
}