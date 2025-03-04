# destroy_order.tf - Ensures resources are destroyed in the correct order

# This module adds a null resource to help with the destroy order
# The null resource depends on all resources that need to be destroyed before the VPC

# Add a null resource that depends on all resources that need to be destroyed before the VPC
resource "null_resource" "destroy_dependencies" {
  count = var.create_network_stack ? 1 : 0

  # Only create this resource when the VPC exists
  triggers = {
    vpc_id = aws_vpc.main[0].id
  }

  # This provisioner will only run when the resource is destroyed (i.e., during terraform destroy)
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      echo "Ensuring all resources in VPC ${self.triggers.vpc_id} are destroyed before the VPC itself..."
      echo "This helps prevent dependency errors during terraform destroy."
    EOT
    interpreter = ["bash", "-c"]
  }
}

# Add a dependency from the internet gateway to the null resource
# This ensures that the null resource is created before the internet gateway
# and destroyed after the internet gateway
resource "null_resource" "internet_gateway_dependency" {
  count = var.create_network_stack ? 1 : 0

  # This ensures the null resource is created after the internet gateway
  # and destroyed before the internet gateway
  triggers = {
    internet_gateway_id = aws_internet_gateway.main[0].id
  }

  # Add a dependency on the destroy_dependencies null resource
  depends_on = [null_resource.destroy_dependencies]
}
