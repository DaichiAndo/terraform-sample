# ==================================
# ami
# ==================================
data "aws_ami" "ec2_ami" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ==================================
# key pair
# ==================================
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.user}-${var.project}-key-pair"
  public_key = file("./ssh-key/aws-hardening-keypair.pub")

  tags = {
    Name    = "${var.user}-${var.project}-key-pair"
    Project = var.project
    User    = var.user
  }
}


# ==================================
# ec2 instance (bastion)
# ==================================
resource "aws_instance" "bastion_server" {
  ami                         = data.aws_ami.ec2_ami.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]
  key_name = aws_key_pair.key_pair.key_name

  tags = {
    Name    = "${var.user}-${var.project}-bastion-server"
    Project = var.project
    User    = var.user
  }
}
