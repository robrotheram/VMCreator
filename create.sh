#!/bin/bash
usage() { echo "Usage: $0 [--host servername] [--network < br0 | virb0 > ] [--version <14.04 | 16.04 | 16.10 >] [--disk 8G ] [--cores 2] [--ram]" 1>&2; exit 1; }

# Call getopt to validate the provided input.
options=$(getopt -o h --long host: -o v --long version: -o n --long network: -o d --long disk: -o r --long ram: -o c --long cpu: -o cld --long cloud: -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
CPU=1
RAM=1024

while true; do
    case "$1" in
    --host)
        shift; # The arg is next in position args
        HOST=$1
        ;;
    --network)
        shift; # The arg is next in position args
        NETWORK=$1
        ;;
    --version)
        shift; # The arg is next in position args
        VERSION=$1
        [[ ! $VERSION =~ 14.04|16.04|16.10 ]] && {
            usage
        }
        ;;
    --disk)
         shift;
	 DISK=$1
	 ;;
    --cpu)
         shift;
         CPU=$1
         ;;
    --ram)
         shift;
         RAM=$1
         ;;
    --cloud)
         shift;
         CLOUD_INT=$1
         ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ -z "$VERSION" ] || [ -z "$HOST" ] || [ -z "$NETWORK" ] || [ -z "$DISK" ]; then
    usage
fi

macadd="00:60:2f"$(hexdump -n3 -e '/1 ":%02X"' /dev/urandom)

case "$VERSION" in
	14.04)
	  IMG="trusty-server-cloudimg-amd64-disk1.img"
	  ;;
        16.04)
          IMG="xenial-server-cloudimg-amd64-disk1.img"
          ;;
        16.10)
          IMG="yakkety-server-cloudimg-amd64.img"
          ;;
         *)
	   usage
           ;;
esac

IMG="images/$IMG";
DISKIMG="$HOST.qcow2";
DISKIMG_PATH="cloud/$HOST/$DISKIMG"


echo "HOST is $HOST"
echo "VERSION is $VERSION"
echo "MAC is $macadd"
echo "IMG is $IMG"
echo "NETWORK is $NETWORK"
echo "DISK SIZE is $DISK"
echo "DISK IMG is $DISKIMG_PATH"
echo "RAM is $RAM"
echo "CPU is $CPU"
echo "Creating DISK IMAGE"

mkdir -p cloud/$HOST/config


if [ -z "$CLOUD_INT" ]; then

  ssh-keygen -b 2048 -t rsa -f cloud/$HOST/config/sshkey -q -N ""
  key=$(cat cloud/$HOST/config/sshkey.pub)

cat > cloud/$HOST/config/user_data << EOF
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    password: mypassword
    chpasswd: { expire: False }
    ssh_pwauth: True
    ssh-authorized-keys:
        - $key
  - touch /test.txt
EOF
cloud-localds cloud/$HOST/seed.img cloud/$HOST/config/user_data
else
cloud-localds cloud/$HOST/seed.img  $CLOUD_INT
fi

qemu-img convert -O qcow2 $IMG $DISKIMG_PATH
qemu-img resize $DISKIMG_PATH +$DISK

virt-install --vnc --noautoconsole --noreboot \
--name $HOST \
--ram $RAM \
--vcpu $CPU \
--disk path=$DISKIMG_PATH,format=qcow2 \
--cdrom cloud/$HOST/seed.img \
--boot=hd --livecd \
--bridge=$NETWORK -m $macadd

virsh start $HOST

case "$NETWORK" in
        br0)
	   echo "Giving time for the network to stabilize"
           sleep 10
	   echo "Querying Network"
           while [ -z "$HOST_IP" ]; do
		echo "Waiting ..."
                fping -a -q -g 192.168.0.0/24 > /dev/null 2>&1;
		HOST_IP=$(arp  | grep -i $macadd | awk '{print $1}');
		sleep 2;
	   done
          ;;
        virbr0)
          echo "Querying Network"
          while [ -z "$HOST_IP" ]; do
                echo "Waiting ..."
	  	HOST_IP=$(virsh net-dhcp-leases --network default | grep -i $macadd | awk '{print $5}');
	        sleep 2;
	  done
	  HOST_IP=${HOST_IP::-3}
          ;;
esac

echo "Host: $HOST | mac: $macadd | IP: $HOST_IP"

exit 0;
