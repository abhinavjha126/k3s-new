variable "ssh_key" {
  type = string
  #default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFJnwBV704MYn2pgQKPbzIuW8PJmy3NZNX1TXfOnAqM super@DESKTOP-U8L96OL"
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdera+GnDRsLOtuBrpN/cVZD+7a/FwW02EdWZ8lwwXh root@ubuntu-s-1vcpu-2gb-blr1-01"
}



variable "project" {
  type = string
  description = "project"
  default = "k3s"
}


variable "prod_env" {
  type = string
  description = "production environment"
  default = "prod"
}


variable aws_region {
  type = string
  default = "ap-south-1"
  description = "aws_region"
}

variable "kube_master_hostname" {
  type = string
  default = "ip-10-100-0-10"
}

variable "kube_master_ip_address" {
  type = string
  default = "10.100.0.10"
}

variable "k3s_version" {
  type = string
  default = "v1.21.5+k3s1"
}


###
# VPC resources
##
 
variable vpc_cidr {
  type = string
  default = "10.100.0.0/16"

}

variable "master_subnets" {
  default = {
    0 = {
      id = 0
      name = "master0"
      az = "ap-south-1a"
      cidr = "10.100.0.0/24"
    },
    1 = {
      id = 1
      name = "master1"
      az = "ap-south-1b"
      cidr = "10.100.1.0/24"
    },
    2 = {
      id = 2
      name = "master2"
      az = "ap-south-1c"
      cidr = "10.100.2.0/24"
    },
  }
}
variable "worker_subnets" {
  default = {
    3 = {
      id = 0
      name = "worker0"
      az = "ap-south-1a"
      cidr = "10.100.10.0/24"
    },
    4 = {
      id = 1
      name = "worker2"
      az = "ap-south-1b"
      cidr = "10.100.11.0/24"
    },
    5 = {
      id = 2
      name = "worker3"
      az = "ap-south-1c"
      cidr = "10.100.12.0/24"
    }
  }
}

variable "master_instances" {
  default = {
    master1 = {
      id = 1
      az = "ap-south-1b"
      name = "master1"
      ip_address = "10.100.1.10"
    },
    master2 = {
      id = 2
      az = "ap-south-1c"
      name = "master2"
      ip_address = "10.100.2.10"    
      },
  }
}

variable "worker_instances" {
  default = {
    worker0 = {
      id = 0
      name = "worker0"
      az = "ap-south-1a"
      ip_address = "10.100.10.10"
    },
    worker1 = {
      id = 1
      name = "worker1"
      az = "ap-south-1b"
      ip_address = "10.100.11.10"
    },
    worker2 = {
      id = 2
      az = "ap-south-1c"
      name = "worker2"
      ip_address = "10.100.12.10"    
      },
  }
}

variable "ami_image" {
  type = string
  #default = "ami-0953b38f670ad3e1e"
  default = "ami-0c1a7f89451184c8b"
}

variable "master_instance_type" {
  type = string
  default = "t3.medium"
}

variable "worker_instance_type" {
  type = string
  default = "t3.medium"
}

variable "master_root_volume_type" {
  type = string
  default = "gp2"
}

variable "master_root_volume_size" {
  type = number
  default = 8
}

variable "worker_root_volume_type" {
  type = string
  default = "gp2"
}

variable "worker_root_volume_size" {
  type = number
  default = 8
}

variable "k3s_ingress_rules" {
  default = {
    "vxlan" = {
      name = "vxlan"
      from_port = 4789
      to_port = 4789
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "vxlan"
    },
    "udp8472" = {
      name = "udp8472"
      from_port = 8472
      to_port = 8472
      protocol = "udp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "udp8472"
    },
      "tcp8000" = {
      name = "tcp8000"
      from_port = 8000
      to_port = 8000
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "tcp8000"
    },
        "tcp9000" = {
      name = "tcp9000"
      from_port = 9000
      to_port = 9000
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "tcp9000"
    },
        "etcd" = {
      name = "etcd"
      from_port = 2379
      to_port = 2380
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "etcd"
    },
        "tcp6443" = {
      name = "tcp6443"
      from_port = 6443
      to_port = 6443
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "tcp6443"

    },
        "tcp2381" = {
      name = "tcp2381"
      from_port = 2381
      to_port = 2381
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "tcp 2381"

    },
    "bgp" = {
      name = "bgp"
      from_port = 179
      to_port = 179
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "BGP"
    },
        "ip_in_ip" = {
      name = "ip_in_ip"
      from_port = 0
      to_port = 0
      protocol = "4"
      cidr_blocks = ["10.100.0.0/16"]
      description = "IP in IP"
    },
        "calico_typha" = {
      name = "typha"
      from_port = 5473
      to_port = 5473
      protocol = "tcp"
      cidr_blocks = ["10.100.0.0/16"]
      description = "calico typha"
    }, 
  }
}
