// variable "credentials" {
//  description = "service_account_key"
//    default = "/c/anyfile.json"
// }

variable "project" {  
description = "project id"
default     = "terraform-1-125"
}

variable "region" {
description = "region"
default = "europe-west4"
}

variable "zone" {
description = "zone"
default = "europe-west4-a"
}

variable "Jenkins_user" {
description = "Jenkins_user"
default = "petro-j"
}

variable "Jenkins_pass" {
description = "Jenkins_pass"
default = "Qwerty123!"
}

variable "inst_count" {
    description = "namber instance"
    default = 3  
}