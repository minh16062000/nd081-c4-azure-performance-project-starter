@REM #!/bin/bash

@REM # Variables
@REM resourceGroup="acdnd-project"
@REM location="eastasia"
@REM osType="Ubuntu2204"
@REM vmssName="udacity-vmss"
@REM adminName="udacityadmin"
@REM storageAccount="udacitydiag$RANDOM"
@REM bePoolName="udacity-vmss-bepool"
@REM lbName="udacity-vmss-lb"
@REM lbRule="udacity-vmss-lb-network-rule"
@REM nsgName="udacity-vmss-nsg"
@REM vnetName="udacity-vmss-vnet"
@REM subnetName="udacity-vmss-vnet-subnet"
@REM probeName="tcpProbe"
@REM vmSize="Standard_B1s"
@REM storageType="Standard_LRS"

@REM # Create resource group. 
@REM # This command will not work for the Cloud Lab users. 
@REM # Cloud Lab users can comment this command and 
@REM # use the existing Resource group name, such as, resourceGroup="cloud-demo-153430" 
echo "STEP 0 - Creating resource group acdnd-project..."

az group create --name acdnd-project --location eastasia --verbose

echo "Resource group created: acdnd-project"

@REM # Create Storage account
echo "STEP 1 - Creating storage account udacitydiag111"

az storage account create --name udacitydiag111 --resource-group acdnd-project --location eastasia --sku Standard_LRS

echo "Storage account created: udacitydiag111"

@REM # Create Network Security Group
echo "STEP 2 - Creating network security group udacity-vmss-nsg"

az network nsg create --resource-group acdnd-project --name udacity-vmss-nsg --verbose

echo "Network security group created: udacity-vmss-nsg"

@REM # Create VM Scale Set
echo "STEP 3 - Creating VM scale set udacity-vmss"

az vmss create --resource-group acdnd-project --name udacity-vmss --image Ubuntu2204 --vm-sku Standard_B1s --nsg udacity-vmss-nsg --subnet udacity-vmss-vnet-subnet --vnet-name udacity-vmss-vnet --backend-pool-name udacity-vmss-bepool --storage-sku Standard_LRS --load-balancer udacity-vmss-lb --custom-data cloud-init.txt --upgrade-policy-mode automatic --admin-username udacityadmin --generate-ssh-keys --verbose 

echo "VM scale set created: udacity-vmss"

@REM # Associate NSG with VMSS subnet
echo "STEP 4 - Associating NSG: udacity-vmss-nsg with subnet: udacity-vmss-vnet-subnet"

az network vnet subnet update --resource-group acdnd-project --name udacity-vmss-vnet-subnet --vnet-name udacity-vmss-vnet --network-security-group udacity-vmss-nsg --verbose

echo "NSG: udacity-vmss-nsg associated with subnet: udacity-vmss-vnet-subnet"

@REM # Create Health Probe
echo "STEP 5 - Creating health probe tcpProbe"

az network lb probe create --resource-group acdnd-project --lb-name udacity-vmss-lb --name tcpProbe --protocol tcp --port 80 --interval 5 --threshold 2 --verbose

echo "Health probe created: tcpProbe"

@REM # Create Network Load Balancer Rule
echo "STEP 6 - Creating network load balancer rule udacity-vmss-lb-network-rule"

az network lb rule create --resource-group acdnd-project --name udacity-vmss-lb-network-rule --lb-name udacity-vmss-lb --probe-name tcpProbe --backend-pool-name udacity-vmss-bepool --backend-port 80 --frontend-ip-name loadBalancerFrontEnd --frontend-port 80 --protocol tcp --verbose

echo "Network load balancer rule created: udacity-vmss-lb-network-rule"

@REM # Add port 80 to inbound rule NSG
echo "STEP 7 - Adding port 80 to NSG udacity-vmss-nsg"

az network nsg rule create --resource-group acdnd-project --nsg-name udacity-vmss-nsg --name Port_80 --destination-port-ranges 80 --direction Inbound --priority 100 --verbose

echo "Port 80 added to NSG: udacity-vmss-nsg"

@REM # Add port 22 to inbound rule NSG
echo "STEP 8 - Adding port 22 to NSG udacity-vmss-nsg"

az network nsg rule create --resource-group acdnd-project --nsg-name udacity-vmss-nsg --name Port_22 --destination-port-ranges 22 --direction Inbound --priority 110 --verbose

echo "Port 22 added to NSG: udacity-vmss-nsg"

echo "VMSS script completed!"
