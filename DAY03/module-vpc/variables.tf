variable "myvpc" {
  description = "Enter Your VPC CIDR Block in module Resource"
}

variable "pubsub1" {
  description = "Enter the CIDR Range for Your Public Subnet 1 in Module Resource."
}

variable "availability_zone_for_pubsub1" {
  description = "Enter Availability to Choose for Public Subnet 1"
}

variable "pubsub2" {
  description = "Enter the CIDR Range for Your Public Subnet 2 in Module Resource."
}

variable "availability_zone_for_pubsub2" {
  description = "Enter Availability to Choose for Public Subnet 2"
}

variable "prisub1" {
  description = "Enter the CIDR Range for Private Subnet 1 in Module Resource."
}
