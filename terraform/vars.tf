variable "aws_profile" {
  type        = string
  description = "AWS local profile name to deploy"
}

variable "prefix" {
  type        = string
  description = "resource name prefix. O we can call it environment. So for production it can be prod and for development it can be dev"
}

variable "db_user" {
  type        = string
  description = "database username"
}

variable "db_password" {
  type        = string
  description = "database password"
}

variable "task_definition_memory" {
  description = "ECS task definition memory"
  type        = number
  default     = 2048
}

variable "task_definition_cpu" {
  description = "ECS task definition CPU"
  type        = number
  default     = 1024
}

variable "container_memory" {
  description = "Container memory"
  type        = number
  default     = 512
}

variable "container_cpu" {
  description = "Container cpu"
  type        = number
  default     = 256
}