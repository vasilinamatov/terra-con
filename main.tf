terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
locals {
  input_file = jsondecode(file("${path.module}/data.json"))
}
resource "random_string" "password" {
 count =  length(local.input_file.users)
 length = 16
 special = true
}
locals {
  users_flatten = flatten([for i,json in local.input_file.users:
    [for key,value in json : { key="user[${i}].${key}", "value"=value }]])
  yaml_encode = yamlencode({"users"= local.users_flatten})
}
output "test1" {
    value = local.yaml_encode
}

output "password_list" {
    value = random_string.password[*].result
}