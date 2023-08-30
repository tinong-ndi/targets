variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "region" { default = "us-west-2" }
variable "project-name" { default = "vercara-vpc" }
variable "default_route" {
  description = "Default Route from and to internet"
  default     = "0.0.0.0/0"
}
variable "task-def-family" { default = "tinong-task" }
variable "cluster-name" { default = "web-cluster" }
variable "network-mode" { default = "awsvpc" }
variable "task-def-cpu" { default = 1024 }
variable "task-def-memory" { default = 2048 }
variable "service-name" { default = "tinong-tf-service" }
variable "des-count" { default = 2 }
variable "launch-type" { default = "FARGATE" }
variable "container-name" { default = "latest" }
variable "container-port" { default = 80 }

