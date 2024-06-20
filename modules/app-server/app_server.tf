# ---------------------------------------------
# key pair(追加)
# ---------------------------------------------
#resource "aws_key_pair" "keypair" {
#  key_name   = "${var.project}-${var.environment}-keypair"
#  public_key = file("${var.key_pair_path}")
#
#  tags = {
#    Name    = "${var.project}-${var.environment}-keypair"
#    Project = var.project
#    Env     = var.environment
#  }
#}

# ---------------------------------------------
# EC2 instance(追加)
# ---------------------------------------------
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon-linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_1a_address_id
  associate_public_ip_address = true

  # セキュリティグループ
  vpc_security_group_ids = [
    var.opmng_sg_id
  ]

  # インスタンスプロフィール(IAMロール)
  iam_instance_profile = var.app_ec2_profile_name

  # キーペア
  #  key_name = aws_key_pair.keypair.key_name

  # タグ
  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }

  # EC2インスタンス内構築スクリプト
  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install nginx -y
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
}