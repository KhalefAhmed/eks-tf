locals {
  cluster_name = var.cluster_name
}

resource "random_integer" "random_suffix" {
  min = 1000
  max = 9999
}

resource "aws_iam_role" "eks_cluster_role" {
  count = var.is_eks_role_enabled ? 1 : 0
  name  = "${local.cluster_name}-eks-cluster-role-${random_integer.random_suffix.result}"

  assume_role_policy = jsondecode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy_attach" {
  count      = var.is_eks_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

resource "aws_iam_role" "eks_nodegroup_role" {
  count = var.is_eks_role_enabled ? 1 : 0
  name  = "${local.cluster_name}-nodegroupe-role-${random_integer.random_suffix.result}"

  assume_role_policy = jsondecode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy_attach" {
  count      = var.is_eks_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy_attach" {
  count      = var.is_eks_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly_attach" {
  count      = var.is_eks_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSEBSCSI_DriverPolicy_attach" {
  count      = var.is_eks_role_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_cluster_role[count.index].name
}

resource "aws_iam_role" "eks_oidc_role" {
  count              = var.is_eks_role_enabled ? 1 : 0
  name               = "${local.cluster_name}-eks-oidc-role-${random_integer.random_suffix.result}"
  assume_role_policy = data.aws_iam_policy.document.eks_oidc_assume_role_policy.json
}
