# Virtual Machine creater and Launcher

Small script to dynmically configure and create a Virtual Macheine from a cloud image and using cloud-init.
Being a Bash novice I am sure there are ways to improve the script but I like the basic readablitiy of it so I can easily edit it later down the road. 

## Dependacies

Standard KVM Libs
```
sudo apt-get install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker```
```
Cloud Libs needed 
```
sudo apt-get install cloud-utils
```

## using the script 
Downloads all the images
./getimages

Create a VM
if no cloud_init file is provided via the --user argument the script will autogenerate a pair of ssh key and a basic cloud init script
The Script also create a random mac address for you

./create
--host name for the vm 
--network set network interface eg br0
--version ubuntu version eg 14.04
--disk set Disk size e.g 8G
--cpu (optional) set vcpu defualt 1
--ram (optional) set ram for the vm default is 1024
--user (optional) specify a cloud init script. If not provided it will auto generate
