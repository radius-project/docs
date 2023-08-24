//PARAMETERS
variable "port" {
  description = "The port number that is used to connect to a Redis server."

  type = number
  default = 6379
}

variable "username" {
  description = "The username that is used to connect to a Redis server."

  type = string
  default = "username"
}

variable "password" {
  description = "The password that is used to connect to a Redis server."

  type = string
  default = "password"
}
//PARAMETERS

//CONTEXT
variable "context" {
  description = "Radius-provided object containing information about the resource calling the Recipe."

  type = any
}
//CONTEXT