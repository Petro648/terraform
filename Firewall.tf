resource "google_compute_firewall" "allow-http" {
  name    = "http-server"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
   target_tags   = ["jenkins","http-server"]
  source_ranges = ["0.0.0.0/0"]
}


//certain-sun-252012/global/networks/default

//projects/terraform-1-125/global/networks/google_compute_network.default.jenkins' was not found, notFound