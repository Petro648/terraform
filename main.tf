provider "google" {
 // credentials = "var.credentials"
  credentials = "${file("terraform-1-125-8d83f2c5c03b.json")}"
  project     = "var.poject"
  region      = "var.region"
  zone        = "var.zone"
  }

resource "google_compute_instance" "appserver" {
  name         = "back-end"
  machine_type = "g1-small"
   
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