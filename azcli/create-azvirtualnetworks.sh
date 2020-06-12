#!/bin/bash

# DESING AND IMPLEMENT IP ADDRESSING FOR AZURE VIRTUAL NETWORKS


# Create resource group
RESOURCE_GROUP="azvnetsubnet-demo-rg"
az group create --resource-group $RESOURCE_GROUP --location 'eastus2'

# Create virtual network for the CoreServicesVnet
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name CoreServicesVnet \
    --address-prefix 10.20.0.0/16 \
    --location westus

# Create the subnets for the CoreServicesVnet
az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name CoreServicesVnet \
    --name GatewaySubnet \
    --address-prefixes 10.20.0.0/27

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name CoreServicesVnet \
    --name SharedServicesSubnet \
    --address-prefixes 10.20.10.0/24

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name CoreServicesVnet \
    --name DatabaseSubnet \
    --address-prefixes 10.20.20.0/24

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name CoreServicesVnet \
    --name PublicWebServiceSubnet \
    --address-prefixes 10.20.30.0/24

# List all the subnets in the CoreServicesVnet network
az network vnet subnet list \
    --resource-group $RESOURCE_GROUP \
    --vnet-name CoreServicesVnet \
    --output table

# Create the ManufacturingVnet virtual network
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name ManufacturingVnet \
    --address-prefix 10.30.0.0/16 \
    --location northeurope

# Create the subnets for the ManufacturingVnet
az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ManufacturingVnet \
    --name ManufacturingSystemSubnet \
    --address-prefixes 10.30.10.0/24

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ManufacturingVnet \
    --name SensorSubnet1 \
    --address-prefixes 10.30.20.0/24

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ManufacturingVnet \
    --name SensorSubnet2 \
    --address-prefixes 10.30.21.0/24

az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ManufacturingVnet \
    --name SensorSubnet3 \
    --address-prefixes 10.30.22.0/24

# List all the subnets in the ManufacturingVnet network
az network vnet subnet list \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ManufacturingVnet \
    --output table

# Create the ResearchVnet virtual network
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name ResearchVnet \
    --address-prefix 10.40.40.0/24 \
    --location westindia

# Create the subnets for the ResearchVnet virtual network
az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ResearchVnet \
    --name ResearchSystemSubnet \
    --address-prefixes 10.40.40.0/24

# List all the subnets in the ResearchVnet virtual network
az network vnet subnet list \
    --resource-group $RESOURCE_GROUP \
    --vnet-name ResearchVnet \
    --output table


