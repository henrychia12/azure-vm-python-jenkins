#/bin/bash

# setting defaulted location
az configure --defaults location=uksouth

# create resource group
az group create --resource-group JenkinsResource

# create virtual network and subnet
az network vnet create --resource-group JenkinsResource --name JenkinsNetwork --address-prefixes 10.0.0.0/16 --subnet-name JenkinsSubnet --subnet-prefix 10.0.0.0/24

# create network security group
az network nsg create --resource-group JenkinsResource --name JenkinsHostNetworkSecurityGroup
az network nsg create --resource-group JenkinsResource --name JenkinsSlaveNetworkSecurityGroup
az network nsg create --resource-group JenkinsResource --name PythonServerNetworkSecurityGroup

# jenkins host NSG rules
az network nsg rule create --resource-group JenkinsResource --name SSH --priority 100 --nsg-name JenkinsHostNetworkSecurityGroup --destination-port-ranges 22
az network nsg rule create --resource-group JenkinsResource --name Jenkins --priority 200 --nsg-name JenkinsHostNetworkSecurityGroup --destination-port-ranges 8080

# jenkins slave NSG rules
az network nsg rule create --resource-group JenkinsResource --name SSH --priority 100 --nsg-name JenkinsSlaveNetworkSecurityGroup --destination-port-ranges 22

# python server NSG rules
az network nsg rule create --resource-group JenkinsResource --name SSH --priority 100 --nsg-name PythonServerNetworkSecurityGroup --destination-port-ranges 22
az network nsg rule create --resource-group JenkinsResource --name PythonServer --priority 200 --nsg-name PythonServerNetworkSecurityGroup --destination-port-ranges 3000

# creating DNS and Static Public IP
az network public-ip create --resource-group JenkinsResource --name JenkinsHostPublicIP --dns-name henrychia11 --allocation-method Static
az network public-ip create --resource-group JenkinsResource --name JenkinsSlavePublicIP --dns-name henrychia12 --allocation-method Static
az network public-ip create --resource-group JenkinsResource --name PythonServerPublicIP --dns-name henrychia13 --allocation-method Static

# creating Network Interface Name with nsg
az network nic create --resource-group JenkinsResource --name JenkinsHostNetworkInterface --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group JenkinsHostNetworkSecurityGroup --public-ip-address JenkinsHostPublicIP
az network nic create --resource-group JenkinsResource --name JenkinsSlaveNetworkInterface --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group JenkinsSlaveNetworkSecurityGroup --public-ip-address JenkinsSlavePublicIP
az network nic create --resource-group JenkinsResource --name PythonServerNetworkInterface --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group PythonServerNetworkSecurityGroup --public-ip-address PythonServerPublicIP

# create jenkins host virtual machine
az vm create --resource-group JenkinsResource --name JenkinsHostVM --image UbuntuLTS --nics JenkinsHostNetworkInterface --size Standard_B1ms --generate-ssh-keys

# create jenkins slave virtual machine
az vm create --resource-group JenkinsResource --name JenkinsSlaveVM --image UbuntuLTS --nics JenkinsSlaveNetworkInterface --size Standard_B1ms --generate-ssh-keys

# create python server virtual machine
az vm create --resource-group JenkinsResource --name JenkinsPythonVM --image UbuntuLTS --nics PythonServerNetworkInterface --size Standard_B1ms --generate-ssh-keys

