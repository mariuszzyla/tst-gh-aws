variable "envname" {
    type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "disk_size" {
    type = number
    default = 10
}

variable "ebs_type" {
    type = string
    default = "gp2"
}