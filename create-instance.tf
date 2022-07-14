resource "google_compute_address" "static" {
  name = "ipv4-address"
}
resource "google_compute_instance" "default" {
  name         = "jforg-vm"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

metadata = {
    ssh-keys = "testuser:ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAifGBisNw/lYu+v7WWOtZK1fWeYVCRRN/GijAqBsveF0yvDuRB1SY1tNWnp2/ZSkACEEXgfnKIQgINmQr4er3CFACDoHD3voN6gxh33IV/+UXiiUPZUUHip/dbWENsDrUj1sWpL90zB2t+IkrULZvRkm9yz7ztZB5ZFofb4G4eVvdciUSG6xuogCHLkKUpCDMRjmciA/Z+gDRjGi3cfk66P+hgA9VrcmCGlJDB4+uFnpMTQXGNz3UJLDh7f9ehKMLFztzW8ZT/LfxSEpfMfGQow7w5duKH/UbTHsDH/rSoQMlLfzs+hz84AuZzicdPa+3SDYPHrfoGWCBu8RvURUXmw== testuser"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
 

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
      nat_ip = google_compute_address.static.address
    }
  }

  
 resource "null_resource" "copy_execute" {
    connection {
      host        = google_compute_address.static.address
      type        = "ssh"
      user        = "testuser"
      timeout     = "500s"
      private_key = "${file("/home/sravangcp/testuser.pem")}"
    }
    
    provisioner "file" {
      source      = "jfrog.sh"
      destination = "/tmp/jfrog.sh"
      }
    provisioner "remote-exec" {
      
    inline = [
      "sudo chmod 777 /tmp/jfrog.sh",
      "sh /tmp/jfrog.sh",
    ]
  }
  depends_on = [ google_compute_instance.default ]
  }

  //  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "admin-account@dolphine-project.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server"]

}


output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
