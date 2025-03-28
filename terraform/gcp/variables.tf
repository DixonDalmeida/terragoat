# variable "credentials_path" {
#   type        = string
#   description = "Path to credentials file"
# }

variable "project" {
  type        = string
  description = "The GCP project to be deployed to"
  default = "inlaid-tribute-453705-q6"
}

variable "region" {
  default = "us-central1"
  type    = string
}

variable "environment" {
  default     = "dev"
  description = "The environment name"
}

variable "location" {
  default = "us-central1c"
  type    = string
}