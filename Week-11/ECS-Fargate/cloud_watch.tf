resource "aws_cloudwatch_log_group" "ecs_nginx_logs" {
  name              = "/ecs/nginx"
  retention_in_days = 7
}