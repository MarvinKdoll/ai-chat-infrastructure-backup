# Setup Guide

## Prerequisites

Before deploying this infrastructure, ensure you have the following tools and accounts configured:

### Required Software
- **AWS CLI** version 2.0 or later
- **Terraform** version 1.0 or later
- **SSH client** (built into macOS/Linux, or PuTTY for Windows)
- **Git** for version control

### Required Accounts
- **AWS Account** with programmatic access
- **GitHub Account** (optional, for version control)

### AWS Permissions Required
Your AWS user/role must have permissions for:
- EC2 (instances, security groups, key pairs)
- VPC (VPC creation, subnets, route tables, internet gateways)
- IAM (if using roles for enhanced security)

## Installation Steps

### 1. Install AWS CLI

#### macOS (using Homebrew):
```bash
brew install awscli
```

#### Linux:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

#### Verify Installation:
```bash
aws --version
# Should show: aws-cli/2.x.x Python/3.x.x
```

### 2. Install Terraform

#### macOS (using Homebrew):
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### Linux:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

#### Verify Installation:
```bash
terraform version
# Should show: Terraform v1.x.x
```

## AWS Configuration

### 1. Create AWS Access Keys
1. **Login to AWS Console**
2. **Go to IAM → Users → Your User**
3. **Security credentials tab**
4. **Create access key**
5. **Download or copy the Access Key ID and Secret Access Key**

### 2. Configure AWS CLI
```bash
aws configure
# Enter:
# AWS Access Key ID: [your-access-key]
# AWS Secret Access Key: [your-secret-key]
# Default region name: us-west-1
# Default output format: json
```

### 3. Verify AWS Configuration
```bash
# Test AWS connectivity
aws sts get-caller-identity

# Should return your account details
```

## SSH Key Setup

### 1. Generate SSH Key Pair (if you don't have one)
```bash
# Generate new SSH key pair
ssh-keygen -t rsa -b 4096 -C "your-email@domain.com"

# Save as: ~/.ssh/openwebui_key
# Set passphrase (optional but recommended)
```

### 2. Get Your Public Key
```bash
# Display your public key
cat ~/.ssh/openwebui_key.pub

# Copy this entire output - you'll need it for configuration
```

## Project Setup

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/ai-chat-infrastructure.git
cd ai-chat-infrastructure
```

### 2. Configure Variables
```bash
# Copy the example configuration
cp terraform.tfvars.example terraform.tfvars

# Edit the configuration file
nano terraform.tfvars
# Or use your preferred editor: code terraform.tfvars
```

### 3. Configure terraform.tfvars
Edit `terraform.tfvars` with your specific values:

```hcl
# AWS Configuration
aws_region = "us-west-1"

# Instance Configuration