# Two-Tier Web App Infrastructure (Terraform)

This project deploys a two-tier architecture on AWS using Terraform. It demonstrates production-style practices with modular, reusable code and automated provisioning of core infrastructure components.

---

## 🔧 Modules

- **VPC**  
  Custom VPC with public and private subnets, Internet Gateway, NAT Gateway, and routing.

- **Compute (EC2 + ALB)**  
  Auto Scaling Group of EC2 instances (web tier) behind an Application Load Balancer (ALB), deployed across multiple Availability Zones.

- **S3**  
  Versioned S3 bucket with lifecycle rules and secure configuration.

---

## ✅ Features

- Modular and reusable Terraform code  
- Custom VPC and subnets across AZs  
- Public and private networking with NAT  
- Auto-scaling EC2 instances using Launch Template  
- Load-balanced traffic via ALB  
- User-data bootstraps basic web content  
- S3 bucket with versioning and 30-day expiration for non-current objects  
- Remote backend support (S3 + DynamoDB lock table)

---

## 📁 Directory Structure

```
two-tier-web-app/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars          # Not committed (contains secrets)
├── .gitignore                # Ignores tfstate, tfvars, and .terraform files
├── modules/
│   ├── VPC/
│   ├── Compute/
│   └── S3/
```

---

## 🔒 Security Notes

- `terraform.tfvars` contains environment-specific and sensitive variables (e.g., AMI ID, instance type) — excluded from Git.
- No hardcoded secrets in `.tf` files.
- Security Groups restrict traffic to EC2 and ALB layers properly.

---

## 🚀 Usage

1. **Clone this repository**

2. **Create a `terraform.tfvars` file** in the root:

```hcl
region                 = "eu-west-2"
vpc_cidr               = "10.0.0.0/16"
public_subnet_1_cidr   = "10.0.1.0/24"
public_subnet_2_cidr   = "10.0.2.0/24"
private_subnet_1_cidr  = "10.0.3.0/24"
private_subnet_2_cidr  = "10.0.4.0/24"
ami_id                 = "ami-0fc32db49bc3bfbb1"
instance_type          = "t2.micro"
bucket_name            = "my-app-assets-bucket"
```

3. **Run Terraform**

```bash
terraform init
terraform apply
```

---

## 👤 Author

**Rami Alshaar**  
[GitHub Profile](https://github.com/Rami-shaar)
