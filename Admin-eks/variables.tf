
variable "username" {
  type    = list(any)
  default = ["mark", "manager","jane"]
}

variable "env" {
  type    = list(any)
  default = ["Development", "Production"]
}

variable "tags" {
  type = map(string)
  default = {
    Env = "Production"
  }
}
