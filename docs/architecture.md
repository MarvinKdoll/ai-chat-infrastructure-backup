# Architecture Documentation

## Overview

This infrastructure deploys a private AI chat interface using Infrastructure as Code principles with conditional CPU/GPU scaling based on workload requirements.

## Components

### Networking Layer
- **VPC**: Isolated network environment (10.0.0.0/16)
- **Public Subnet**: Single AZ deployment using first available zone (cidrsubnet calculation: 10.0.32.0/19)
- **Internet Gateway**: Direct internet access for container pulls and API calls
- **Route Tables**: All traffic (0.0.0.0/0) routes to internet gateway

### Security Layer
- **Security Groups**:
  - SSH access (port 22) - open to all IPs (0.0.0.0/0) for development
  - HTTP access (port 80) - configurable via `allowed_ips` variable
  - HTTPS access (port 443) - configurable via `allowed_ips` variable (prepared but not used)
- **VPC Isolation**: Custom VPC isolates resources from other AWS accounts
- **Key-based Authentication**: SSH access via RSA key pair only

### Compute Layer
- **Instance Types**:
  - CPU Mode: t3.small (2 vCPU, 2GB RAM)
  - GPU Mode: g4dn.xlarge (4 vCPU, 16GB RAM, 24GB GPU memory)
- **Instance Selection**: Conditional deployment based on `gpu_enabled` variable
- **Storage**: 60GB EBS root volume
- **Operating System**: Debian 12 (latest AMI)

### Application Layer
- **Container Runtime**: Docker CE with systemd service management
- **AI Interface**: Open WebUI (ghcr.io/open-webui/open-webui:ollama)
- **Database**: SQLite with pre-created admin user
- **Service Management**: Systemd service with auto-restart policies
- **Port Mapping**: Container port 8080 mapped to host port 80

## Data Flow

1. **User Request** → Internet Gateway
2. **Route Table** → Directs to Public Subnet (10.0.32.0/19)
3. **Security Groups** → Filters by configured IP restrictions
4. **EC2 Instance** → Processes request via Docker container
5. **Open WebUI Container** → Serves AI chat interface
6. **Model Processing** → CPU or GPU based on instance type and model requirements

## Deployment Strategy

### Conditional Instance Deployment
- **Development/Light Models**: t3.small for cost efficiency
- **Production/Heavy Models**: g4dn.xlarge for GPU acceleration
- **Configuration**: Single variable (`gpu_enabled`) controls instance type

### Infrastructure Provisioning
- **User Data Script**: Automated setup via `provision_vars.sh`
- **Database Initialization**: Pre-configured admin user creation
- **Service Configuration**: Systemd service setup with environment variables
- **Network Configuration**: Automatic public IP assignment

### Current Implementation Details
- **AMI**: Debian 12 x86_64 (owner: 136693071363)
- **Availability Zone**: Dynamically selected from available zones
- **Admin User**: Configurable email (default: admin@demo.gs)
- **Password**: Auto-generated 16-character random string
- **Container**: Ollama-enabled Open WebUI with local model support

## Future Enhancements
- **Auto Scaling Groups**: Multiple instances based on demand
- **Application Load Balancer**: Distribute traffic across instances
- **Multi-AZ Deployment**: High availability across availability zones
- **SSL/TLS**: HTTPS termination with certificate management
- **Monitoring**: CloudWatch integration for metrics and logging