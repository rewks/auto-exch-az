# Overview

This Terraform script has a simple purpose: to create a small lab environment in Azure where a user can test attacks against an up to date, publicly exposed Exchange server that is joined to a domain. To facilitate this it creates two servers, one acting as a Domain Controller and one as the Exchange server. All other components such as resource groups, security groups etc are also set up as required.

## Usage

Before using the script, you need to install the following:

1. Terraform
2. The Azure CLI

Also make sure you are authenticated to Azure through the Azure CLI using `az login`

Once the above requirements are met, clone this repo and run the following commands:

```
terraform init
terraform apply
```

You will be asked for some input to customise the lab (passwords for accounts). The deployment plan will be presented and you will need to confirm it to commence the deployment. After you have finished testing simply run the following command to delete all the resources that were created:

```
terraform destroy
```