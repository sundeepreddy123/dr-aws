module "route53" {

  source = "../../modules/route53"

  hosted_zone_id = data.aws_route53_zone.main.zone_id

  records = {

    shop = {

      name = "shop.example.com"

      type = "A"

      alias = {

        name = module.global_accelerator.dns_name

        zone_id = module.global_accelerator.hosted_zone_id

        evaluate_target_health = false

      }
    }

    api = {

      name = "api.example.com"

      type = "A"

      alias = {

        name = module.global_accelerator.dns_name

        zone_id = module.global_accelerator.hosted_zone_id

        evaluate_target_health = false

      }
    }

    auth = {

      name = "auth.example.com"

      type = "A"

      alias = {

        name = module.global_accelerator.dns_name

        zone_id = module.global_accelerator.hosted_zone_id

        evaluate_target_health = false

      }
    }

    grafana = {

      name = "grafana.example.com"

      type = "A"

      alias = {

        name = module.monitoring_alb.lb_dns_name

        zone_id = module.monitoring_alb.lb_zone_id

        evaluate_target_health = true

      }
    }

    argocd = {

      name = "argocd.example.com"

      type = "A"

      alias = {

        name = module.management_alb.lb_dns_name

        zone_id = module.management_alb.lb_zone_id

        evaluate_target_health = true

      }
    }

  }

}