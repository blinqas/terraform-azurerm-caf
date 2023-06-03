variable "settings" {}
variable "keyvault" {}

variable "subject_alternative_names" {
  description = "Subject Alternative Names to use for the certificate"
  type = object({
    dns_names = list(string)
    emails    = list(string)
    upns      = list(string)
  })
  default = {
    dns_names = []
    emails    = []
    upns      = []
  }
}
