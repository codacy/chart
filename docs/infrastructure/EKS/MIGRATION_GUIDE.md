# EKS Terraform Modernization Migration Guide

This document outlines the comprehensive modernization of the EKS Terraform configuration to align with current AWS best practices and remove deprecated components.

## Overview of Changes

### 1. **Terraform and Provider Updates**

**Before:**
- Terraform: `~> 0.12`
- AWS Provider: `~> 2.33`
- Kubernetes Provider: `~> 1.5`
- Random Provider: `~> 2.2`

**After:**
- Terraform: `>= 1.0` with modern `required_providers` block
- AWS Provider: `~> 5.0` with `default_tags` support
- Kubernetes Provider: `~> 2.0`
- Random Provider: `~> 3.0`

### 2. **Kubernetes Version Update**

**Before:** Default version `1.16` (EOL and unsupported)
**After:** Default version `1.28` (current supported version)

### 3. **EKS Cluster Modernization**

#### Deprecated IAM Policies Removed:
- `AmazonEKSServicePolicy` - No longer required for clusters created after April 2020
- `AmazonEKSClusterPolicy` - Retained

#### New Security Features Added:
- **Encryption at rest** for etcd secrets using KMS
- **Cluster endpoint access configuration** with both private/public access
- **Enhanced logging** configuration maintained

### 4. **Worker Nodes Complete Overhaul**

#### Replaced Legacy Components:

**Before (Legacy Approach):**
- Manual Launch Configurations
- Manual Auto Scaling Groups
- Manual userdata bootstrap scripts
- Manual aws-auth ConfigMap management
- Manual security group rules

**After (Modern Approach):**
- EKS Managed Node Groups
- Launch Templates with gp3 storage
- Automatic worker node authentication
- Simplified security group configuration
- Automatic cluster integration

#### Benefits:
- **Reduced operational overhead** - AWS manages node lifecycle
- **Better reliability** - Automatic health checks and replacement
- **Simplified updates** - Managed node group rolling updates
- **Enhanced security** - Automatic security patches

### 5. **Storage Optimization**

**Before:** gp2 volumes (older generation)
**After:** gp3 volumes with optimized IOPS and throughput settings
- Volume Type: `gp3`
- IOPS: `3000`
- Throughput: `125 MB/s`
- Encryption: Enabled by default

### 6. **EKS Add-ons Management**

#### New Managed Add-ons:
- **VPC CNI** - Network plugin with dedicated IAM role
- **CoreDNS** - DNS resolution
- **kube-proxy** - Network proxy
- **AWS EBS CSI Driver** - Persistent volume support

#### Benefits:
- AWS-managed lifecycle and updates
- Automatic compatibility with cluster version
- Reduced maintenance burden
- Better integration with AWS services

### 7. **Network Improvements**

#### Subnet Tagging for Load Balancer Discovery:
- Public subnets: `kubernetes.io/role/elb = "1"`
- Private subnets: `kubernetes.io/role/internal-elb = "1"`

#### Benefits:
- Automatic subnet discovery for AWS Load Balancer Controller
- Proper placement of internet-facing vs internal load balancers

### 8. **IAM Enhancements**

#### OpenID Connect (OIDC) Provider:
- Enables IAM roles for service accounts (IRSA)
- Fine-grained permissions for pods
- Eliminates need for worker node permissions for many use cases

#### Service-specific IAM Roles:
- Dedicated role for VPC CNI add-on
- Dedicated role for EBS CSI driver
- Follows principle of least privilege

### 9. **Updated Outputs**

#### New Comprehensive Outputs:
- Cluster information (endpoint, ARN, version)
- Node group details
- OIDC issuer URL for IRSA setup
- Certificate authority data

#### Removed:
- Manual aws-auth ConfigMap (no longer needed)


## Breaking Changes and Considerations

### 1. **Worker Node Recreation**
- Worker nodes will be recreated as part of managed node groups
- Plan for application downtime or ensure proper pod disruption budgets

### 2. **Security Group Changes**
- Simplified security group rules
- Some existing rules may be redundant and can be removed

### 3. **IAM Changes**
- New IAM roles for add-ons
- Removal of deprecated policy attachments

### 4. **Networking**
- Additional subnet tags required for load balancer functionality
- No functional changes to existing networking

## Validation Checklist

After migration, verify:

- [ ] Cluster is accessible: `kubectl get nodes`
- [ ] Managed node group is healthy: Check AWS Console
- [ ] Add-ons are active: `kubectl get pods -n kube-system`
- [ ] Applications are running: Check your workloads
- [ ] Load balancers can be created: Test service deployments
- [ ] Persistent volumes work: Test EBS CSI functionality

## Rollback Plan

If issues occur:

1. **Revert to previous branch:**
   ```bash
   git checkout main
   ```

2. **Restore previous state:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Manual cleanup** of any orphaned resources in AWS Console


## Support

For issues or questions regarding this migration:
1. Review AWS EKS documentation
2. Check Terraform AWS provider documentation
3. Consult with AWS support if needed

---

**Migration completed on:** $(date)
**Modernization branch:** `feature/aws-updates-sh`
