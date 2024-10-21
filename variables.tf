variable "icinga_cctld_au_epp_user" {
  description = "The Icinga Testing CCTLD.AU EPP Username"
  type        = string
}

variable "icinga_cctld_au_epp_password" {
  description = "The Icinga Testing CCTLD.AU EPP Password"
  type        = string
  sensitive   = true
}
