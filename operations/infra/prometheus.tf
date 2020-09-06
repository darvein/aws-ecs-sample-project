resource "aws_instance" "prometheus" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.ssh.key_name
  instance_type = var.prometheus_instance_type

  vpc_security_group_ids = [data.aws_security_group.default.id, local.security_group_id]
  subnet_id              = local.first_public_subnet_id

  tags = {
    Name        = "prometheus"
    Terraform   = true
    Environment = "operations"
  }
}
