job "counter" {
  datacenters = ["dc1"]

  group "api" {
    count = 3

    network {
      mode = "bridge"
    }

    service {
      name = "count-api"
      port = "9001"

      connect {
        sidecar_service {}
      }
    }

    task "counter" {
      driver = "exec"

      config {
        command = "/vagrant/apps/bin/counter"
      }

      env {
        PORT = 9001
      }
    }
  }
}
