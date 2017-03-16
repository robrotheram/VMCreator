#Virtual Machine creater and Launcher

Small script to dynmically configure and create a Virtual Macheine from a cloud image and using cloud-init

#Dependacies

Standard KVM Libs
```
sudo apt-get install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker```
```
Lib 
```
sudo apt-get install cloud-utils
```

##  
Downloads all the images
./getimages


./create
--host name for the vm 
--network set network interface eg br0
--version ubuntu version eg 14.04
--disk set Disk size e.g 8G
--cpu (optional) set vcpu defualt 1
--ram (optional) set ram for the vm default is 1024
--user (optional) specify a cloud init script. If not provided it will auto generate
