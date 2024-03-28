# ==================================
# cloud watch log
# ==================================
resource "aws_cloudwatch_log_group" "sns_app_log" {
  name              = "/ecs/${var.user}/${var.project}/sns-app"
  retention_in_days = 7
}
