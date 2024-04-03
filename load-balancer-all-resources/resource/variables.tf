variable "create" {
  description = "If true, the resources will created."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of ALB/NLB."
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal."
  type        = bool
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application, gateway, or network"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the LB."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network."
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
  default     = false
}

variable "access_logs" {
  description = "Access Logs block."
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subnet_mapping" {
  description = "Subnet Mapping blocks support the following."
  type        = list(map(string))
  default     = []
}

#variable "https_listeners" {
#    description = "Listeners HTTPS block"
#    type    = any
#    default = []
#}

variable "listener_rule" {
  description = "Listeners HTTP block"
  type        = any
  default     = []
}

variable "listeners" {
  description = "Listeners HTTP block"
  type        = any
  default     = []
}

variable "listener_ssl_policy_default" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "stickiness" {
  type    = any
  default = {}
}

variable "health_check" {
  type    = any
  default = []
}

variable "load_balancing_settings" {
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