#/bin/bash

# setting defaulted location
az configure --defaults location=uksouth

# create resource group
az group create --resource-group JenkinsResource

# create virtual network and subnet
az network vnet create --resource-group JenkinsResource --name JenkinsNetwork --address-prefixes 10.0.0.0/16 --subnet-name JenkinsSubnet --subnet-prefix 10.0.0.0/24

# create network security group
az network nsg create --resource-group JenkinsResource --name JenkinsNetworkSecurityGroup

# HTTP rule set on nsg
az network nsg rule create --resource-group JenkinsResource --name HTTP --priority 300 --nsg-name JenkinsNetworkSecurityGroup

# setting ssh rule on nsg
az network nsg rule create --resource-group JenkinsResource --name SSH --priority 100 --nsg-name JenkinsNetworkSecurityGroup --destination-port-ranges 22

# creating DNS and Static Public IP
az network public-ip create --resource-group JenkinsResource --name JenkinsPublicIPOne --dns-name henrychia11 --allocation-method Static
az network public-ip create --resource-group JenkinsResource --name JenkinsPublicIPTwo --dns-name henrychia12 --allocation-method Static
az network public-ip create --resource-group JenkinsResource --name JenkinsPublicIPThree --dns-name henrychia13 --allocation-method Static

# creating Network Interface Name with nsg
az network nic create --resource-group JenkinsResource --name JenkinsNetworkInterfaceOne --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group JenkinsNetworkSecurityGroup --public-ip-address JenkinsPublicIPOne
az network nic create --resource-group JenkinsResource --name JenkinsNetworkInterfaceTwo --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group JenkinsNetworkSecurityGroup --public-ip-address JenkinsPublicIPTwo
az network nic create --resource-group JenkinsResource --name JenkinsNetworkInterfaceThree --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group JenkinsNetworkSecurityGroup --public-ip-address JenkinsPublicIPThree

# create jenkins host virtual machine
az vm create --resource-group JenkinsResource --name JenkinsHostVM --image UbuntuLTS --nics JenkinsNetworkInterfaceOne --size Standard_B1ls 

# create jenkins slave virtual machine
az vm create --resource-group JenkinsResource --name JenkinsSlaveVM --image UbuntuLTS --nics JenkinsNetworkInterfaceTwo --size Standard_B1ls

# create python server virtual machine
az vm create --resource-group JenkinsResource --name JenkinsPythonVM --image UbuntuLTS --nics JenkinsNetworkInterfaceThree --size Standard_B1ls

