provider "google" {
 // credentials = "var.credentials"
  credentials = "${file("C:/Git-1/terraform1/Keys/terraform-1-125-0acec1141512.json")}"
  project     = var.project
  region      = var.region
  zone        = var.zone
  }

resource "google_compute_instance" "jenkince" {
  count        = var.inst_count
  name         = "instance-${count.index + 1}"
  machine_type = "f1-micro"

   tags = ["jenkins","http-server","mongodb"]

   metadata = {
sshKeys = "petro:${file("C:/Git-1/terraform1/Keys/cloud.pub")}"
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
}