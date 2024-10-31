# Azure Kubernetes Service

Denne demoen bruker [avm-ptn-aks-production](https://registry.terraform.io/modules/Azure/avm-ptn-aks-production/azurerm/latest), samt støtte-moduler for nettverk og logging, fra [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) til å sette opp Kubernetes-clustre for både test og produksjon

## Kjente bugs og løsninger

1. `terraform apply` feiler i et tomt miljø. Dette skjer fordi `avm-ptn-aks-production` prøver å lese inn ressursgruppen som et data-objekt. Kan løses ved å kjøre `terraform apply -target azurerm_resource_group.this` manuelt første gang