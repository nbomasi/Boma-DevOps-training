# Needed to hide some sensitive information

exp_port = {
  nodered = {
    #dev = [1980, 1981]
    #prod = [1880,1970]
    dev  = [1980]
    prod = [1880]
  }

  influxdb = {
    dev  = [8186]
    prod = [8086]
  }

  grafana = {
    dev  = [3001, 3003]
    prod = [3002]
  }
}
##exp_port = [1880, 1881, 1882]