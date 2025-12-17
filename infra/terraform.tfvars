# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "laravel-notes"
environment  = "production"

# Application Configuration
app_replicas = 2
docker_image = "builtbywahab/laravel-notes:latest"

# Laravel APP_KEY - Generated
app_key = "base64:kH8vKzO5mQw7Y3xPnN2rL4vD9sJ6tF1uB5cA8gE0mR3="

# Database Configuration
db_name           = "notes_db"
db_user           = "laravel_user"
db_password       = "Laravel2025SecurePass"
db_instance_class = "db.t3.micro"

# Redis Configuration
redis_node_type = "cache.t3.micro"
