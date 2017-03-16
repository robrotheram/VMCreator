#!/bin/bash
echo "Downloading images";

mkdir images; cd images;

echo "Downloading 14.04"
curl https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img -o trusty-server-cloudimg-amd64-disk1.img

echo "Downloading 16.04"
curl https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img -o xenial-server-cloudimg-amd64-disk1.img

echo "Downloading 16.10"
curl https://cloud-images.ubuntu.com/yakkety/current/yakkety-server-cloudimg-amd64.img     -o  yakkety-server-cloudimg-amd64.img
