#!/bin/bash

# Define the EKS cluster name, endpoint, and certificate authority
eks_cluster_name=""
eks_cluster_endpoint=""
eks_cluster_certificate_authority=""

# Update the values with the actual values from Terraform output
eks_cluster_name=$(terraform output -raw eks_cluster_name)
eks_cluster_endpoint=$(terraform output -raw eks_cluster_endpoint)
eks_cluster_certificate_authority=$(terraform output -raw eks_cluster_certificate_authority)

# Write the nodeconfig.yaml content to a file
cat <<EOF > /etc/kubernetes/nodeconfig.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${eks_cluster_name}
    apiServerEndpoint: ${eks_cluster_endpoint}
    certificateAuthority: ${eks_cluster_certificate_authority}
    cidr: 10.100.0.0/16
EOF

# Apply the node configuration if necessary
# For example, you might need to use kubectl to apply the configuration
# kubectl apply -f /etc/kubernetes/nodeconfig.yaml

# Additional bootstrap commands can be added here
echo "Node bootstrap complete"