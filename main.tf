provider "google" {
 // credentials = "var.credentials"
  credentials = "${file("terraform-1-125-dd2aa12ead53.json")}"
  project     = var.project
  region      = var.region
  zone        = var.zone
  }

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "g1-small"

   tags = ["jenkins","http-server"]

   metadata = {
sshKeys = "petro:${file("instance.pub")}"
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
    private_key = "${file("C:/Users/pduzi/.ssh/instance")}"
    agent = false  
  } 

provisioner "remote-exec" {
      inline = [

        // install java-openjdk and Jenkins
        // "sudo yum update -y",
        "sudo yum install java-1.8.0-openjdk-devel -y", 
        "sudo yum install wget -y",
        "sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo",
        "sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key",
        "sudo yum install jenkins -y",
        "sudo systemctl start jenkins.service",
        "sudo systemctl enable jenkins.service"
      ]
  }
}    

