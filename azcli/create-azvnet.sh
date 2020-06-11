#!/bin/zsh

# AZURE VIRTUAL NETWORK AUTOMATION SCRIPT

# Create Azure Resource Group
LOCATION="East US"
az group create --location $LOCATION --resource-group vm-networks