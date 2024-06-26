resource "mongodbatlas_x509_authentication_database_user" "auth_db" {
  project_id        = mongodbatlas_project.project.id
  customer_x509_cas = tls_self_signed_cert.cert.cert_pem
}


resource "tls_private_key" "ca_certificate" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem   = tls_private_key.ca_certificate.private_key_pem
  is_ca_certificate = true
  subject {
    common_name  = var.project
    organization = "usxpress"
  }

  validity_period_hours = 87660

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "cert_signing"
  ]
}

resource "kubernetes_secret" "tls_secret" {
  metadata {
    name      = "tls-certificate-${var.project}"
    namespace = "cert-manager"
  }

  type = "kubernetes.io/tls"

  data = {
    "ca.crt"  = tls_self_signed_cert.cert.cert_pem,
    "tls.key" = tls_private_key.ca_certificate.private_key_pem,
    "tls.crt" = tls_self_signed_cert.cert.cert_pem
  }
}

resource "kubernetes_manifest" "clusterissuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = var.project
    }
    "spec" = {
      ca = {
        secretName = kubernetes_secret.tls_secret.metadata[0].name
      }
    }
  }
  depends_on = [kubernetes_secret.tls_secret]
}
