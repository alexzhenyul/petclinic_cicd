terraform {
    required_version = ">= 0.12"
    backend "s3" {
        bucket = "petclinic-bucket"
        key = "petclinic/state.tfstate"
        region = "ap-southeast-4"
    }
}

provider "kubernetes" {
    load_config_file = "false"
    host = data.aws_eks_cluster.petclinic-cluster.endpoint
    token = data.aws_eks_cluster_auth.petclinic-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.petclinic-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "petclinic-cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "petclinic-cluster" {
    name = module.eks.cluster_id
}

module "petclinic-eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "13.2.1"
    
    cluster_name = var.cluster_name
    cluster_version = var.k8s_version

    subnets = module.petclinic-vpc.private_subnets
    vpc_id = module.petclinic-vpc.vpc_id

    tags = {
        environment = var.env_prefix
        application = "petclinic"
    }
    
    worker_groups = [
        {
            instance_type = "t2.small"
            name = "worker-group-1"
            asg_desired_capacity = 2
        },
        {
            instance_type = "t2.medium"
            name = "worker-group-2"
            asg_desired_capacity = 1
        }
    ]
}

resource "local_file" "kube_config_file" {
    content  = module.eks.kubeconfig
    filename = "kubeconfig.yaml"
    file_permission = "400"
}