terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}

provider "postgresql" {
  host     = "${kubernetes_service.postgres.metadata[0].name}.${kubernetes_service.postgres.metadata[0].namespace}.svc.cluster.local"
  port     = 5432
  username = "postgres"
  password = random_password.password.result
  sslmode = "disable"
}

variable "context" {
  description = "This variable contains Radius recipe context."
  type = any
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.context.runtime.kubernetes.namespace
  }

  spec {
    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image = "ghcr.io/radius-project/mirror/postgres:latest"
          name  = "postgres"

          env {
            name  = "POSTGRES_PASSWORD"
            value = random_password.password.result
          }

          port {
            container_port = 5432
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.context.runtime.kubernetes.namespace
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "time_sleep" "wait_180_seconds" {
  depends_on = [kubernetes_service.postgres]
  create_duration = "180s"
}

resource postgresql_database "postgres_db_test" {
  provider = postgresql
  depends_on = [time_sleep.wait_180_seconds]
  name = "postgres_db_test"
}

output "result" {
  value = {
    values = {
      host = "${kubernetes_service.postgres.metadata[0].name}.${kubernetes_service.postgres.metadata[0].namespace}.svc.cluster.local"
      port = "5432"
      database = "postgres_db_test"
      username = "postgres"
      password = "${random_password.password.result}"
    }
  }
}