packer {
  required_plugins {
    docker = {
      version = ">=0.07"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:xenial"
  commit = "true"
}

build {
  name = "learn-packer"
  sources = [

    "source.docker.ubuntu"

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
    inline = ["echo This provisioner runs last"]

  }
}
