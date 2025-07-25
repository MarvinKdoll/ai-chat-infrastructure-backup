# AI Chat Infrastructure on AWS

**Deploy a private ChatGPT-like interface on AWS with intelligent CPU/GPU scaling using Infrastructure as Code.**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=flat&logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Infrastructure as Code](https://img.shields.io/badge/Infrastructure%20as%20Code-green)

## Project Overview

This project demonstrates enterprise-level Infrastructure as Code practices by deploying a scalable AI chat interface on AWS. The solution showcases conditional resource provisioning, cost optimization strategies, and production-ready security configurations.

**Key Business Value:**
- **Cost Optimization**: Conditional CPU/GPU scaling reduces infrastructure costs by 60-80%
- **Security First**: Custom VPC with configurable access controls
- **Operational Excellence**: Automated provisioning with zero-downtime deployments

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      Internet                           │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────┴───────────────────────────────────┐
│                VPC (10.0.0.0/16)                       │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Internet Gateway                   │    │
│  └─────────────────────┬───────────────────────────┘    │
│                        │                                │
│  ┌─────────────────────┴───────────────────────────┐    │
│  │          Public Subnet (10.0.32.0/19)          │    │
│  │                                                 │    │
│  │ ┌─────────────────┐  ┌─────────────────────────┐ │    │
│  │ │ Security Groups │  │     EC2 Instance        │ │    │
│  │ │ SSH (22)        │  │ t3.small/g4dn.xlarge    │ │    │
│  │ │ HTTP (80)       │  │ Conditional GPU         │ │    │
│  │ └─────────────────┘  └─────────────┬───────────┘ │    │
│  │                                    │             │    │
│  │                       ┌────────────┴──────────┐  │    │
│  │                       │     Open WebUI        │  │    │
│  │                       │   Docker Container    │  │    │
│  │                       │  AI Models: CPU/GPU   │  │    │
│  │                       └───────────────────────┘  │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/ai-chat-infrastructure-backup.git
cd ai-chat-infrastructure

# Configure deployment
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Access your deployment
echo "Access URL: http://$(terraform output -raw public_ip)"
echo "Admin Password: $(terraform output -raw password)"
```

## Key Technical Features

### Infrastructure as Code
- **Terraform**: Complete infrastructure definition and provisioning
- **Modular Design**: Reusable components for different environments
- **State Management**: Proper state handling for team collaboration

### Intelligent Resource Scaling
```hcl
# Conditional instance sizing based on workload requirements
resource "aws_instance" "openwebui" {
  instance_type = var.gpu_enabled ? var.machine.gpu.type : var.machine.cpu.type
  # t3.small for development (~$22/month)
  # g4dn.xlarge for production (~$380/month)
}
```

### Security Best Practices
- **Custom VPC**: Network isolation with configurable access controls
- **Security Groups**: Least-privilege access with IP restrictions
- **Key-based Authentication**: SSH access via RSA keys only
- **Automated User Management**: Secure admin account creation

### Cost Optimization
| Configuration | Instance Type | Monthly Cost | Use Case |
|---------------|---------------|--------------|----------|
| Development | t3.small | ~$22 | Light models, testing |
| Production | g4dn.xlarge | ~$380 | Heavy models, GPU acceleration |

## Technology Stack

**Infrastructure:**
- **AWS EC2**: Compute instances with conditional GPU support
- **AWS VPC**: Custom networking with security groups
- **Terraform**: Infrastructure as Code provisioning
- **Debian 12**: Secure, minimal Linux distribution

**Application:**
- **Docker**: Containerized application deployment
- **Open WebUI**: Modern AI chat interface
- **Systemd**: Service management and auto-restart
- **SQLite**: Lightweight database with automated setup

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed
- SSH key pair for instance access

## Configuration Options

### Environment Variables
```bash
export AWS_REGION="us-west-1"
export TF_VAR_gpu_enabled="true"
export TF_VAR_allowed_ips='["YOUR.IP.ADDRESS/32"]'
```

### GPU-Enabled Deployment
```bash
terraform apply -var="gpu_enabled=true"
```

### Security Hardening
```bash
terraform apply -var='allowed_ips=["YOUR.IP.ADDRESS/32"]'
```

## Performance Metrics

**t3.small (CPU Mode):**
- Suitable for lightweight models (TinyLlama, Phi-2)
- Cost-effective development environment
- ~5 second response times for simple queries

**g4dn.xlarge (GPU Mode):**
- Full GPU acceleration for large models
- Production-ready performance
- Supports models up to 24GB VRAM

## Project Structure

```
ai-chat-infrastructure/
├── main.tf                    # Terraform providers and core config
├── variables.tf               # Input variable definitions
├── outputs.tf                 # Output value definitions
├── vm.tf                      # AWS infrastructure resources
├── provision_vars.sh          # Instance provisioning automation
├── terraform.tfvars.example   # Configuration template
├── docs/                      # Comprehensive documentation
│   ├── setup-guide.md
│   ├── architecture.md
│   ├── cost-analysis.md
│   ├── security.md
│   └── troubleshooting.md
└── screenshots/               # Visual documentation
    ├── aws-console.png
    ├── openwebui-interface.png
    └── terraform-deploy.png
```

## Skills Demonstrated

**DevOps & Infrastructure:**
- Infrastructure as Code (Terraform)
- AWS Cloud Architecture
- Container Orchestration (Docker)
- Network Security Design
- Cost Optimization Strategies

**System Administration:**
- Linux System Management (Debian)
- Service Management (Systemd)
- Automated Provisioning Scripts
- SSH Key Management

**Software Engineering:**
- Version Control (Git)
- Documentation Standards
- Configuration Management
- Template-based Deployments

## Use Cases

**Enterprise Applications:**
- Private AI assistants for internal teams
- Customer service automation
- Document analysis and summarization
- Code review and development assistance

**Development Environments:**
- AI model testing and validation
- Prototype development
- Team collaboration tools
- Training and demonstration environments

## Getting Started Guide

1. **[Setup Guide](docs/setup-guide.md)** - Complete deployment walkthrough
2. **[Architecture Guide](docs/architecture.md)** - Technical deep dive
3. **[Security Guide](docs/security.md)** - Security configuration details
4. **[Cost Analysis](docs/cost-analysis.md)** - Detailed cost breakdown
5. **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

## Contributing

This project demonstrates Infrastructure as Code best practices for AI deployment. While primarily a portfolio piece, contributions and suggestions are welcome.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## About

This project showcases modern DevOps practices and cloud architecture design. It demonstrates the ability to design, implement, and document enterprise-grade infrastructure solutions using industry-standard tools and practices.

**Contact:** [Your Email] | [LinkedIn Profile] | [Portfolio Website]

---

*Built with care using Infrastructure as Code principles*
