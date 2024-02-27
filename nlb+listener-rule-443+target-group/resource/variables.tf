variable "create" {
  description = "If true, the resources will created."
  type        = bool
  default     = true
}
variable "load_balancing_settings" {
  type    = any
  default = []
}
variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application, gateway, or network"
  type        = string
  default     = "application"
}
variable "alb_arn_to_nlb_listener" {
  type    = any
  default = []
}
variable "health_check" {
  type    = any
  default = []
}
variable "load_balancing_listener_http" {
  type    = any
  default = []
}
variable "load_balancing_listener_https" {
  type    = any
  default = []
}
variable "target_group_settings" {
  type    = any
  default = []
}
variable "service_load_balancing_https" {
  type    = any
  default = []
}
variable "cluster_type" {
  description = "Cluster Type, permite apenas valores FARGATE e EC2. Que são compativeis com o base no tipo que precisa iniciar sua task."
  type        = string
  default     = "EC2"
}
variable "default_tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}