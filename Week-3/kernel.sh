#!/bin/bash


#print kernel version
echo "Kernel version: " $(uname -r)

echo ""
#print memory usage
echo "Total Memory usage: " 
free -h

echo ""

#print all running process
echo "All Running Process: "
ps aux

echo""

#print all installed packages
echo "Installed packages: "
apt list --installed
