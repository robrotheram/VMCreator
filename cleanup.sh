#!/bin/bash

echo "Clean up in progress !"

echo "Shutting down all vm !"
for x in `virsh list | awk '{print $2}' `; do 
virsh destroy $x 2>/dev/null;
done

echo "Now removeing them !"
for x in `virsh list --all | awk '{print $2}' `; do
virsh undefine $x 2>/dev/null;
done

echo "Remove old files"
rm -rf cloud/*
