provider "google" {
 // credentials = "var.credentials"
  credentials = "${file("C:/Git-1/terraform/Keys/terraform-1-125-0acec1141512.json")}"
  project     = var.project
  region      = var.region
  zone        = var.zone
  }

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "g1-small"

   tags = ["jenkins","http-server"]

   metadata = {
sshKeys = "petro:${file("C:/Git-1/terraform/Keys/cloud.pub")}"
   }

   boot_disk {
    initialize_params {
      image = "centos-7"
    }
  }

  network_interface {
    network = "default"

    access_config {}
      // Ephemeral IP
    }  
connection {
    user = "petro"
    host = "${google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip}"
    private_key = "${file("C:/Git-1/terraform/Keys/cloud")}"
    agent = false  
  } 

provisioner "remote-exec" {
      inline = [
        // install java-openjdk and Jenkins
        "chmod +x C:/Git-1/terraform/files/jenkins-install.sh ",
        "C:/Git-1/terraform./files/jenkins-install.sh"     
      ]
  }
}    

