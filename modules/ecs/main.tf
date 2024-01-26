
data "template_file" "pact" {
  template = file("${path.module}/pact.json")
}
# resource "aws_service_discovery_private_dns_namespace" "this" {
#   vpc = var.vpc_id.id
#   name = "agharameez-postgres.com"
#   description = "Postgress Private Namespace"
# }
# resource "aws_service_discovery_service" "this" {
#   name = "postgres_discovery"
#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.this.id

#     dns_records {
#       ttl = 10
#       type = "A"
#     }
#     dns_records {
#       ttl = 10
#       type = "SRV"
#     }
#     routing_policy = "MULTIVALUE"
#   }
#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }
# resource "aws_service_discovery_private_dns_namespace" "django" {
#   vpc = var.vpc_id.id
#   name = "rameezdjango.com"
#   description = "Django Public NameSpace"
# }
# resource "aws_service_discovery_service" "djangothis" {
#   name = "django"
#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.django.id
#     dns_records {
#       ttl = 10
#       type = "A"
#     }
#     dns_records {
#       ttl = 10
#       type = "SRV"
#     }
#     routing_policy = "MULTIVALUE"
#   }
#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
# resource "aws_ecs_task_definition" "postgrestask" {
#   family                   = "postgres"
#   task_role_arn            = var.aws_iam_role.arn
#   execution_role_arn       = var.aws_iam_role.arn
#   container_definitions    = data.template_file.postgres.rendered
#   network_mode             = "awsvpc"
#   memory                   = "1024"
#   cpu                      = "512"
#   requires_compatibilities = ["FARGATE"]

# }
# resource "aws_ecs_task_definition" "djangotask" {
#   family                   = "django"
#   task_role_arn            = var.aws_iam_role.arn
#   execution_role_arn       = var.aws_iam_role.arn
#   container_definitions    = data.template_file.django.rendered
#   network_mode             = "awsvpc"
#   memory                   = "1024"
#   cpu                      = "512"
#   requires_compatibilities = ["FARGATE"]

# }
resource "aws_ecs_task_definition" "pacttask" {
  family                   = "pact"
  task_role_arn            = var.aws_iam_role.arn
  execution_role_arn       = var.aws_iam_role.arn
  container_definitions    = data.template_file.pact.rendered
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  requires_compatibilities = ["FARGATE"]

}
resource "aws_ecs_service" "this" {
  name            = "pact-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.pacttask.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["${var.public_subnet_id[0]}"]
    security_groups  = ["${var.security-group.id}"]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.this.id
    container_name = "pact-web-ui"
    container_port = 9292
  }
}

resource "aws_alb" "this" {
  name = "agharameez-alb"
  load_balancer_type = "application"
  security_groups = ["${var.security-group.id}"]
  subnets = [for subnet in var.public_subnet_id : subnet]
}

resource "aws_alb_target_group" "this" {
  name = "agharameez-tg"
  port = 9292
  protocol = "HTTP"
  vpc_id = var.vpc_id.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = "/diagnostic/status/heartbeat"
        unhealthy_threshold = "2"
  }
}
resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }
}