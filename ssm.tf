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
