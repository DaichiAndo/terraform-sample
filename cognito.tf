# ==================================
# cognito
# ==================================
resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.user}-${var.project}-pool"

  auto_verified_attributes = [
    "email",
  ]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.user}-${var.project}-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
  ]
}
