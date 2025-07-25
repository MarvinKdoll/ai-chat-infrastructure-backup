# Security Documentation

## Network Security

### VPC Isolation
- **Private Network**: 10.0.0.0/16 CIDR block
- **Custom VPC**: Isolated from default VPC and other AWS accounts
- **Internet Gateway**: Controlled egress/ingress through single gateway
- **Single Subnet**: 10.0.32.0/19 in first available AZ

### Security Groups

```hcl
# SSH Access - Open (Development Configuration)
resource "aws_security_group" "ssh" {
  name   = "allow-all"
  vpc_id = aws_vpc.openwebui.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open access for development
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # All outbound traffic allowed
  }
}

# HTTP Access - Configurable
resource "aws_security_group" "http" {
  name   = "allow-all-http"
  vpc_id = aws_vpc.openwebui.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips  # Configurable IP restrictions
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # All outbound traffic allowed
  }
}

# HTTPS Access - Prepared but Unused
resource "aws_security_group" "https" {
  name   = "allow-https"
  vpc_id = aws_vpc.openwebui.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips  # Same IP restrictions as HTTP
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # All outbound traffic allowed
  }
}
```

## Application Security

### Access Control
- **SSH Key Authentication**: RSA public key deployment, no password-based login
- **Application Authentication**: Pre-configured admin user with generated password
- **Admin Account**: Created during provisioning with randomized credentials

### Container Security
- **Docker Runtime**: Latest Docker CE installation
- **Image Source**: Official Open WebUI container (ghcr.io/open-webui/open-webui:ollama)
- **Port Isolation**: Container port 8080 mapped only to host port 80
- **Volume Mounts**: Local data persistence in /etc/open-webui.d/

## Data Security

### Database Security
- **SQLite Database**: Local file-based storage
- **Admin User Creation**: Automated during provisioning
- **Credential Storage**: Hashed passwords using htpasswd with bcrypt
- **Data Persistence**: Database stored in persistent EBS volume

### Network Traffic
- **HTTP Only**: Currently no SSL/TLS encryption in transit
- **Internal Processing**: AI model processing occurs locally on instance
- **No External APIs**: Unless OpenAI integration is explicitly configured

## Security Configuration Variables

### IP Access Control
```hcl
variable "allowed_ips" {
  description = "IP addresses allowed HTTP/HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Open by default - restrict in production
}
```

### Authentication Configuration
```hcl
variable "openwebui_user" {
  description = "Admin user email"
  default     = "admin@demo.gs"
}

# Password auto-generated via random_password resource
resource "random_password" "password" {
  length  = 16
  special = false
}
```

## Security Hardening Recommendations

### Production Deployment
1. **Restrict SSH Access**:
   ```bash
   # Modify security group to specific IP
   terraform apply -var='ssh_allowed_ips=["YOUR.IP.ADDRESS/32"]'
   ```

2. **Restrict HTTP Access**:
   ```bash
   # Limit web access to specific IPs
   terraform apply -var='allowed_ips=["YOUR.IP.ADDRESS/32"]'
   ```

3. **Implement HTTPS**:
   - Deploy Application Load Balancer
   - Configure SSL certificate via AWS Certificate Manager
   - Redirect HTTP to HTTPS
   - Update security group to use HTTPS security group

4. **Enhanced Access Control**:
   - Implement VPN access for SSH
   - Use AWS Systems Manager Session Manager
   - Deploy in private subnet with bastion host

### Monitoring and Logging
- **CloudWatch Logs**: Configure Docker container logging
- **VPC Flow Logs**: Monitor network traffic patterns
- **AWS CloudTrail**: Track API calls and infrastructure changes
- **Security Group Monitoring**: Alert on security group modifications

## Current Security Posture

### Development-Friendly Configuration
- **SSH**: Open access (0.0.0.0/0) for ease of development
- **HTTP**: Configurable access via allowed_ips variable
- **Instance**: Single public instance for simplicity

### Production Considerations
- **Network Segmentation**: Consider private subnets
- **Load Balancing**: Distribute traffic and enable SSL termination
- **Backup Strategy**: EBS snapshots for data persistence
- **Update Management**: Regular OS and container updates

## Compliance Considerations

### Data Residency
- **AI Processing**: Occurs entirely on your AWS infrastructure
- **No Third-Party Data Sharing**: Unless OpenAI integration is enabled
- **Regional Control**: Deploy in compliance-required geographic regions

### Access Logging
- **SSH Access**: System logs available via journalctl
- **Web Access**: Application logs in Docker container
- **Infrastructure Changes**: Tracked via Terraform state