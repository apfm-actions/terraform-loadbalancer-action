/* vim: ts=2:sw=2:sts=0:expandtab */
data "aws_vpc" "main" {
  cidr_block = element(var.subnets, 0)
}

data "aws_lb" "main" {
  arn = element(coalescelist(aws_lb.alb.*.arn, aws_lb.nlb_public.*.arn, aws_lb.nlb_private.*.arn),0)
}

resource "aws_lb_target_group" "main" {
  name_prefix          = local.prefix
  port                 = var.port
  protocol             = local.tg_protocol
  vpc_id               = data.aws_vpc.main.id
  target_type          = "ip"
  deregistration_delay = var.tg_dereg_delay

  health_check {
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_success_codes
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "main" {
  # Treat load-balancers as lists and perform glob expansion on each.  If the
  # load balancer isn't defined (count = 0) then it wont be expanded.  In the
  # end only 1 load balancer should be defined, we are just trying to find the
  # right one by transforming it into a list and picking element 0.
  load_balancer_arn = data.aws_lb.main.arn

  port            = var.port
  protocol        = local.protocol
  ssl_policy      = local.protocol == "HTTPS" ? "ELBSecurityPolicy-2016-08" : ""
  certificate_arn = var.certificate["arn"]

  main {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }
}
