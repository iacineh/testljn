data "aws_subnets" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["*private"] # insert values here
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc_prod.id]
  }
  depends_on = [ aws_vpc.vpc_prod ]
}

resource "aws_eks_cluster" "cluster_prod" {
  name     = var.eksname
  version  = "1.23"
  role_arn = aws_iam_role.eks-iam-role.arn
 
  vpc_config {
    #count = "${length(var.private_subnet)}"
    subnet_ids = data.aws_subnets.private_subnet.ids
  }

  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster_prod.name
  node_group_name = "nodegrp1"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = data.aws_subnets.private_subnet.ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name = "eks"
  }
}

output "subnet_cidr_blocks" {
  value = data.aws_subnets.private_subnet.ids
}