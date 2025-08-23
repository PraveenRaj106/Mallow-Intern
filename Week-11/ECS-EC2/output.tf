output "alb-dns" {
    value = aws_lb.my_alb.dns_name
}