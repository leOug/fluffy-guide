packer {
  required_plugins {
    docker = {
      version = ">=0.07"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {

  image  = var.docker_image
  commit = "true"
}

source "docker" "ubuntu-bionic" {

  image = "ubuntu:bionic"
  commit = true
}

build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-bionic"
  ]

  provisioner "shell" {

    environment_vars = [      
      "FOO=hello world",
    ]

  inline = [
    "echo Adding file to Docker Container",
    "touch example.txt" ,
    "echo \"FOO is $FOO\" >> example.txt" ,
   ]

  }
  provisioner "shell" {

    inline = [
     "echo Oompa Loompas",
     "echo Running ${var.docker_image} Docker image"
    ]

  }
  post-processor "docker-tag" {
    repository = "local-packer"
    tags = ["ubuntu-xenial","packer-rocks"]
    only = ["docker.ubuntu"]
  }

  post-processor "docker-tag"{
    repository = "local-packer"
    tags = ["ubuntu-bionic" , "packer-rocks"]
    only = ["docker.ubuntu-bionic"]
  }
}

variable "docker_image" {
  
  type = string

  default = "ubuntu:xenial"
}
