variable "alb_name" {
  type        = string
  description = ""
  default     = ""
}
variable "internal" {
  type        = string
  description = ""
  default     = ""
}
variable "deletion_protection" {
  type        = string
  description = ""
  default     = ""
}
variable "cliente_value" {
  type        = string
  description = ""
  default     = ""
}
variable "area_value" {
  type        = string
  description = ""
  default     = ""
}
variable "sub_area_value" {
  type        = string
  description = ""
  default     = ""
}
variable "ambiente" {
  type        = string
  description = ""
  default     = ""
}
variable "container_port" {
  type        = string
  description = ""
  default     = ""
}
variable "tg_protocol" {
  type        = string
  description = ""
  default     = ""
}
variable "vpc_id" {
  type        = string
  description = ""
  default     = ""
}
variable "healthy_threshold" {
  type        = string
  description = ""
  default     = ""
}
variable "health_check_interval" {
  type        = string
  description = ""
  default     = ""
}
variable "health_check_protocol" {
  type        = string
  description = ""
  default     = ""
}
variable "health_check_matcher" {
  type        = string
  description = ""
  default     = ""
}
variable "health_check_timeout" {
  type        = string
  description = ""
  default     = ""
}
variable "health_check_path" {
  type        = string
  description = ""
  default     = ""
}
variable "http_port" {
  type        = string
  description = ""
  default     = ""
}
variable "https_port" {
  type        = string
  description = ""
  default     = ""
}
variable "ssl_alb_policy" {
  type        = string
  description = ""
  default     = ""
}
variable "load_balancer_type" {
  type        = string
  description = ""
  default     = ""
}
variable "target_group_port" {
  type        = string
  description = ""
  default     = ""
}
variable "unhealthy_threshold" {
  type        = string
  description = ""
  default     = ""
}
variable "region" {
  type        = string
  description = ""
  default     = ""
}
variable "account_id" {
  type        = string
  description = ""
  default     = ""
}
variable "domain_name" {
  type        = string
  description = ""
  default     = ""
}
variable "certificate_arn" {
  type        = string
  description = ""
  default     = ""
}
variable "security_groups" {
    description = "A list of security group IDs to assign to the LB."
    type    = list(string)
    default = []
}
variable "subnets" {
    description = "A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network."
    type    = list(string)
    default = []
}
