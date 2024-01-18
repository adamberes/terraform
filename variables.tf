variable "ips_web" {
  type = map(string)
  default = {
    "0" = "10.0.1.101"
    "1" = "10.0.1.102"
    "2" = "10.0.1.103"
    "3" = "10.0.1.104"
    "4" = "10.0.1.105"
  }
}

variable "selected-ami" {
  description = "Selected Ami"
  default     = "Ubuntu Server 22.04 LTS ubuntu"
}
variable "map-ami-name-user" {
  type = map(string)
  default = {
    "Amazon Linux AMI ec2-user"             = "ami-14c5486b"
    "debian-12-amd64-20231013-1532 admin"   = "ami-058bd2d568351da34"
    "capa-ami-centos-7 ec2-user"            = "ami-0a70ee3151d820195"
    "CentOS-8.4.2105 v2 (Minimal) ec2-user" = "ami-0664e6888688ad545"
    "Ubuntu Server 22.04 LTS ubuntu"        = "ami-0c7217cdde317cfec"
  }
}

