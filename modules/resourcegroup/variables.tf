variable "name" {
  type = string
  description = "The name of the resource group."
}

variable "location" {
  type = string
  description = "The location of the resource group."
}

variable "environment" {
  type    = string
  default = "development"
  description = "The environment of the resource group."
}

variable "owner" {
  type    = string
  default = "platform-team"
  description = "The owner of the resource group."
}