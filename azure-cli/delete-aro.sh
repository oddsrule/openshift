#!/bin/bash

# This script will use the azure cli to delete an ARO environment to avoid using all my azure credits

# variables that don't have any dependencies

RESOURCEGROUP=aro-sandbox
CLUSTER=cluster-sandbox

az aro delete --resource-group $RESOURCEGROUP --name $CLUSTER --yes
az group delete --name $RESOURCEGROUP --yes

cd ~/Documents/azure/sandbox
rm -rf argocd
