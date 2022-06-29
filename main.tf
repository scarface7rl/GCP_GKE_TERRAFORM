# PROVEDOR
provider "google" {
  project     = "project_name"
  region      = "region"
}

# GERADOR DE RANDOM ID
resource "random_id" "instance_id" {
  byte_length = 8
}

# BUCKET STORAGE > SÓ É CRIADO APÓS SER GERADO O RANDOM ID
resource "google_storage_bucket" "bucket_name" {
  name          = "bucket_name-" #   
# name = "bucket-tfstate-${random_id.instance_id.hex}"        >>>> PARA USAR O RANDON ID QUE É GERADO SOMENTE APÓS O APPLY
  force_destroy = false
  location      = "	region"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  depends_on = [
    random_id.instance_id  
]
}

#  CLUSTER DO GKE 
resource "google_container_cluster" "gkecobransaas-dev" {
  project  = var.gcp_project
  name     = "gke-clustername"
  location = "region"

  min_master_version = "stable"

  # ALOCAÇÃO DOS IPS DOS PODS
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/20"
  }

  # Removes the implicit default node pool, recommended when using
  # google_container_node_pool.
  remove_default_node_pool = true
  initial_node_count = 3
}