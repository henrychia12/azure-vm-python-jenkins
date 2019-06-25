#!/bin/bash

# setting defaulted location
az configure --defaults location=uksouth

# create resource group
az group create --resource-group JenkinsResource

# create virtual network
az network vnet create --resource-group JenkinsResource --name JenkinsNetwork --address-prefixes 10.0.0.0/16

# create subnet
az network vnet subnet create --resource-group JenkinsResource --vnet-name JenkinsNetwork --address-prefixes 10.0.0.0/16 --name JenkinsSubnet --subnet-prefix 10.0.0.0/24

# create network security group
az network nsg create --resource-group JenkinsResource --name JenkinsNetworkSecurityGroup

# HTTP rule set on nsg
az network nsg rule create --resource-group JenkinsResource --name HTTP --priority 300 --nsg-name JenkinsNetworkSecurityGroup

# setting ssh rule on nsg
az network nsg rule create --resource-group JenkinsResource --name SSH --priority 200 --nsg-name JenkinsNetworkSecuirtyGroup --destination-port-ranges 22

# creating DNS and Static Public IP
az network public-ip create --resource-group JenkinsResource --name JenkinsPublicIP --dns-name henrychia12 --allocation-method Static

# creating Network Interface Name with nsg
az network nic create --resource-group JenkinsResource --name JenkinsNetworkInterface --vnet-name JenkinsNetwork --subnet JenkinsSubnet --network-security-group JenkinsNetworkSecurityGroup --public-ip-address JenkinsPublicIP

# create jenkins host virtual machine
az vm create --resource-group JenkinsResource --name JenkinsHostVM --IMAGE UbuntuLTS --nics JenkinsNetworkInterface 

# create jenkins slave virtual machine
az vm create --resource-group JenkinsResource --name JenkinsSlaveVM --IMAGE UbuntuLTS --nics JenkinsNetworkInterface

# create python server virtual machine
az vm create --resource-group JenkinsResource --name JenkinsPythonVM --IMAGE UbuntuLTS --nics JenkinsNetworkInterface

