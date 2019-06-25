#!/bin/bash

# create resource group
az group create --resource-group JenkinsResource

# create virtual network
az network vnet create --resource-group JenkinsResource --name JenkinsNetwork --address-prefixes 10.0.0.0/16

# create subnet
az network vnet subnet create --resource-group JenkinsResource --vnet-name JenkinsNetwork --address-prefixes 10.0.0.0/16 --name JenkinsSubnet --subnet-prefix 10.0.0.0/24

# create network security group
az network nsg create --resource-group JenkinsResource --name JenkinsNetworkSecurityGroup

# setting ssh rule on nsg
az network nsg rule create --resource-group JenkinsResource --name ssh --priority 200 --nsg-name JenkinsNetworkSecuirtyGroup --destination-port-ranges 22


