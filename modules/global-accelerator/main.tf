// create a global accelerator
resource "aws_globalaccelerator_accelerator" "main" {

  name = "production-dr-accelerator"

  enabled = true


  ip_address_type = "IPV4"

}
/// listener for the accelerator
resource "aws_globalaccelerator_listener" "https" {


accelerator_arn = aws_globalaccelerator_accelerator.main.id


protocol = "TCP"


port_range {

from_port = 443

to_port = 443

}


}
// Primary Endpoint Group
resource "aws_globalaccelerator_endpoint_group" "production" {


listener_arn = aws_globalaccelerator_listener.https.id



endpoint_group_region = "ap-south-1"



traffic_dial_percentage = 100



endpoint_configuration {


  endpoint_id = var.production_alb_arn


  weight = 100
}
health_check_protocol = "HTTPS"

health_check_port = 443

health_check_path = "/health"

}

// DR Endpoint Group

resource "aws_globalaccelerator_endpoint_group" "dr" {


listener_arn = aws_globalaccelerator_listener.https.id


endpoint_group_region = "ap-south-2"



traffic_dial_percentage = 0



endpoint_configuration {


endpoint_id = var.dr_alb_arn


weight = 100

}

health_check_protocol = "HTTPS"
health_check_port = 443
health_check_path = "/health"


}