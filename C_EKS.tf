# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}
######
  # resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  #   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  #   role       = aws_iam_role.master.name
  # }

  # resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  #   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  #   role       = aws_iam_role.master.name
  # }

  # resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  #   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  #   role       = aws_iam_role.master.name
  # }

#######



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

resource "aws_iam_role_policy_attachment" "eks_node_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# IAM Policy for EKS Node Role
resource "aws_iam_role_policy_attachment" "eks_node_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}



resource "aws_iam_role_policy_attachment" "eks_node_ecr_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


##############
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks_node_role.name
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

  # resource "aws_iam_role_policy_attachment" "autoscaler" {
  #   policy_arn = aws_iam_policy.autoscaler.arn
  #   role       = aws_iam_role.eks_node_role.name
  # }

  # resource "aws_iam_instance_profile" "worker" {
  #   depends_on = [aws_iam_role.eks_node_role]
  #   name       = "veera-eks-worker-new-profile"
  #   role       = aws_iam_role.eks_node_role.name
  # }
##############

resource "aws_eks_cluster" "eks_cluster" {
  name     = "pvt-app-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version = "1.32"

  vpc_config {
    subnet_ids = [
      aws_subnet.pvt_app_1a.id,
      aws_subnet.pvt_app_1b.id,
      aws_subnet.pvt_app_1c.id
    ]
    endpoint_public_access  = true
    endpoint_private_access = true
  }
  
}



# EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "pvt-app-node-group"
  node_role_arn       = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.pvt_app_1a.id,
    aws_subnet.pvt_app_1b.id,
    aws_subnet.pvt_app_1c.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  capacity_type = "SPOT" 
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.pvt_app_vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}
