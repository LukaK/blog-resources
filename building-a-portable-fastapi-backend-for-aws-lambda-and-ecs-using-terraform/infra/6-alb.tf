module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = local.name

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {

    ex-http-weighted-target = {
      port     = 80
      protocol = "HTTP"
      weighted_forward = {
        target_groups = [
          {
            target_group_key = "ex_lambda"
            weight           = 50
          },
          {
            target_group_key = "ex_ecs"
            weight           = 50
          }
        ]
      }
    }

  }

  target_groups = {
    ex_lambda = {
      name_prefix              = "l2-"
      target_type              = "lambda"
      target_id                = module.lambda_api.lambda_function_arn
      attach_lambda_permission = true
    }

    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }


      # There's nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }

  }
}
