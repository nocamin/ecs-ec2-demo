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
      "aws s3 sync s3://${aws_s3_bucket.nocping.bucket}/certs /opt/observability/nocping/certs"
    ])
  }
}

resource "aws_ssm_document" "associate_eip" {
  name          = "AssociateEIP"
  document_type = "Command"

  content = <<EOF
{
  "schemaVersion": "2.2",
  "description": "Associate Elastic IP with an EC2 instance",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "associateEIP",
      "inputs": {
        "runCommand": [
          "INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)",
          "aws ec2 wait instance-running --instance-id $INSTANCE_ID",
          "aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id ${aws_eip.main[count.index].id} --allow-reassociation"
        ]
      }
    }
  ]
}
EOF
}

resource "aws_ssm_association" "associate_eip_on_tagged_instances" {
  name              = aws_ssm_document.associate_eip.name
  targets {
    key    = "tag:SSMAssociation"
    values = ["${var.environment}-ssm-association"]
  }
  association_name  = "AssociateEIPOnTaggedInstances"
  document_version  = "$LATEST"
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
