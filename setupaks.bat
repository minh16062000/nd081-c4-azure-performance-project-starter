@echo off
setlocal

REM Variables
set resourceGroup=acdnd-project
set clusterName=udacity-cluster

REM Install AKS CLI
echo Installing AKS CLI
az aks install-cli

echo AKS CLI installed

REM Create AKS cluster
echo Step 1 - Creating AKS cluster %clusterName%

REM Check if the user is in Cloud Lab or personal Azure account
REM For users working in their personal Azure account
REM Comment the following line if you are in the Cloud Lab
az aks create ^
    --resource-group %resourceGroup% ^
    --name %clusterName% ^
    --node-count 1 ^
    --enable-addons monitoring ^
    --generate-ssh-keys

REM Uncomment the following line for Cloud Lab users
REM az aks create ^
REM     --resource-group %resourceGroup% ^
REM     --name %clusterName% ^
REM     --node-count 1 ^
REM     --generate-ssh-keys

REM Uncomment the following line for Cloud Lab users to enable monitoring
REM az aks enable-addons -a monitoring -n %clusterName% -g %resourceGroup% --workspace-resource-id "/subscriptions/6c39f60b-2bb1-4e37-ad64-faaf30beaca4/resourcegroups/cloud-demo-153430/providers/microsoft.operationalinsights/workspaces/loganalytics-153430"

echo AKS cluster created: %clusterName%

REM Connect to AKS cluster
echo Step 2 - Getting AKS credentials

az aks get-credentials ^
    --resource-group %resourceGroup% ^
    --name %clusterName% ^
    --verbose

echo Verifying connection to %clusterName%
kubectl get nodes

REM Uncomment the following lines to deploy to AKS cluster
REM echo Deploying to AKS cluster
REM kubectl apply -f azure-vote.yaml

endlocal
