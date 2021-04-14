# Network for GKE
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
}

# Create subnets and ip aliases for GKE
# https://sreeninet.wordpress.com/2019/05/30/vpc-native-gke-clusters-ip-aliasing/
resource "google_compute_subnetwork" "vpc-subnet" {
  name          = var.vpc_subnet_name
  project       = var.project_id
  network       = google_compute_network.vpc.self_link
  region        = var.region
  ip_cidr_range = var.gke_network_ipv4_cidr

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.vpc_subnet_name}-pods"
    ip_cidr_range = var.gke_pods_ipv4_cidr
  }

  secondary_ip_range {
    range_name    = "${var.vpc_subnet_name}-vault-svcs"
    ip_cidr_range = var.gke_services_ipv4_cidr
  }
}

# VPC router for nodes internet access
resource "google_compute_router" "vpc-router" {
  name    = "${var.vpc_name}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.self_link

  bgp {
    asn = 64514
  }
}

# External NAT IP for Router
resource "google_compute_address" "nat-public-ip" {
  count   = 2
  name    = "${var.vpc_name}-nat-external-${count.index}"
  project = var.project_id
  region  = var.region

}

resource "google_compute_router_nat" "nat" {
  name    = "${google_compute_router.vpc-router.name}-nat"
  project = var.project_id
  router  = google_compute_router.vpc-router.name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.nat-public-ip.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc-subnet.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.vpc-subnet.secondary_ip_range[0].range_name,
      google_compute_subnetwork.vpc-subnet.secondary_ip_range[1].range_name,
    ]
  }
}

