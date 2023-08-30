resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.cluster-name

  # tags = var.cluster-tags
}

# create task definition
resource "aws_ecs_task_definition" "ecs-task-def" {
  family                   = var.task-def-family
  network_mode             = var.network-mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task-def-cpu
  memory                   = var.task-def-memory
  execution_role_arn = aws_iam_role.execution_role.arn
  container_definitions = jsonencode([{
    name  = "latest",
    image = "650939046310.dkr.ecr.us-west-2.amazonaws.com/webapp:latest",
    cpu       = 256
    memory    = 512
    portMappings = [
      {
        containerPort = 80,
        hostPort      = 80
      }
    ]
  }])
}

# create an ecs service 
resource "aws_ecs_service" "ecs-service" {
  name            = var.service-name
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs-task-def.arn
  desired_count   = var.des-count
  launch_type     = var.launch-type

  network_configuration { 
    security_groups = [module.sg.alb-sg-id]
    subnets         = tolist(module.vpc.public-subnets-ids)
  }

  load_balancer {
    target_group_arn = module.alb.alb-tg-arn
    container_name   = var.container-name
    container_port   = var.container-port
  }

  #depends_on = [aws_lb_listener.ecs-lb-listener]
}

resource "aws_iam_role" "execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_policy" "ecr_read_policy" {
  name = "ecr-read-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecr_read_policy_attachment" {
  name = "ecr-read-policy-attachment"
  roles = [aws_iam_role.execution_role.name]

  policy_arn = aws_iam_policy.ecr_read_policy.arn
}
