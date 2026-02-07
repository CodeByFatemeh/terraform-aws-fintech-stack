# Enterprise Finance Infrastructure on AWS (Terraform)

This repository contains a modular and highly-available cloud infrastructure designed for financial services, automated using **Terraform**. The architecture focuses on security, scalability, and adherence to industry best practices for financial data environments.

<br>

## 🏗️ Architecture Overview

The infrastructure deploys a total of **34 resources** based on the generated execution plan, including:

* **Networking:** Custom VPC with Multi-AZ Public/Private Subnet split.
* **Compute:** Auto Scaling Group (ASG) with 2-4 instances behind an Application Load Balancer (ALB).
* **Database:** Amazon Aurora/RDS cluster with production-grade tagging and isolation.
* **Security:** Strict IAM roles and security groups ensuring least-privilege access.

<br>

## 🚀 Features

* **Multi-AZ Resilience:** High availability across multiple availability zones in `us-east-1`.
* **Infrastructure as Code (IaC):** Fully managed and version-controlled via Terraform modules.
* **Standardized Tagging:** All resources include `Environment`, `ManagedBy`, and `Owner` tags for governance and cost tracking.

<br>

## 📂 Project Structure

```text
.
├── main.tf                # Core infrastructure definitions
├── variables.tf           # Input variables for customization
├── outputs.tf             # Output resource IDs and endpoints
├── modules/               # Reusable modular components
│   ├── vpc/               # VPC and Network configurations
│   ├── compute/           # ASG, EC2, and Load Balancing
│   └── database/          # Database clusters and security
└── terraform.tfvars       # Environment specific values

```
<br>

## 🛠️ Prerequisites

* **Terraform:** `v1.0.0` or higher.
* **AWS CLI:** Configured with appropriate IAM permissions.

<br>

## 🚦 Deployment Steps
1. **Clone and Navigate:**
   ```bash
   git clone [https://github.com/your-username/finance-infrastructure.git](https://github.com/your-username/finance-infrastructure.git)
   cd finance-infrastructure
   ```
2. **Initialize Terraform:**
   ```bash
   terraform init
   ```
3. **Preview the deployment:**
   ```bash
   terraform plan
   ```
4. **Deploy the infrastructure:**
   ```bash
   terraform apply
   ```

<br>

## 🛡️ Security Note

This project follows the **AWS Well-Architected Framework**.

- Database instances are deployed in **isolated private subnets**
- Only the **Load Balancer** is exposed to the public internet

---

**Maintained by:** Tima / Tima-Finance-Team  
**Environment:** Production-Ready Template