terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}



provider "docker" {
  host = "unix:///var/run/docker.sock"
}



# Creating a Docker Image ubuntu with the latest as the Tag.
resource "docker_image" "ubuntu" {
  name = "geerlingguy/docker-ubuntu2204-ansible"
}



# Creating a Docker Container using the latest ubuntu image.
resource "docker_container" "openROADsandbox" {
  image             = docker_image.ubuntu.latest
  name              = "terraform-docker-ansible-openROAD"
  must_run          = true
  publish_all_ports = true

  #inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

  provisioner "local-exec" {
    command = "ansible-playbook -u root openROAD.yml -i hosts"
  }

  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}
