locals {
  api_gw_fqdn = "${var.SUBDOMAIN}.${data.aws_route53_zone.public.name}"
}