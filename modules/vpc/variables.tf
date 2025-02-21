variable "is_osaka" {
  type = bool
}
variable "vpc_cidr" {
  type = string
}
variable "subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}