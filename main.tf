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

  name                            = "carlosrv125"
  webapp_load_balancer_ip_address = module.frontend.webapp_load_balancer_ip_address
  ingress_ip_address              = module.microservices.ingress_ip_address
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

module "frontend" {
  source = "./modules/frontend"

  project_id = var.project_id
  region     = var.region
}

resource "local_file" "certificates" {

  content = templatefile("${path.cwd}/templates/ssl-cert.yaml.tftpl", {
    emoji_crt = base64encode(file("${path.cwd}/sslcerts/emoji.carlosrv125.com.crt"))
    emoji_key = base64encode(file("${path.cwd}/sslcerts/emoji.carlosrv125.com.key"))
    vote_crt  = base64encode(file("${path.cwd}/sslcerts/api.carlosrv125.com.crt"))
    vote_key  = base64encode(file("${path.cwd}/sslcerts/api.carlosrv125.com.key"))
  })

  filename = "${path.cwd}/source/manifests/secrets/certificates.yaml"

}

resource "local_file" "database_credentials_emoji" {

  content = templatefile("${path.cwd}/templates/db-access-emoji.yaml.tftpl", {
    emoji_db_name   = base64encode("emoji")
    emoji_db_passwd = base64encode(var.emoji_db_password)
    emoji_db_user   = base64encode(var.emoji_db_user)
  })

  filename = "${path.cwd}/source/manifests/secrets/db-access-emoji.yaml"

}

resource "local_file" "database_credentials_vote" {

  content = templatefile("${path.cwd}/templates/db-access-vote.yaml.tftpl", {
    vote_db_name   = base64encode("votes")
    vote_db_passwd = base64encode(var.vote_db_password)
    vote_db_user   = base64encode(var.vote_db_user)
  })

  filename = "${path.cwd}/source/manifests/secrets/db-access-vote.yaml"

}

resource "local_file" "emojivote_ip_address_configmap" {

  content = templatefile("${path.cwd}/templates/db-access-configmap.yaml.tftpl", {
    db_private_ip_address = module.database.database_private_ip
  })

  filename = "${path.cwd}/source/manifests/envs/emojivote-db-access-configmap.yaml"

}

resource "local_file" "root_db_access" {

  content = templatefile("${path.cwd}/templates/root-db-access.yaml.tftpl", {
    db_host     = base64encode(module.database.database_private_ip)
    root_user   = base64encode(var.db_user)
    root_passwd = base64encode(var.db_password)
  })

  filename = "${path.cwd}/source/manifests/secrets/root-db-access.yaml"

}

resource "local_file" "initdb_job" {

  content = templatefile("${path.cwd}/templates/initdb.yaml.tftpl", {
    initdb_image = module.repository.initdb
  })

  filename = "${path.cwd}/source/manifests/jobs/initdb.yaml"

}

resource "local_file" "emojiapi_deployment" {

  content = templatefile("${path.cwd}/templates/emoji-api-deployment.yaml.tftpl", {
    emojiapi_image = module.repository.emoji_api
  })

  filename = "${path.cwd}/source/manifests/deployments/emoji-api-deployment.yaml"

}

resource "local_file" "voteapi_deployment" {

  content = templatefile("${path.cwd}/templates/vote-api-deployment.yaml.tftpl", {
    voteapi_image = module.repository.vote_api
  })

  filename = "${path.cwd}/source/manifests/deployments/vote-api-deployment.yaml"

}

resource "local_file" "votebot_deployment" {

  content = templatefile("${path.cwd}/templates/vote-bot-deployment.yaml.tftpl", {
    votebot_image = module.repository.vote_bot
  })

  filename = "${path.cwd}/source/manifests/deployments/vote-bot-deployment.yaml"

}
