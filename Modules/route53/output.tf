output "route53-nameservers" {
  value = data.aws_route53_zone.petadopt_hosted_zone.name_servers
}

output "petadopt-signed-cert" {
  value = aws_acm_certificate.petadopt-cert.arn
}