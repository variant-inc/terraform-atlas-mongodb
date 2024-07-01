variable "org_id" {
  description = "MongoDB Atlas Org ID"
  type        = string
}

variable "provider_name" {
  description = "MongoDB Atlas Terraform Provider"
  type        = string
  default     = "AWS"
}

variable "version_release_system" {
  description = "MongoDB Version Release System. Must be one of LTS or CONTINUOUS."
  type        = string
  default     = "LTS"
  validation {
    condition     = can(regex("^LTS$|^CONTINUOUS$", var.version_release_system))
    error_message = "Invalid MongoDB version release system. Must be one of LTS or CONTINUOUS."
  }
}

variable "enable_backup" {
  description = "MongoDB Backup Snapshots would be enabled in AWS"
  type        = bool
  default     = true
}

variable "mongo_db_major_version" {
  description = "Required MongoDB Server Version"
  type        = string
  default     = "7.0"
}

variable "project" {
  description = "MongoDB Atlas Project Name where your clusters would deploy"
  type        = string
}

variable "pit_enabled" {
  description = "cluster uses Continuous Cloud Backup"
  type        = string
  default     = "false"
}

variable "name" {
  description = "Name of the MongoDB Atlas cluster"
  type        = string
}

variable "read_only_nodes" {
  description = "Number of read-only nodes in the cluster."
  type        = number
  default     = 0
}

variable "num_shards" {
  description = "Sets the number of shards for a sharded cluster."
  type        = number
  default     = 1
}

variable "instance_size" {
  description = "Specifies the instance size (e.g., M10, M20, etc.)."
  type = object({
    min = string
    max = string
  })
  default = {
    max = "M30"
    min = "M10"
  }
}

variable "disk_gb_enabled" {
  description = "Enables or disables disk auto-scaling"
  type        = bool
  default     = true
}

variable "compute_enabled" {
  description = "Enables or disables compute resources."
  type        = bool
  default     = true
}

variable "compute_scale_down_enabled" {
  description = "Enables or disables scaling down of compute resources."
  type        = bool
  default     = true
}

variable "node_count" {
  description = "Number of nodes in the MongoDB Atlas cluster."
  type        = number
  default     = 3
}

variable "ip_access_list" {
  type        = list(string)
  description = "List of IP addresses or CIDR blocks allowed to access the MongoDB Atlas cluster"
  default     = ["10.0.0.0/8", "172.17.0.0/16", "192.168.0.0/16"]
}

variable "kms_key_id" {
  type        = string
  description = "The ID of the AWS KMS key used to encrypt secrets managed by Secrets Manager."
}
