locals {
  folder_id = "b1gmiji6f1gq4fsjrn5o"
}

provider "yandex" {
  folder_id = local.folder_id
  zone      = "ru-central1-a"
}
// ============Storage object Start =============

resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "netology-1"
}

resource "yandex_resourcemanager_folder_iam_binding" "admin" {
  folder_id = local.folder_id
  role      = "admin"
  members   = [
    "serviceAccount:${yandex_iam_service_account.sa.id}",
  ]
}
// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}
resource "yandex_storage_bucket" "test-bucket-kiselev" {
  bucket = "test-bucket-kiselev"
  access_key = yandex_iam_service_account_static_access_key.key.access_key
  secret_key = yandex_iam_service_account_static_access_key.key.secret_key
  acl        = "public-read"
}

resource "yandex_storage_object" "image" {
  bucket = "test-bucket-kiselev"
  acl    = "public-read"
  key    = "1.jpg"
  source = "~/15.2/1.jpg"
  access_key = yandex_iam_service_account_static_access_key.key.access_key
  secret_key = yandex_iam_service_account_static_access_key.key.secret_key
}

// ============Storage object End =============

// ============Network Start=============

resource "yandex_vpc_network" "vpc-network" {
  name = "lamp-vpc"
}
resource "yandex_vpc_subnet" "public-subnet1" {
  name           = "public-subnet1"
  v4_cidr_blocks = ["192.168.10.0/24"] 
  zone      = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-network.id
}
resource "yandex_vpc_subnet" "public-subnet2" {
  name           = "public-subnet2"
  v4_cidr_blocks = ["192.168.20.0/24"] 
  zone      = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc-network.id
}
resource "yandex_vpc_subnet" "public-subnet3" {
  name           = "public-subnet3"
  v4_cidr_blocks = ["192.168.30.0/24"] 
  zone      = "ru-central1-c"
  network_id     = yandex_vpc_network.vpc-network.id
}
// ============Network End=============

// ============instance_group Start =============
resource "yandex_compute_instance_group" "group1" {
  name                = "lamp-group"
  folder_id           = local.folder_id
  service_account_id  = "${yandex_iam_service_account.sa.id}"
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 4
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 13
      }
    }
    scheduling_policy {
      preemptible = true
    }    
    network_interface {
      network_id = "${yandex_vpc_network.vpc-network.id}"
      subnet_ids = [yandex_vpc_subnet.public-subnet1.id, yandex_vpc_subnet.public-subnet2.id, yandex_vpc_subnet.public-subnet3.id]
    }

    metadata = {
      user-data = file("~/15.2/bootstrap.sh")
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
  health_check {
    interval = 10
    timeout = 2
    tcp_options {
      port = 80
    }
  }
  load_balancer {
    target_group_name = "load-balancer-group"
  }
}

// ============instance_group End =============

// ============Load Balancer Start =============

resource "yandex_lb_network_load_balancer" "lb" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.group1.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
// ============Load Balancer End =============