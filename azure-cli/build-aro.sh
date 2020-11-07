#!/bin/bash

# This script will use the azure cli to stand up an ARO environment that will be used later on for some automated application deployments

# variables that don't have any dependencies
LOCATION=westus2
RESOURCEGROUP=aro-sandbox
CLUSTER=cluster-sandbox
VNET=aro-vnet
MASTER_SUBNET=master-subnet
WORKER_SUBNET=worker-subnet
KUBEADMINUSER=kubeadmin

# register some providers
az provider register --namespace Microsoft.RedHatOpenShift --wait
az provider register --namespace Microsoft.Compute --wait
az provider register --namespace Microsoft.Storage --wait

# Create stuff in Azure
az group create --name $RESOURCEGROUP --location $LOCATION
az network vnet create --resource-group $RESOURCEGROUP --name $VNET --address-prefixes 10.0.0.0/22
az network vnet subnet create --resource-group $RESOURCEGROUP --vnet-name $VNET --name $MASTER_SUBNET --address-prefixes 10.0.0.0/23 --service-endpoints Microsoft.ContainerRegistry
az network vnet subnet create --resource-group $RESOURCEGROUP --vnet-name $VNET --name $WORKER_SUBNET --address-prefixes 10.0.2.0/23 --service-endpoints Microsoft.ContainerRegistry
az network vnet subnet update --name $MASTER_SUBNET --resource-group $RESOURCEGROUP --vnet-name $VNET --disable-private-link-service-network-policies true
az aro create --resource-group $RESOURCEGROUP --name $CLUSTER --vnet $VNET --master-subnet $MASTER_SUBNET --worker-subnet $WORKER_SUBNET --pull-secret '{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2NnaV9ramVuc2VuMXNqdDZtdDBnbGJwbW1ocTEzemN5djhnZ25wOllZU1NPS0FMSlFHNlM4TFFBSzVEVFIzOEFXSlhPNDQ0UDNCV1FSNkdMRUtWNTVLNjM0MTZXRzU0UE5FM1BSUUg=","email":"kirk.jensen@cgi.com"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2NnaV9ramVuc2VuMXNqdDZtdDBnbGJwbW1ocTEzemN5djhnZ25wOllZU1NPS0FMSlFHNlM4TFFBSzVEVFIzOEFXSlhPNDQ0UDNCV1FSNkdMRUtWNTVLNjM0MTZXRzU0UE5FM1BSUUg=","email":"kirk.jensen@cgi.com"},"registry.connect.redhat.com":{"auth":"NTc0NTIxOXx1aGMtMVNKVDZNVDBnbGJQTW1IcTEzWkNZdjhnZ05QOmV5SmhiR2NpT2lKU1V6VXhNaUo5LmV5SnpkV0lpT2lJd04yVmtNbVF5TlRoaU5URTBaamt5WWprd1ltUmhabVE1TVRjNVkyUXdZeUo5LkUyVW85MjFjSmRsRHcwZkkwWW56VmVSSGllUGRsN0x2MjAzZldWeV8zQVlXOGZfTDNMNmpId0NCb2k2S19wVTFGZTJSdTJRYjZUWDl6dkRXZUhMd1hHSXFFN1NaRV9zR2dNY3lTRFdGUVo1OE1OZmdOZkQ0Qm0zY1gtdzRrcDZnOG5neGljOS14eGZwTG9lSFA0VkxzZFZaUlRwZFJ6ZmM1TTV4NEtSdlpiQzBPTE5fay1EQzd3RXdRR3hVaGw3TDFoX3FvSW1Db09nTW1UbmtuT1RKRmlzUEJrZ0pGa1RnMENNdTViUlYtaEhuVlVSYUk1RFVsS1ZtVXBHVXpXRmVIUV9Hb0JGVkdndmF1akpJZy1VZ2tzMVpBbmZKM00tSkM0WDBBX0l0N2NjbzRHWkZ1Q3VpQkprNlBZakVQRXB4eFd6ZkFkV3ZvRjczMXBQRHVpdDRjV1dFY1RKT3V3RzQyM2hELUROTXVQbjU1V0pNM01mZWNaRkE4a1lScDJiT0tvMVZQd2VGclF6M1ZZZE5qU0g2WVdOQmRCTXdHWTBNcWRTMWpYTGxKN2t6aWI2V3VOa184M19memNrV3pNQVFZaUtlWU9TRVFmQ2duaGZVeWF6SGpOUlRHcXBiOUtSS1dORjc1MEhFT1AxdC05Z3l4MWZzcHdIZzFlU2swRC1sRkRkTU90MFE4M0pLU3c3MzA4N0dNajhLdmlfb25uVGlPTjZqNWdnV0pnUTdKZDZxd1d2WDZKa1BHZDNEWVZWbWFUUVczQlNGWExMRS1qVm1OU1VWZXVQUXQ2SG15RjR0RERfMlI3Q1RTazljRlpuLTBIYjZRRmFFb0ZLTHhPcGV4a1R6M2Z5REtfQUt6a2szTnpnSWRJTXl2T2gwYTRrczc3ZHhLY01xRk04","email":"kirk.jensen@cgi.com"},"registry.redhat.io":{"auth":"NTc0NTIxOXx1aGMtMVNKVDZNVDBnbGJQTW1IcTEzWkNZdjhnZ05QOmV5SmhiR2NpT2lKU1V6VXhNaUo5LmV5SnpkV0lpT2lJd04yVmtNbVF5TlRoaU5URTBaamt5WWprd1ltUmhabVE1TVRjNVkyUXdZeUo5LkUyVW85MjFjSmRsRHcwZkkwWW56VmVSSGllUGRsN0x2MjAzZldWeV8zQVlXOGZfTDNMNmpId0NCb2k2S19wVTFGZTJSdTJRYjZUWDl6dkRXZUhMd1hHSXFFN1NaRV9zR2dNY3lTRFdGUVo1OE1OZmdOZkQ0Qm0zY1gtdzRrcDZnOG5neGljOS14eGZwTG9lSFA0VkxzZFZaUlRwZFJ6ZmM1TTV4NEtSdlpiQzBPTE5fay1EQzd3RXdRR3hVaGw3TDFoX3FvSW1Db09nTW1UbmtuT1RKRmlzUEJrZ0pGa1RnMENNdTViUlYtaEhuVlVSYUk1RFVsS1ZtVXBHVXpXRmVIUV9Hb0JGVkdndmF1akpJZy1VZ2tzMVpBbmZKM00tSkM0WDBBX0l0N2NjbzRHWkZ1Q3VpQkprNlBZakVQRXB4eFd6ZkFkV3ZvRjczMXBQRHVpdDRjV1dFY1RKT3V3RzQyM2hELUROTXVQbjU1V0pNM01mZWNaRkE4a1lScDJiT0tvMVZQd2VGclF6M1ZZZE5qU0g2WVdOQmRCTXdHWTBNcWRTMWpYTGxKN2t6aWI2V3VOa184M19memNrV3pNQVFZaUtlWU9TRVFmQ2duaGZVeWF6SGpOUlRHcXBiOUtSS1dORjc1MEhFT1AxdC05Z3l4MWZzcHdIZzFlU2swRC1sRkRkTU90MFE4M0pLU3c3MzA4N0dNajhLdmlfb25uVGlPTjZqNWdnV0pnUTdKZDZxd1d2WDZKa1BHZDNEWVZWbWFUUVczQlNGWExMRS1qVm1OU1VWZXVQUXQ2SG15RjR0RERfMlI3Q1RTazljRlpuLTBIYjZRRmFFb0ZLTHhPcGV4a1R6M2Z5REtfQUt6a2szTnpnSWRJTXl2T2gwYTRrczc3ZHhLY01xRk04","email":"kirk.jensen@cgi.com"}}}
'

# register more variables, these aren't known until now
KUBEADMINPASSWORD=$(az aro list-credentials   --name $CLUSTER   --resource-group $RESOURCEGROUP --query kubeadminPassword -o tsv)
KUBECONSOLEURL=$(az aro show --name $CLUSTER --resource-group $RESOURCEGROUP --query "consoleProfile.url" -o tsv)
apiServer=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query apiserverProfile.url -o tsv)
