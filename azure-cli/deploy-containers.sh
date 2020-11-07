#!/bin/bash

# declare known variables
NAMESPACE=argocd
WORKINGDIR=argocd
CLUSTER=cluster-sandbox
RESOURCEGROUP=aro-sandbox
KUBEADMINPASSWORD=$(az aro list-credentials   --name $CLUSTER   --resource-group $RESOURCEGROUP --query kubeadminPassword -o tsv)
KUBECONSOLEURL=$(az aro show --name $CLUSTER --resource-group $RESOURCEGROUP --query "consoleProfile.url" -o tsv)
KUBEADMINUSER=kubeadmin
apiServer=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query apiserverProfile.url -o tsv)


# do the stuff
# this is the sort of thing that can easily go in a pipeline I think

oc login $apiServer --username $KUBEADMINUSER --password $KUBEADMINPASSWORD 
oc create namespace $NAMESPACE

mkdir $WORKINGDIR
cd $WORKINGDIR
curl -o install.yaml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
oc apply --namespace $NAMESPACE --filename ./install.yaml


# Need to pause in here for awhile but unsure how long right
# now

# after pause is complete run the below commands

# ARGOCD_SERVER_PASSWORD=$(oc -n argocd get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')
# oc --namespace $NAMESPACE patch deployment argocd-server -p '{"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"argocd-server"}],"containers":[{"command":["argocd-server","--insecure","--staticassets","/shared/app"],"name":"argocd-server"}]}}}}'
# oc --namespace $NAMESPACE create route edge argocd-server --service=argocd-server --port=http --insecure-policy=Redirect

# New variables
# ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
# ARGOCD_ROUTE=$(oc --namespace $NAMESPACE get route argocd-server -o jsonpath='{.spec.host}')
# ARGOCD_SERVER_PASSWORD=$(oc --namespace $NAMESPACE get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')


# more commands
# curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-linux-amd64

# retrieve argocd web console
# echo https://$(oc get routes --namespace $NAMESPACE argocd-server -o=jsonpath='{ .spec.host }')
