# AWS Infrastructure with Flask App

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-blue.svg)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Infrastructure-orange.svg)](https://aws.amazon.com)
[![Flask](https://img.shields.io/badge/Flask-Web%20App-green.svg)](https://flask.palletsprojects.com)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue.svg)](https://docker.com)

A complete Infrastructure as Code (IaC) solution using Terraform to deploy a Flask web application on AWS with supporting services including VPC, EC2, RDS MySQL database, S3 storage, and CloudWatch logging.

## 📚 Table of Contents

- [🏗️ Architecture Overview](#️-architecture-overview)
- [📁 Project Structure](#-project-structure)
- [🚀 Flask Application](#-flask-application)
- [🏗️ Infrastructure Components](#️-infrastructure-components)
- [📋 Prerequisites](#-prerequisites)
- [🚀 Quick Start](#-quick-start)
- [🔧 Configuration](#-configuration)
- [🔒 Security](#-security)
- [📊 Monitoring](#-monitoring)
- [🛠️ Maintenance](#️-maintenance)
- [🚨 Troubleshooting](#-troubleshooting)
- [💰 Cost Information](#-cost-information)
- [🧹 Cleanup](#-cleanup)
## 🏗️ Architecture Overview

```
Internet
    |
Internet Gateway
    |
Public Subnet (ap-southeast-1a)
    |
    ├── EC2 Instance (Flask App)
    |
Private Subnet (ap-southeast-1b)
    |
    └── RDS MySQL Database
    
S3 Bucket (Static Files)
CloudWatch (Application Logs)
```

## 📁 Project Structure

```
project-root/
├── main.tf                 # Root Terraform configuration
├── variables.tf            # Root variables
├── outputs.tf             # Root outputs
├── cloudwatch.tf          # CloudWatch log group
├── terraform.tfvars       # Variable values (create this)
├── network/               # Network module
│   ├── main.tf           # VPC, subnets, IGW, routes
│   └── outputs.tf        # Network outputs
├── compute/               # Compute module
│   ├── main.tf           # EC2 instance and security group
│   ├── variables.tf      # Compute variables
│   └── outputs.tf        # Compute outputs
├── s3/                    # S3 module
│   ├── main.tf           # S3 bucket configuration
│   └── outputs.tf        # S3 outputs
├── database/              # Database module
│   ├── main.tf           # RDS MySQL and security group
│   ├── variables.tf      # Database variables
│   └── outputs.tf        # Database outputs
└── app/                   # Flask application
    ├── Dockerfile        # Docker container definition
    ├── app.py           # Flask web application
    └── requirements.txt  # Python dependencies
```

## 🚀 Flask Application

### Application Files

**app.py** - Simple Flask web server
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from your Terraform-provisioned EC2 instance!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
```

**requirements.txt** - Python dependencies
```
flask
```

**Dockerfile** - Container configuration
```dockerfile
FROM python:3.9
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

### Docker Image

The application is containerized and available as `prakash2405/myapp` on Docker Hub. The EC2 instance automatically pulls and runs this container on port 80.

## 🏗️ Infrastructure Components

### Network Module
- **VPC**: 10.0.0.0/16 CIDR with DNS support
- **Public Subnet**: 10.0.1.0/24 in ap-southeast-1a
- **Private Subnet**: 10.0.2.0/24 in ap-southeast-1b
- **Internet Gateway**: Public internet access
- **Route Table**: Routes traffic to IGW

### Compute Module
- **EC2 Instance**: t2.micro Amazon Linux 2
- **Security Group**: HTTP (80) and SSH (22) access
- **User Data**: Installs Docker and runs the Flask app
- **Auto-deployment**: Pulls container on boot

### Database Module
- **RDS MySQL**: t3.micro instance with 20GB storage
- **Multi-AZ Subnet Group**: Spans public and private subnets
- **Security Group**: MySQL access only from EC2
- **Database**: `myappdb` with admin user

### S3 Module
- **Bucket**: Versioned private bucket for static files
- **Random Naming**: Prevents bucket name conflicts
- **ACL Configuration**: Private access with ownership controls

### Monitoring
- **CloudWatch**: Log group for application logs
- **Retention**: 7-day log retention policy

## 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** installed (v1.0+)
3. **AWS CLI** configured with credentials
4. **Docker Hub account** (if updating the app image)

## 🚀 Quick Start

### 1️⃣ Clone and Setup
```bash
git clone <your-repo-url>
cd terraform-flask-app
```

### 2️⃣ Configure AWS
```bash
aws configure
```

### 3️⃣ Set Variables
Create `terraform.tfvars`:
```hcl
db_password = "YourSecurePassword123!"
```

### 4️⃣ Deploy
```bash
terraform init
terraform plan
terraform apply
```

### 5️⃣ Access Your App
```bash
# Get the public IP
terraform output ec2_public_ip

# Visit your app
curl http://<ec2_public_ip>
```

## 🚀 Deployment Guide

### Step 1: Prepare Environment

```bash
# Clone or create project directory
mkdir terraform-flask-app
cd terraform-flask-app

# Configure AWS credentials
aws configure
```

### Step 2: Create Variable File

Create `terraform.tfvars`:
```hcl
db_password = "YourSecurePassword123!"
```

### Step 3: Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review deployment plan
terraform plan

# Deploy infrastructure
terraform apply
```

### Step 4: Verify Deployment

```bash
# Get outputs
terraform output

# Test the application
curl http://<ec2_public_ip>
```

## 🔧 Configuration

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `db_password` | MySQL database password | `ChangeMe123!` | No |

### Customization Options

1. **Instance Size**: Modify `instance_type` in `compute/main.tf`
2. **Database Size**: Adjust `instance_class` in `database/main.tf`
3. **Application**: Update Docker image reference in `compute/main.tf`
4. **Networking**: Modify CIDR blocks in `network/main.tf`

## 🔒 Security

- **Network Isolation**: Database in private subnet
- **Security Groups**: Restrictive access rules
- **Encrypted Storage**: RDS and S3 encryption available
- **IAM Integration**: Can be extended with IAM roles
- **VPC Flow Logs**: Can be enabled for network monitoring

## 📊 Monitoring

### CloudWatch Integration
- Application logs: `/myapp/logs`
- Log retention: 7 days
- Metrics: CPU, Memory, Network available

### Available Metrics
- EC2 instance metrics
- RDS performance metrics
- S3 access logs
- VPC flow logs (if enabled)

## 🛠️ Maintenance

### Application Updates

1. **Update Docker Image**:
   ```bash
   # Build and push new image
   docker build -t amalspillai02/myapp:v2 ./app
   docker push amalspillai02/myapp:v2
   ```

2. **Update Infrastructure**:
   ```bash
   # Modify user_data in compute/main.tf
   terraform plan
   terraform apply
   ```

### Infrastructure Updates

```bash
# Update Terraform configurations
terraform plan
terraform apply

# Check for drift
terraform refresh
terraform plan
```

## 🧪 Testing

### Local Testing

```bash
# Test Flask app locally
cd app
pip install -r requirements.txt
python app.py

# Test with Docker
docker build -t myapp .
docker run -p 8080:80 myapp
curl http://localhost:8080
```

### Infrastructure Testing

```bash
# Validate Terraform
terraform validate

# Check formatting
terraform fmt -check

# Security scan (if using tfsec)
tfsec .
```

## 🚨 Troubleshooting

### Common Issues

1. **EC2 not accessible**:
   - Check security group rules
   - Verify internet gateway attachment
   - Confirm public IP assignment

2. **Database connection issues**:
   - Verify security group configuration
   - Check subnet group setup
   - Confirm database endpoint

3. **Docker container not starting**:
   - Check EC2 user data logs: `/var/log/cloud-init-output.log`
   - Verify Docker service status
   - Check container logs

### Useful Commands

```bash
# SSH to EC2 instance
ssh -i your-key.pem ec2-user@<public-ip>

# Check Docker status
sudo systemctl status docker
sudo docker ps
sudo docker logs <container-id>

# View user data execution
sudo tail -f /var/log/cloud-init-output.log
```

## 💰 Cost Information

### Current Costs (Approximate)
- **EC2 t2.micro**: $8-9/month
- **RDS t3.micro**: $12-15/month
- **Data Transfer**: Variable
- **S3 Storage**: $0.023/GB/month
- **CloudWatch**: Minimal

### Optimization Tips
1. Use Reserved Instances for long-term workloads
2. Enable S3 lifecycle policies
3. Set up CloudWatch alarms for cost monitoring
4. Consider Spot Instances for development

## 🧹 Cleanup

To destroy all resources:

```bash
# Destroy infrastructure
terraform destroy

# Confirm destruction
# Type 'yes' when prompted
```

**⚠️ Warning**: This will permanently delete all resources including data in RDS and S3.

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is provided as-is for educational purposes. Adapt as needed for your use case.

