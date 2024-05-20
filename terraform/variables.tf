variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of project"
  type        = string
  default     = "playground-k8s"
}

variable "keypair_name" {
  type    = string
  default = null
}

variable "pri_key_path" {
  type    = string
  default = ""
}

variable "pub_key_path" {
  type    = string
  default = ""
}

variable "tags" {
  description = "deafult tags to apply to resources"
  type        = map(string)
  default = {
    terraform = "true"
    project   = "playground-k8s"
  }
}
