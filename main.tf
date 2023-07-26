module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ecs-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.11.0/24", "10.0.21.0/24", "10.0.31.0/24"]
  public_subnets  = ["10.0.41.0/24", "10.0.51.0/24", "10.0.61.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ecs" {
  source = "./ecs"
  pub_sub_id = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnets
  cluster_name = "ecs_cluster"
  service_name = "ecs_terraform_service"
}