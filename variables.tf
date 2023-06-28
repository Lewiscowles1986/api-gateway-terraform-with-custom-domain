variable "HOSTED_ZONE_ID" {
  type        = string
  description = "The AWS Hosted Zone ID you wish to set this up within"
}

variable "SUBDOMAIN" {
  type        = string
  description = "The prefix i.e. 'api' if you wanted api.{yourdomain.ext}"
  default     = "api"
}

variable "DEFAULT_API_GW_STAGE" {
  type        = string
  description = "The stage this will deploy. Defaults to staging"
  default     = "staging"
}
