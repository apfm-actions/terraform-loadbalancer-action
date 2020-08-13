output "output" {
  value = "${
    map(
      "name",            "${var.name}",
      "port",            "${var.port}",
      "public",          "${var.public}",
      "protocol",        "${local.protocol}",
      "subnets",         "${join(",", var.subnets)}",
      "security_groups", "${join(",", var.security_groups)}",
      "listener_id",     "${aws_lb_listener.main.id}",
      "listener_arn",    "${aws_lb_listener.main.arn}",
      "target_group_id", "${aws_lb_target_group.main.id}",
      "target_group_arn","${aws_lb_target_group.main.arn}"
    )
  }"
}

output "name" {
  value = "${var.name}"
}

output "port" {
  value = var.port
}

output "protocol" {
  value = local.protocol
}

output "subnets" {
  value = var.subnets
}

output "security_groups" {
  value = "${var.security_groups}"
}

output "listener" {
  value = "${
    map(
      "id",   "${aws_lb_listener.main.id}",
      "arn",  "${aws_lb_listener.main.arn}"
    )
  }"
}

output "target_group" {
  value = "${
    map(
      "id", "${aws_lb_target_group.main.id}",
      "arn","${aws_lb_target_group.main.arn}"
    )
  }"
}
