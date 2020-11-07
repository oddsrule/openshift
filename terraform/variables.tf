variable "resource_group" {
  type        = string
  description = "This will be the name of the resource group our ARO cluster will be in"
  default     = "aro_sandbox"
}

variable "location" {
  type        = string
  description = "This will be the location used for all location dependant resources"
  default     = "westus2"
}

variable "cluster" {
  type        = string
  description = "This will be the name of our ARO cluster"
  default     = "cluster_sandbox"
}

variable "vnet" {
  type        = string
  description = "This will be the name of the vnet created for ARO"
  default     = "aro_vnet"
}

variable "address_space" {
  type        = list(string)
  description = "This will be a list of address spaces for our ARO vnet"
  default     = ["10.0.0.0/22"]
}

variable "subnet_names" {
  description = "A list of the subnets I'm creating for ARO"
  type        = list(string)
  default     = ["master", "worker"]
}

variable "subnet_prefixes" {
  description = "A list of address prefixes for my subnets"
  type        = list(string)
  default     = ["10.0.0.0/23", "10.0.2.0/23"]
}

variable "kubeadminuser" {
  type        = string
  description = "This will be the name of the kubeadmin user"
  default     = "kubeadmin"
}