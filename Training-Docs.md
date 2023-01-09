# Documentation for my Terraform Traning:

Terraform installation: link (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-cli)

Useful Terraform link: 	https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs

Note that for docker to images for be deploy through windows, **docker desktop** have to be downloaded

Information store in statefile should be kept as secrete as possible

terraform **jq** to see state file from cli.

OUTPUT: 

**grep** in Linux= **selest-string** in powershell

terraform console: use to access terraform console

useful links: terraform.io/docs/configuration/outputs.html

Count Argument:
count = 2

Splat (*) : https://developer.hashicorp.com/terraform/language/expressions#splat-expressions

For expressions: 

[for i in [1,2,3]: i+1] or  [for i in docker_container.nodered_container[*]: i.name] 


Tainting and updating resources
Tainting resources is a way to force and reply resources

syntax: terraform taint <resource string>

Terraform refresh

VARIABLES: https://developer.hashicorp.com/terraform/language/values/variables

variable "exp_port" {}