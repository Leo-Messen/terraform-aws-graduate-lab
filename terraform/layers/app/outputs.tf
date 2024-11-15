// Output ALB DNS name in terraform to provide easy access to website URL.
output "grad_lab_1_alb_dns_name" {
  value = module.grad_lab_1_alb.dns_name
}
