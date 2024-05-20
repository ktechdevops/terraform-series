variable "NAME_PRFIX" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = "compute-instance"
}

variable "AMI_ID" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}

variable "AVAILABILITY_ZONE" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "EBS_BLOCK_DEVICE" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}

variable "INSTANCE_TYPE" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "INSTANCE_COUNT" {
  type    = number
  default = 1
}

variable "HOSTNAME" {
  description = "Hostname to be initialized with"
  type        = string
  default     = "bastion-node"
}


variable "ASSOCIATE_PUBLIC_IP_ADDRESS" {
  type = bool
  default = false
}
###################################S

variable "INSTANCE_TAGS" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "KEY_NAME" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "MONITORING" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = null
}

variable "PRIVATE_IP" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "ROOT_BLOCK_DEVICE" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "SUBNET_ID" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "TAGS" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "USER_DATA" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead"
  type        = string
  default     = null
}

variable "USER_DATA_BASE64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption"
  type        = string
  default     = null
}

variable "VOLUME_TAGS" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "ENABLE_VOLUME_TAGS" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}

variable "VPC_SECURITY_GROUP_IDS" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "ROOT_VOLUME_SIZE" {
  description = "Size of the instance root volume"
  type = string
  default = "30"
}
