job "dashboard" {
  datacenters = ["dc1"]

  group "dashboard" {
    network {
      mode = "bridge"

      port "http" {
        to     = 9002
      }
    }

    service {
      name = "count-dashboard"
      port = 9002

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "dashboard" {
      driver = "exec"

      config {
        command = "/vagrant/apps/bin/dashboard"
      }

      env {
        PORT = "${NOMAD_PORT_http}"
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }
    }
  }
}