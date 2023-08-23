//PARAMETERS
variable "port" {
  description = "The port number that is used to connect to a Redis server."

  type = number
  default = 6379
}
//PARAMETERS

//CONTEXT
variable "context" {
  description = "Radius-provided object containing information about the resource calling the Recipe."

  type = any
}
//CONTEXT