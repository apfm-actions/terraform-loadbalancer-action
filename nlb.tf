/* vim: ts=2:sw=2:sts=0:expandtab */

resource "aws_lb" "nlb_private" {
  count              = local.enable_nlb_private ? 1 : 0
  name_prefix        = local.prefix
  load_balancer_type = "network"
  subnets            = [var.subnets]
  security_groups    = [var.security_groups]
}

resource "aws_eip" "public" {
  # Note: we can not reference a resource generated list (var.public_subnets)
  # as part of this code as it can not be known on the first pass.
  count = local.enable_nlb_public == 0 ? 0 : 3

  vpc = true
}

resource "aws_lb" "nlb_public" {
  count              = local.enable_nlb_public ? 1 : 0
  name_prefix        = local.prefix
  load_balancer_type = "network"
  security_groups    = [var.security_groups]

  subnet_mapping {
    subnet_id     = var.subnets[0]
    allocation_id = aws_eip.public.0.id
  }

  subnet_mapping {
    subnet_id     = var.subnets[1]
    allocation_id = aws_eip.public.1.id
  }

  subnet_mapping {
    subnet_id     = var.subnets[2]
    allocation_id = aws_eip.public.2.id
  }
}
