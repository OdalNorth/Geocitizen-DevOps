provider "aws" {

}

resource "aws_instance" "App_Geocitizen" {
    ami = "ami-092cce4a19b438926"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.app_terraform.id]
    user_data = file("install_ssh.sh")
    key_name = "Kuvila-Ubuntu-key"
    tags = {
        Name = "App"
    }
}

resource "aws_instance" "DB_Geocitizen" {
    ami = "ami-013126576e995a769"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.app_terraform.id]
    key_name = "Kuvila-Ubuntu-key"
    tags = {
        Name = "DB"
    }
}

resource "aws_security_group" "app_terraform" {
    name = "terraform"
    description = "Security Policy"
    
    ingress {
        description = "Web-server"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH connect"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "PostgreSQL"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SMTP"
        from_port = 25
        to_port = 25
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SMTPS"
        from_port = 465
        to_port = 465
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "local_file" "public_ip" {
    content = <<EOT
[App_ip]
${aws_instance.App_Geocitizen.public_ip}

[DB_ip]
${aws_instance.DB_Geocitizen.public_ip}
EOT
    filename = "../ansible/hosts.txt"
}