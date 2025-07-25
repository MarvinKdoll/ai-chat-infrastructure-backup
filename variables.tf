terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.62.0"
        }
        terracurl = {
            source = "devops-rob/terracurl"
            version = "~> 1.2.1"
        }
        random = {
            source = "hashicorp/random"
            version = "3.7.2"
        }
    }
}


provider "aws" {
    region = var.aws_region
}

variable "aws_region" {
    description = "AWS_region"
    type        = string
    default     = "us-west-1"
}

variable "allowed_ips" {
    description = "allowed access to HTTP"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

variable "ssh_public_key" {
    description = "allowed access to ssh"
    type        = string
    default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL8l1PQRcsf1Ayq3p5iH03hZ0dRyZAa9eDZBzzw8vIvstWkzgqCIxEP6mnsBzn3o/RKeCG8MXK/QarHK2gJlTtEEIQGCDBPmRfyA8aRLRG0scTzPoRJYUzbPEWuzdtphfuX0KTjygP0PglS6wEBWHufcvu3JCN8MsmFiVzSsnJtNV06bXWnp8j9RyxxY/rraTMNjV0g+P7PCMAYtu3SMHwYxY3zcxLOLilngmIRStfRnideIrMlPgbtY4LhzMcUAXQgLSuQ292IU3d5ZwQCKr3mTCtfKzm1Sv3Fd4KbaZDvDkq1GMMM2XNpnROd4thJ4zOgzu4aJWpWHTPeX3MutjA+N4JDx3ZTiwHKFLmvrxUz3lmS9RRPSaf2pCgC5K13tw3vhmlfg5N9/JnadR/VfNLzTpCkutorvysEY4NzRkqrqzAnBpbBZd3wAl5Fy/xUOg5oHCEMwsmYBmRbfin3nddtbNFiIo1mqQEnwoMIRBMFVMP2BcdQBTYVhRsxrAcj7Mqj0JdSenp1dep2/9u3tpW5UYAvRJciXnxbeb8oYRKqodZhIlXaLRI6rLh2oWf2qnC8oZx+mNDINirE/dAsEm8w+EN+M2UP6zh0BVjNXY0NOh1oloDnZPoIhtYDYCjQgD6ldBW04z/TuUPqGlaZQiFwSaQWBa0yDEQ9mKU7YN3yQ== admin@gmail.com"
}



variable "openwebui_user" {
    description = "Username to access the web UI"
    default     = "admin@demo.gs"
}

variable "openai_base" {
    description = "Optional base URL to use Open AI with Open Web UI"
    default     = "https://api.openai.com/v1"
}

variable "openai_key" {
    description = "Optional API key to use OpenAI with Open Web UI"
    default     = ""
}

variable "machine" {
    description = "The machine type and image to use for the VM"
    #GPU instance with 24GB memory and 4vCPus with 16GB of system RAM
    default = {
        "gpu" : { "type": "g4dn.xlarge" },
        "cpu" : { "type": "t3.small" },
    }
}

variable "gpu_enabled" {
    description = "is the VM GPU enabled"
    default      = false
}