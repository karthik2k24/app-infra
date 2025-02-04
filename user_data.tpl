#!/bin/bash

# Define the EKS cluster variables using Terraform-injected values
eks_cluster_name="${EKS_CLUSTER_NAME}"
eks_cluster_endpoint="${EKS_CLUSTER_ENDPOINT}"
eks_cluster_certificate_authority="${EKS_CLUSTER_CA}"

# Write the nodeconfig.yaml file
cat <<EOF > /etc/kubernetes/nodeconfig.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: "${eks_cluster_name}"
    apiServerEndpoint: "${eks_cluster_endpoint}"
    certificateAuthority: "${eks_cluster_certificate_authority}"
    cidr: 10.100.0.0/16
EOF

echo "Node bootstrap complete"
