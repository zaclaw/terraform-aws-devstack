variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "aws access key"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "aws secret key"
}

variable "prefix" {
  type        = string
  description = "prefix to identify resource names"
}

variable "region" {
  type        = string
  description = "region for resources"
  default     = "ap-southeast-2"
}

variable "cidr" {
  type        = string
  description = "Base CIDR block"
  default     = "192.168.0.0/16"
}

variable "subnet" {
  type        = string
  description = "Base subnet"
  default     = "192.168.0.0/24"
}

variable "instance_count" {
  description = "Number of EC2 instances to provision"
  default     = "1"
}

variable "key_pair_name" {
  description = "Key pair name"
}
/*
variable "key_path" {
  description = "path to ssh key to login to host"
}
*/