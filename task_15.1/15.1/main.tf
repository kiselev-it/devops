provider "yandex" {
  zone      = "ru-central1-a"
}

// ============Network Start=============
resource "yandex_vpc_network" "vpc-network" {
  name = "netology"
}
resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"] 
  zone      = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-network.id
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"] 
  zone      = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc-network.id
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_route_table" "rt" {
  network_id = "${yandex_vpc_network.vpc-network.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}
// ============Network End=============
// ============Instance Start =============
resource "yandex_compute_instance" "public" {
  name        = "public"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd89ka9p6idl8htbmhok"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public-subnet.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "private" {
  name        = "private"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd89ka9p6idl8htbmhok"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private-subnet.id}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.public-subnet.id}"
    ip_address = "192.168.10.254"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
// ============Instance End =============