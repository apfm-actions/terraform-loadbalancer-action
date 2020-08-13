
variable "port" {}
variable "certificate" {
  type = "map"
}
variable "public" {
  default = true
}
variable "subnets" {
  type = "list"
}
variable "private_subnets" {
  type = "list"
  default = []
}
variable "security_groups" {
  type = "list"
}

variable "tg_protocol" {
  default = ""
}
variable "tg_dereg_delay" {
  default = 300
}

variable health_check_path {
  default = "/"
}

variable health_check_port {
  default = 80
}

variable health_check_protocol {
  default = "HTTP"
}

variable health_check_unhealthy_threshold {
  default = 2
}

variable health_check_healthy_threshold {
  default = 5
}

variable health_check_timeout {
  default = 5
}

variable health_check_interval {
  default = 30
}

variable health_check_grace_period {
  description = "Configurable attribute of the ECS service, not the target group"
  default     = 30
}

variable health_check_success_codes {
  default = 200
}


locals {
  protocol           = "${upper(var.protocol)}"
  tg_protocol        = "${var.tg_protocol == "" ? "${var.protocol}" : "${var.tg_protocol}"}"
  enable_alb         = "${local.protocol != "TCP" ? 1 : 0}"
  enable_nlb_private = "${local.protocol == "TCP" && ! var.public ? 1 : 0}"
  enable_nlb_public  = "${local.protocol == "TCP" && var.public ? 1 : 0}"
}
