# Keypairs

resource "aws_key_pair" "keypair" {
  key_name   = var.KEYPAIR_NAME
  public_key = file(var.PUBLIC_KEY_PATH)
  lifecycle {
    ignore_changes = [public_key]
  }
}
