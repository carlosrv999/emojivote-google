module "network" {
  source = "./modules/network"

  network_name = "vpc-notesapp"
  public_subnets = [
    "10.100.0.0/21",
  ]
  private_subnets = [
    "10.100.8.0/21",
  ]
  public_subnet_suffix  = "public-project-notesapp"
  private_subnet_suffix = "private-project-notesapp"
  region                = var.region

}

module "database" {
  source = "./modules/database"

  network_id               = module.network.network_id
  cidr_block               = "10.100.32.0"
  private_ip_address_name  = "private-sql-network"
  cidr_block_prefix_length = 20
  region                   = var.region
  database_version         = "MYSQL_8_0"
  home_ip_address          = "38.25.18.114"
  instance_specs           = "db-n1-standard-2"
  db_user                  = var.db_user
  password                 = var.db_password
}

module "dns" {
  source = "./modules/dns"

  name = "carlosrv125"
}

module "repository" {
  source = "./modules/repository"

  project_id = var.project_id
  repo_name  = "my-repository"
  region     = var.region
}

module "microservices" {
  source = "./modules/microservices"

  project_id = var.project_id
  region     = var.region
  network    = module.network.network_name
  subnetwork = module.network.public_subnets_names[0]
}
