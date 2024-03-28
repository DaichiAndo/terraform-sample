# ==================================
# security group for alb
# ==================================
resource "aws_security_group" "alb_sg" {
  name        = "${var.user}-${var.project}-alb-sg"
  description = "This is a security group for alb."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-alb-sg"
    Project = var.project
    User    = var.user
  }
}

resource "aws_security_group_rule" "alb_sg_in_http" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_sg_in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_sg_out" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


# ==================================
# security group for ecs
# ==================================
resource "aws_security_group" "ecs_sg" {
  name        = "${var.user}-${var.project}-ecs-sg"
  description = "This is a security group for ecs."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-ecs-sg"
    Project = var.project
    User    = var.user
  }
}

resource "aws_security_group_rule" "ecs_sg_in_http" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["192.168.0.0/20"]
}

resource "aws_security_group_rule" "ecs_sg_in_https" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["192.168.0.0/20"]
}

resource "aws_security_group_rule" "ecs_sg_out" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


# ==================================
# security group for bastion
# ==================================
resource "aws_security_group" "bastion_sg" {
  name        = "${var.user}-${var.project}-bastion-sg"
  description = "This is a security group for bastion."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-bastion-sg"
    Project = var.project
    User    = var.user
  }
}

resource "aws_security_group_rule" "bastion_sg_in_http" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_sg_out" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


# ==================================
# security group for rds
# ==================================
resource "aws_security_group" "rds_sg" {
  name        = "${var.user}-${var.project}-rds-sg"
  description = "This is a security group for rds."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-rds-sg"
    Project = var.project
    User    = var.user
  }
}

resource "aws_security_group_rule" "rds_sg_in_3306_1" {
  security_group_id        = aws_security_group.rds_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "rds_sg_in_3306_2" {
  security_group_id        = aws_security_group.rds_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.bastion_sg.id
}
