/* This is multi-line Comment*/
provider "google" {
  credentials = file("cred.json")
  project = "mytraining-gcptech"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}
# This is single line comment
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"

   # access_config {
      # Ephemeral IP
    #}
  }
}