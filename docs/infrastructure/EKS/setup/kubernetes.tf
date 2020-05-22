# kubernetes.tf - setup kubernetes for codacy

# this allows worker nodes to join the cluster. See https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-YAML
    - rolearn: ${data.aws_iam_role.worker.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    YAML
  }
}

# CRDs for certificate-manager. See https://github.com/jetstack/cert-manager
resource "null_resource" "cert_manager_crds" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF && kubectl label namespace --overwrite kube-system certmanager.k8s.io/disable-validation='true'\n${data.template_file.cert_manager_crds.rendered}\nEOF"
  }
}

# create image pull secret in main namespace
resource "kubernetes_namespace" "codacy" {
  metadata {
    name = var.main_namespace
  }
}

