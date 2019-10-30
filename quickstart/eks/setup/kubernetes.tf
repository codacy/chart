# kubernetes.tf - setup kubernetes

# this allows worker nodes to join the cluster. See https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
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

resource "null_resource" "cert_manager_crds" {
  triggers = {
    manifest_sha1 = sha1(data.template_file.cert_manager_crds.rendered)
  }

  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF && kubectl label namespace --overwrite kube-system certmanager.k8s.io/disable-validation='true'\n${data.template_file.cert_manager_crds.rendered}\nEOF"
  }
}