variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "laravel-notes"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "app_replicas" {
  description = "Number of ECS tasks for Laravel application"
  type        = number
  default     = 2
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "notes_db"
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "laravel_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "app_key" {
  description = "Laravel application key"
  type        = string
  sensitive   = true
}

variable "docker_image" {
  description = "Docker image for Laravel application"
  type        = string
  default     = "your-dockerhub-username/laravel-notes:latest"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}
