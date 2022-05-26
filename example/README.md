# [Create a simple Azure VNET]

This example consists of a simple terraform deployment to create a simple Azure VNET.

- Terraform deployment: script `main.tf`

You can use the following table to make sure you are aware of all the ones you need:

## RUN

Then simply run it in local shell.

### Deploy

```sh
# set service principal
$ export ARM_CLIENT_ID="service-principal-client-id"
$ export ARM_CLIENT_SECRET="service-principal-client-secret"
$ export ARM_SUBSCRIPTION_ID="subscription-id"
$ export ARM_TENANT_ID="tenant-id"

$ terraform init
$ terraform plan -out=tfplan
$ terraform apply --auto-approve tfplan
```

### Destroy

```sh
# set service principal
$ export ARM_CLIENT_ID="service-principal-client-id"
$ export ARM_CLIENT_SECRET="service-principal-client-secret"
$ export ARM_SUBSCRIPTION_ID="subscription-id"
$ export ARM_TENANT_ID="tenant-id"

$ terraform init
$ terraform plan -destroy -out tfdestroy
$ terraform apply -input=false -auto-approve tfdestroy
