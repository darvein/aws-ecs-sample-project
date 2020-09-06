locals {
  first_public_subnet_id = element(sort(data.aws_subnet_ids.public.ids), 0)
}

resource "aws_instance" "graylog" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.ssh.key_name
  instance_type = var.graylog_instance_type

  vpc_security_group_ids = [data.aws_security_group.default.id, local.security_group_id]
  subnet_id              = local.first_public_subnet_id

  tags = {
    Name        = "graylog"
    Terraform   = true
    Environment = "operations"
  }
}
