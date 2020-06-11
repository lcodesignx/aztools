#!/bin/bash

echo "Setting up variables"
# Set variables
RESOURCE_GROUP=learning-log-demo-rg
AZURE_REGION=eastus2
AZURE_APP_PLAN=learning-log-demo-$RANDOM
AZURE_WEB_APP=learning-log-web-app-$RANDOM

# Create resource group
az group create --name $RESOURCE_GROUP --location eastus2

# Pause and prompt for continuation
read -p "Press [Enter] key to continue..."

# Create App Service plan to run app
echo "Creating app service $AZURE_APP_PLAN"
az appservice plan create \
--name $AZURE_APP_PLAN \
--resource-group $RESOURCE_GROUP \
--location $AZURE_REGION \
--sku FREE

# Verify plan
az appservice plan list --output table

# Pause and prompt for continuation
read -p "Press [Enter] key to continue..."

# Create web app
echo "Creating webapp $AZURE_WEB_APP"
az webapp create \
--name $AZURE_WEB_APP \
--resource-group $RESOURCE_GROUP \
--plan $AZURE_APP_PLAN

# Verify web app
az webapp list --output table

# Pause and prompt for continuation
read -p "Press [Enter] key to continue..."

# Deploy code from GitHub (needs work)
echo "Deploying code from GitHub"
az webapp deployment source config \
--name $AZURE_WEB_APP \
--resource-group $RESOURCE_GROUP \
--repo-url "https://github.com/lcodesignx/learninglogs.git" \
--branch master --manual-integration
