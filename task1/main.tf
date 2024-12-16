

# EC2 Instances
resource "aws_instance" "example" {
  ami                    = "ami-0451f2687182e0411" # Amazon Linux 2 AMI in ap-south-1
  instance_type          = "t2.micro"
  key_name               = "london"
  count                  = 2
  security_groups        = [aws_security_group.allow_http_ssh.name]

  # User data script to install Apache and create a test page
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Test Page from Instance $(hostname)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Instance_${count.index + 1}"
  }
}

# Output the public IPs of the instances
output "public_ips" {
  value = aws_instance.example[*].public_ip
}

# Output URLs for the test pages
output "test_page_urls" {
  value = [for instance in aws_instance.example : "http://${instance.public_ip}"]
}
