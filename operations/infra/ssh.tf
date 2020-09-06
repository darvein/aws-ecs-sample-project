resource "aws_key_pair" "ssh" {
  key_name = var.project_name
  public_key = file(var.ssh_public_key_path)
}
