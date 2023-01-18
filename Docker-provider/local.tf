locals {
  deployment = {
    nodered = {
      cont_count     = length(var.exp_port["nodered"][terraform.workspace]) # needed TO CREATE A NUMBER OF CONTAINERS
      image          = var.image["nodered"][terraform.workspace]
      int            = 1880
      exp            = var.exp_port["nodered"][terraform.workspace]
      container_path = "/data"
      volumes = [
        { container_path_each = "/data" }
      ]
    }

    influxdb = {
      cont_count     = length(var.exp_port["influxdb"][terraform.workspace])
      image          = var.image["influxdb"][terraform.workspace]
      int            = 1886
      exp            = var.exp_port["influxdb"][terraform.workspace]
      #container_path = "/var/lib/influxdb" # gotten from docs
      volumes = [
        { container_path_each = "/var/lib/influxdb" }
     ]
    }
    # The 2 lines container_path_each, is use to create dynamic block, which makes it possible for us to 
    # to have 2 or more container volume path 
    grafana = {
      cont_count = length(var.exp_port["grafana"][terraform.workspace])
      image      = var.image["grafana"][terraform.workspace]
      int        = 3000
      exp        = var.exp_port["grafana"][terraform.workspace]
      #container_path = "/var/lib/grafana" # gotten from docs
      volumes = [
        { container_path_each = "/var/lib/grafana" },
        { container_path_each = "/etc/grafana" }
      ]

    }
  }
}
