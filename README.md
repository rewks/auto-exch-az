**Work In Progress**: Exchange installation is not yet implemented..

# Overview

This Terraform script has a simple purpose: to create a small lab environment in Azure where a user can test attacks against an up to date, publicly exposed Exchange server that is joined to a domain. To facilitate this it creates two servers, one acting as a Domain Controller and one as the Exchange server. All other components such as resource groups, security groups etc are also set up as required.

## Usage

Before using the script, you need to install the following:

1. Terraform
2. The Azure CLI

Also make sure you are authenticated to Azure through the Azure CLI using `az login`. You may need to specify the tenant ID as well e.g. `az login --tenant 9ae1b9b3-28c5-41a2-f5a4-7ba4bcddfb6a`

Once the above requirements are met, clone this repo and run the following commands:

```
terraform init
terraform apply
```

Customisation of stuff like internal IPs and hostnames can be done by creating a terraform.tfvars file (or just editing the default values in variables.tf). The deployment plan will be presented and you will need to confirm it to commence the deployment. After you have finished testing simply run the following command to delete all the resources that were created:

```
terraform destroy
```

After deployment has completed (which can take roughly 10 minutes), the public IPs of the machines and the Domain Admin username and password will be outputted.
