resource "aws_ecs_task_definition" "ecs_terraform_task_def" {
  family                   = "ecs_terraform_task_def"
  requires_compatibilities = ["FARGATE"]
  task_role_arn = aws_iam_role.task_def_role.arn
  execution_role_arn = aws_iam_role.task_def_role.arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = jsonencode(
[
  {
    "name": "nginx",
    "image": "nginx:latest",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings" = [
        {
          "containerPort" = 80
          "hostPort"      = 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "newrelic"
        },
        "secretOptions": [
          {
            "name": "licenseKey",
            "valueFrom": "arn:aws:secretsmanager:us-east-1:382904467012:secret:licenseKey-82AfeN"
          }
        ]
      }
    },
  
  
  {
      "essential": true,
      // Image below is New Relic's Fluent Bit output plugin available on ECR
      "image": "533243300146.dkr.ecr.us-east-1.amazonaws.com/newrelic/logging-firelens-fluentbit",
      "name": "log_router",
      "firelensConfiguration": {
        "type": "fluentbit",
        "options": {
          "enable-ecs-log-metadata": "true"
        }
      }
    }
])

}