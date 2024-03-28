# ==================================
# security group (不適切なルール)
# ==================================
resource "aws_security_group_rule" "alb_sg_error_rule" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_sg_error_rule" {
  security_group_id = aws_security_group.ecs_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_blocks       = ["192.168.0.0/20"]
}

resource "aws_security_group_rule" "rds_sg_error_rule" {
  security_group_id = aws_security_group.rds_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}


# ==================================
# s3 (不適切なバケット)
# ==================================
resource "aws_s3_bucket" "s3_error_bucket" {
  bucket_prefix = "${var.user}-${var.project}-contents-bucket"
}

resource "aws_s3_bucket_public_access_block" "s3_error_public_access_block" {
  bucket                  = aws_s3_bucket.s3_error_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3_error_bucket_policy" {
  bucket = aws_s3_bucket.s3_error_bucket.id
  policy = data.aws_iam_policy_document.s3_error_policy.json
  depends_on = [
    aws_s3_bucket_public_access_block.s3_error_public_access_block
  ]
}

data "aws_iam_policy_document" "s3_error_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.s3_error_bucket.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
