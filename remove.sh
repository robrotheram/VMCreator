#!/bin/bash

virsh destroy $1
virsh undefine $1
rm -rf cloud/$1

