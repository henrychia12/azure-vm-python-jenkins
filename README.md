# Azure Jenkins Python - VM
Azure cloud provider to host three different virtual machines - Jenkins Host, Jenkins Slave and Python Server.
## Usage
Git clone this repository to your local machine. Change to the newly cloned directory and run the required shell script.

Example
```bash
git clone https://github.com/henrychia12/azure-vm-python-jenkins.git
cd ~/azure-vm-python-jenkins/scripts
``` 
If azure cli has already been installed on your local machine then azure-cli-setup.sh is not required. 
```
./azure-cli-setup.sh
```
Execute vm-setup script to spin up the three different virtual machines:
```
./vm-setup.sh
```
Delete all three virtual machines:
```
./vm-delete.sh
```  
