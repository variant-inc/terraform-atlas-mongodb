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

resource "aws_secretsmanager_secret" "secret" {
  #checkov:skip=CKV2_AWS_57:Ensure Secrets Manager secrets should have automatic rotation enabled
  name       = "${var.project}-${var.name}"
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(
    {
      "ca.crt"  = tls_self_signed_cert.cert.cert_pem
      "tls.key" = tls_private_key.ca_certificate.private_key_pem
      "tls.crt" = tls_self_signed_cert.cert.cert_pem
    }
  )
}
