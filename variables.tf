// Required

variable "vpc" {
  description = "VPC id for app cluster"
}

variable "subnets" {
  type        = "list"
  description = "List of subnet ids for app cluster, please choose 2 subnets"
}

variable "key_name" {
  description = "Name of key pair for SSH login to app cluster instances"
}

variable "ami" {
  description = "app cluster instance AMI id"
}

// Customize for container options

variable "app_name" {
  description = "Your application name"
}

variable "https" {
  description = "Listen over https"
  default     = false
}

variable "app_certificate_arn" {
  description = "SSL cert ARN"
  default     = ""
}

variable "app_ssl_policy" {
  description = "SSL Policy"
  default     = "ELBSecurityPolicy-2015-05"
}

variable "container_port" {
  description = "Port number exposed by container"
  default     = 80
}

variable "service_count" {
  description = "Number of containers"
  default     = 3
}

// Customize for spot fleet options

variable "spot_prices" {
  description = "Bid amount to spot fleet"
  type        = "list"
  default     = ["0.03", "0.03"]
}

variable "strategy" {
  description = "Instance placement strategy name"
  default     = "diversified"
}

variable "instance_count" {
  description = "Number of instances"
  default     = 3
}

variable "instance_type" {
  description = "Instance type launched by spot fleet"
  default     = "m3.medium"
}

variable "volume_size" {
  description = "Root volume size"
  default     = 16
}

variable "app_port" {
  description = "Port number of application"
  default     = 80
}

variable "valid_until" {
  description = "limit of spot fleet"
  default     = "2020-12-15T00:00:00Z"
}
