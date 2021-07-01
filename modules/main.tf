// create the virtual private network
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.vpc_name}"
  }
}
// create the internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.aws_internet_gateway}"
  }
}
// create a dedicated subnet
resource "aws_subnet" "default" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.subnet_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.subnet_name}"
  }
}
// create routing table which points to the internet gateway
resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.main_routing_table}"
  }
}
// associate the routing table with the subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}
// create a security group for ssh access to the linux systems
resource "aws_security_group" "default" {
  name        = "${var.aws_security_group}"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    description = "allow traffic from TCP/22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from TCP/8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow access to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.aws_security_group}"
  }
}
// create prod instances
resource "aws_instance" "default" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.default.id}"]
  subnet_id                   = "${aws_subnet.default.id}"
  associate_public_ip_address = "true"

  tags = {
    Name = "prod-server"
    owner = "dinesh"
  }

  provisioner "remote-exec" {
    inline = [
              "sudo apt-get install nginx -y",
              "sudo pip install awscli",
              "sudo yum -y install java-1.8*",
              "echo java -version",
              "JAVA_HOME=/usr/lib/jvm/java-1.8*",
              "export JAVA_HOME",
              "PATH=$PATH:$JAVA_HOME",
              "sudo yum -y install wget",
              "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
              "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
              "sudo yum -y install jenkins",
              "echo jenkins installed",
              "sudo service jenkins start",
              "echo service jenkins status"
  ]
  }
      connection {
        user = "ec2-user"
        type = "ssh"
        host = self.public_ip
        private_key = file("Jenkins_key.pem")
        timeout = "2m"
    }
}
