provider "google" {
  credentials = file("cred.json")
  project = "mytraining-gcptech"
  region  = "us-central1"
  zone    = "us-central1-a"
}
resource "google_compute_address" "static-ip" {
  name = "static-ip"
  address_type = "EXTERNAL"
}
resource "google_compute_instance" "gce-infra" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }

  }
network_interface {
# A default network is created for all GCP projects
#network       = "default"
	  network = "default"
    access_config {
	    nat_ip = google_compute_address.static-ip.address
      network_tier = "PREMIUM"
    }
  }
}
resource "google_compute_network" "gce-infra" {
  name                    = "terraform-network"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "gce-infra" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.gce-infra.self_link
}
resource "google_compute_firewall" "gce-infra" {
  name    = "test-firewall"
  network = google_compute_network.gce-infra.id

  allow {
    protocol = "icmp"
  }
  /*allow {
    protocol = "ssh"
    ports    = ["22"]
  }*/
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}