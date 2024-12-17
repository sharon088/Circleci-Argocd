variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "eks-cluster"
}

variable "vpc" {
  description = "List of subnet IDs for the EKS cluster"
  type        = string
  default     = "vpc-0b42f9a41bb450f4e"
}

variable "subnets" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default     = ["subnet-00b994980d6de3519", "subnet-07261e3589d981b56"]
}

variable "control_plane_subnet_ids" {
  description = "List of subnet IDs for the EKS control plane"
  type        = list(string)
  default     = ["subnet-00b994980d6de3519", "subnet-07261e3589d981b56"]
}

variable "node_groups" {
  description = "Map of EKS Node Groups"
  type = map(any)
  default = {
    eks_nodes = {
      min_capacity     = 1
      max_capacity     = 2
      desired_capacity = 1
      instance_type    = "t2.micro"
    }
  }
}
