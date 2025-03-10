# IAM Role for EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "pvt-app-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.32"

  vpc_config {
    subnet_ids              = [aws_subnet.pvt_app_1d.id, aws_subnet.pvt_app_1b.id, aws_subnet.pvt_app_1c.id]
    security_group_ids      = [aws_security_group.eks_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = true

  }

}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "pvt-app-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    aws_subnet.pvt_app_1d.id,
    aws_subnet.pvt_app_1b.id,
    aws_subnet.pvt_app_1c.id
  ]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  ami_type = "CUSTOM"
  update_config {
    max_unavailable = 1
  }
  instance_types = ["t2.large"]
  capacity_type  = "SPOT"

  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = aws_launch_template.eks_launch_template.latest_version
    
  }
}
# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}




# IAM Policy for EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

################################################################################################################################################
# IAM Policy for EKS Node Role



resource "aws_iam_role_policy_attachment" "eks_node_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = aws_iam_policy.autoscaler.arn
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_instance_profile" "worker" {
  depends_on = [aws_iam_role.eks_node_role]
  name       = "eks-worker-new-profile"
  role       = aws_iam_role.eks_node_role.name
}
######################################

resource "aws_iam_policy" "autoscaler" {
  name = "eks-autoscaler-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
######################################


#aws ec2 describe-images --filters "Name=name,Values=amazon-eks-node-*1.32*" --query "Images[*].{ID:ImageId,Name:Name}" --region us-east-1 --output table
resource "aws_launch_template" "eks_launch_template" {
  name_prefix = "eks-node-"
  image_id    = "ami-0226f5d1e7c6fc56e"
  key_name    = "SRE2"
  user_data = base64encode(<<-EOF
  #!/bin/bash
  set -o xtrace
  /etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name} --apiserver-endpoint ${aws_eks_cluster.eks_cluster.endpoint}
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eks-node"
    }
  }
  vpc_security_group_ids = [aws_security_group.eks_node_sg.id]
}



# Output the EKS cluster name
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_certificate_authority" {
  description = "The base64 encoded certificate data required to communicate with the cluster API server"
  value       = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

output "launch_template" {
  value = aws_launch_template.eks_launch_template
}
