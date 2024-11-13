resource "aws_ssm_association" "observability" {
  name                = "AWS-RunShellScript"
  association_name    = "nocping-observability-apps-s3"
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "tag:SSMAssociation"
    values = ["${var.environment}-ssm-association"]
  }

  parameters    = {
    commands = join(" && ", [
      "yum install -y awscli",
      "mkdir -p /opt/observability/nocping/certs",
      "aws s3 sync s3://${aws_s3_bucket.nocping[count.index].bucket}/certs /opt/observability/nocping/certs"
    ])
  }
}

resource "aws_ssm_parameter" "icinga_cctld_au_epp_user" {
  name    = "cctld_au_epp_user"
  type    = "String"
  value   = var.icinga_cctld_au_epp_user
  tier    = "Standard"
}

resource "aws_ssm_parameter" "icinga_cctld_au_epp_password" {
  name    = "cctld_au_epp_password"
  type    = "SecureString"
  value   = var.icinga_cctld_au_epp_password
  tier    = "Standard"
}
