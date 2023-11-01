resource "aws_ecs_service" "ecs_terraform_service" {
  name            = var.service_name
  launch_type = "FARGATE"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs_terraform_task_def.id
  desired_count   = 1
#   iam_role        = aws_iam_role.task_def_role.arn
#   depends_on      = [aws_iam_role_policy.ecr-iam-policy]


 network_configuration {
    subnets = var.private_subnet_id
    assign_public_ip = false
    security_groups = [module.web_server_sg.security_group_id]
 }

 load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "nginx"
    container_port   = 80
  }
}
