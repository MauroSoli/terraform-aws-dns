# variables.tf

variable "dns_zone" {
  description = "AWS hosted zone name"
  type        = string
}

variable "records" {
  description = "DNS records"
  default     = []
  type        = list(any)
}

variable "is_it_a_registered_domain" {
  description = "Is the specified domain an AWS registered domain?"
  default     = false
  type        = bool
}
