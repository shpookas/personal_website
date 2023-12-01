# TASK DEFINITION


# Module to find roles
module "roles" {
  source = "../roles"
  # other module configurations
}

resource "aws_ecr_repository" "app_ecr_repo" {
  name = "app-repo"
}
resource "aws_ecs_cluster" "my_cluster" {
  name = "website-cluster" 
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "app-first-task" # Name your task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "app-first-task",
      "image": "${aws_ecr_repository.app_ecr_repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
  network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
  memory                   = 512         # Specify the memory the container requires
  cpu                      = 256         # Specify the CPU the container requires
  execution_role_arn       = module.roles.aws_iam_role.arn
}

output "aws_ecs_task_definition" {
  value = aws_ecs_task_definition.app_task
}
output "aws_ecs_cluster" {
    value = aws_ecs_cluster.my_cluster
  
}
