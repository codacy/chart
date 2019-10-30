# variables.tf - user settings. For provider settings see config.tf

variable "project_tag" {
  description = "Project tag to add to s3 and dynamodb names"
  type = string
  default = "codacy-beta"
}

variable "unique_string" {
  description = "String (containing only lowercase characters) to ensure that the S3 bucket name is unique"
  type = string
}
