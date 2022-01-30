# Задание 1. Яндекс.Облако (обязательное к выполнению)
Файлы дежат в директории [15.2](https://github.com/kiselev-it/devops/tree/main/task_15.2/15.2/)

terraform apply:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/1.PNG?raw=true)

Дашборд каталога:  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/2.PNG?raw=true)

1. Создал bucket Object Storage и разместил там файл с картинкой:

```
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
```

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/3.PNG?raw=true)

2. Создал группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:

```
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
```
bootstrap.sh:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><a href="https://storage.yandexcloud.net/test-bucket-kiselev/1.jpg" allign=center>https://storage.yandexcloud.net/test-bucket-kiselev/1.jpg</a><p allign=center><img src="https://storage.yandexcloud.net/test-bucket-kiselev/1.jpg"> </html>" > index.html
```
Виртуальные машины:
![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/4.PNG?raw=true)

3. Подключил группу к сетевому балансировщику:

```
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
```

Балансировзик с ip 62.84.118.201:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/5.PNG?raw=true)

Проверка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/6.PNG?raw=true)

Целевые группы:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/7.PNG?raw=true)

Сеть:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_15.2/png/8.PNG?raw=true)

Весь файд:

```
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

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
```