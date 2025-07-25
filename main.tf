data "aws_ami" "debian" {
  owners           = ["136693071363"]
  most_recent      = true
 
  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
}

resource "random_password" "password" {
    length = 16
    special = false
}


resource "aws_vpc" "openwebui" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.openwebui.id
  cidr_block              = cidrsubnet(aws_vpc.openwebui.cidr_block, 3, 1)
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "openwebui" {
  vpc_id = aws_vpc.openwebui.id
  }
resource "aws_route_table" "openwebui" {
  vpc_id = aws_vpc.openwebui.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openwebui.id

  }   

}

resource "aws_route_table_association" "openwebui" {
  subnet_id         = aws_subnet.subnet.id
  route_table_id = aws_route_table.openwebui.id
}

resource "aws_security_group" "ssh" {
  name   = "allow-all"
  vpc_id = aws_vpc.openwebui.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  } 
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "http" {
  name   = "allow-all-http"
  vpc_id = aws_vpc.openwebui.id

  ingress {
    cidr_blocks = var.allowed_ips
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  } 
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "https" {
    ingress {
        cidr_blocks = var.allowed_ips
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
    }
    egress {
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
}


resource "aws_key_pair" "openwebui"  {
  key_name   = "openwebui"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL8l1PQRcsf1Ayq3p5iH03hZ0dRyZAa9eDZBzzw8vIvstWkzgqCIxEP6mnsBzn3o/RKeCG8MXK/QarHK2gJlTtEEIQGCDBPmRfyA8aRLRG0scTzPoRJYUzbPEWuzdtphfuX0KTjygP0PglS6wEBWHufcvu3JCN8MsmFiVzSsnJtNV06bXWnp8j9RyxxY/rraTMNjV0g+P7PCMAYtu3SMHwYxY3zcxLOLilngmIRStfRnideIrMlPgbtY4LhzMcUAXQgLSuQ292IU3d5ZwQCKr3mTCtfKzm1Sv3Fd4KbaZDvDkq1GMMM2XNpnROd4thJ4zOgzu4aJWpWHTPeX3MutjA+N4JDx3ZTiwHKFLmvrxUz3lmS9RRPSaf2pCgC5K13tw3vhmlfg5N9/JnadR/VfNLzTpCkutorvysEY4NzRkqrqzAnBpbBZd3wAl5Fy/xUOg5oHCEMwsmYBmRbfin3nddtbNFiIo1mqQEnwoMIRBMFVMP2BcdQBTYVhRsxrAcj7Mqj0JdSenp1dep2/9u3tpW5UYAvRJciXnxbeb8oYRKqodZhIlXaLRI6rLh2oWf2qnC8oZx+mNDINirE/dAsEm8w+EN+M2UP6zh0BVjNXY0NOh1oloDnZPoIhtYDYCjQgD6ldBW04z/TuUPqGlaZQiFwSaQWBa0yDEQ9mKU7YN3yQ== mrvn.jrvn@gmail.com"
}

resource "aws_spot_instance_request" "openwebui" {
  ami           = data.aws_ami.debian.id
  instance_type = var.gpu_enabled ? var.machine.gpu.type : var.machine.cpu.type  
  security_groups             = [aws_security_group.ssh.id,
                                aws_security_group.http.id]
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.openwebui.key_name
  wait_for_fulfillment        = true

  user_data_base64 = base64encode(
    templatefile("${path.module}/provision_vars.sh", {
        open_webui_user = var.openwebui_user
        open_webui_password = random_password.password.result
        openai_base     = var.openai_base
        openai_key      = var.openai_key
        gpu_enabled     = var.gpu_enabled


    })
    )

  root_block_device {
    volume_size = 60
  }

}

resource "time_sleep" "wait_for_openwebui" {
    depends_on = [aws_spot_instance_request.openwebui]
    create_duration = "10m"  

}

/*
resource "terracurl_request" "openwebui" {
  name         = "openwebui"
  url          = "http://${aws_spot_instance_request.openwebui.public_ip}"
  method       = "GET"
  
  depends_on = [time_sleep.wait_for_openwebui]

  response_codes = [200, 404, 502, 503]
  max_retry      = 180
  retry_interval = 30
}




  