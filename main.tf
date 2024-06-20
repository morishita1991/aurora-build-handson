# main.tf

# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "public_1a_address" {
  type = string
}
variable "public_1c_address" {
  type = string
}
variable "vpc_address" {
  type = string
}

variable "http_port" {
  type = number
}
variable "https_port" {
  type = number
}
variable "ssh_port" {
  type = number
}

#variable "key_pair_path" {
#  type = string
#}

#variable "ami_name" {
#  type = string
#}

resource "aws_lb_target_group" "hands_on_target_group443" {
  name             = "test-target-group443"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = 80
  protocol         = "HTTP"

  vpc_id = module.network.vpc_id

  tags = {
    Name = "みんなのハンズオン"
  }

  health_check {
    interval            = 15
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200,301"
  }
}

resource "aws_lb_target_group_attachment" "hands_on_target_ec2_443" {
  target_group_arn = aws_lb_target_group.hands_on_target_group443.arn
  target_id        = module.app_server.app_server_id
}


resource "aws_lb_listener" "hands-on-listener443" {
  load_balancer_arn = module.loadbalancer.aws_lb_sample_alb_arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = module.acm.aws_acm_certificate_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hands_on_target_group443.arn
  }
}

module "network" {
  source = "./modules/network"

  vpc_address       = var.vpc_address
  project           = var.project
  environment       = var.environment
  public_1a_address = var.public_1a_address
  public_1c_address = var.public_1c_address
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  vpc_id               = module.network.vpc_id
  public_1a_address_id = module.network.public_1a_address_id
  public_1c_address_id = module.network.public_1c_address_id
  app_server_id        = module.app_server.app_server_id
  opmng_sg_id          = module.security_group.opmng_sg_id
}

module "security_group" {
  source = "./modules/security-group"

  project     = var.project
  environment = var.environment
  vpc_id      = module.network.vpc_id
  http_port   = var.http_port
  https_port  = var.https_port
  ssh_port    = var.ssh_port
}

module "app_server" {
  source = "./modules/app-server"

  project              = var.project
  environment          = var.environment
  public_1a_address_id = module.network.public_1a_address_id
  public_1c_address_id = module.network.public_1c_address_id
  opmng_sg_id          = module.security_group.opmng_sg_id
  app_ec2_profile_name = module.iam.app_ec2_profile_name
}

module "iam" {
  source = "./modules/iam"

  project     = var.project
  environment = var.environment
}

module "acm" {
  source = "./modules/acm"

  route53_zone_main_name    = module.dns.route53_zone_main_name
  route53_zone_main_zone_id = module.dns.route53_zone_main_zone_id
  aws_lb_dns_name           = module.loadbalancer.aws_lb_dns_name
  aws_lb_zone_id            = module.loadbalancer.aws_lb_zone_id
}

module "dns" {
  source = "./modules/domain"
}
