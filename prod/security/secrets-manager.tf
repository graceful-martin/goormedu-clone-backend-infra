variable "ssm-env" {}

resource "aws_secretsmanager_secret" "secrets-manager" {
  name = "/goormedu-clone"
}

resource "aws_secretsmanager_secret_version" "secrets-manager-version" {
  secret_id     = aws_secretsmanager_secret.secrets-manager.id
  secret_string = jsonencode(var.ssm-env)
}