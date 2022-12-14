variable "network_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "private_ip_address_name" {
  type = string
}

variable "cidr_block_prefix_length" {
  type = number
}

variable "region" {
  type        = string
  description = "region to deploy SQL instances"
}

variable "database_version" {
  type = string
}

variable "home_ip_address" {
  type = string
}

variable "instance_specs" {
  type = string
}

variable "password" {
  type = string
}

variable "db_user" {
  type = string
}
