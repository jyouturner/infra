# create some variables
variable "dns_base_domain" {
  type        = string
  description = "DNS Zone name to be used from EKS Ingress."
}
variable "ingress_gateway_chart_name" {
  type        = string
  description = "Ingress Gateway Helm chart name."
}
variable "ingress_gateway_chart_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
}
variable "ingress_gateway_chart_version" {
  type        = string
  description = "Ingress Gateway Helm chart version."
}
variable "ingress_gateway_annotations" {
  type        = map(string)
  description = "Ingress Gateway Annotations required for EKS."
}
variable "cert_arn" {
  type = string
  description = "arn of the cert"
}

# get (externally configured) DNS Zone
data "aws_route53_zone" "base_domain" {
  name = var.dns_base_domain
}


# deploy Ingress Controller
resource "helm_release" "ingress_gateway" {
  name       = var.ingress_gateway_chart_name
  chart      = var.ingress_gateway_chart_name
  repository = var.ingress_gateway_chart_repo
  version    = var.ingress_gateway_chart_version

  dynamic "set" {
    for_each = var.ingress_gateway_annotations

    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = var.cert_arn
  }
}

# create base domain for EKS Cluster
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/ingress
data "kubernetes_service" "ingress_gateway" {
  metadata {
    name = join("-", [helm_release.ingress_gateway.chart, helm_release.ingress_gateway.name])
  }

  depends_on = [module.eks-cluster]
}
data "aws_elb_hosted_zone_id" "elb_zone_id" {}

resource "aws_route53_record" "eks_domain" {
  zone_id = data.aws_route53_zone.base_domain.id
  name    = var.dns_base_domain
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_gateway.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}
