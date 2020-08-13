/* vim: ts=2:sw=2:sts=0:expandtab */

resource "aws_lb" "alb" {
  count              = "${local.enable_alb ? 1 : 0}"
  name_prefix        = var.prefix
  load_balancer_type = "application"
  internal           = "${var.public ? false : true}"
  subnets            = [ var.subnets ]
  security_groups    = [ var.security_groups ]
}