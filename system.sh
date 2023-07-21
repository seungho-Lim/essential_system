#!/bin/bash

echo -e "\033[32m"System Info"\033[0m"

echo -e "\033[31m"CPU Information"\033[0m"
echo -n "Cpu ModelName :"
cat /proc/cpuinfo | grep "model name" | head -1 | awk -F ":" '{print $2}'

echo -n "Number of Cpu Core : "
grep -c processor /proc/cpuinfo

echo -e "\033[31m"Memory Information"\033[0m"
echo -n "Mermory ModelName : "
sudo dmidecode -t 17 | grep Part | grep -v "Not Specified" | awk '{ if (NR==1) print $3 }'

echo -n "Num of Memory : "
sudo dmidecode -t 17 | grep Part | grep -v "Not Specified" | grep -c Part

echo -n "Size of Memory : "
sudo dmidecode -t 17 | grep '[^ ]Size:' | grep -v "No Module" | awk '{sum+=$2;} END {print sum" "$3}'

echo -e "\033[31m"Disk Information"\033[0m"
A=$(sudo fdisk -l | grep "Disk" | awk '{ if ($2 == "model:") print NR-1 }')
B=($(echo $A | tr " " "\n"))
i=1
for e in ${B[*]}
do
	echo -e "\033[33m"Disk $i"\033[0m"
	i=`expr $i + 1`
	sudo fdisk -u -l | grep "Disk" | awk -F ":" -v c=$e '{ if ( c+1 == NR ) print "Disk ModelName :"$2}'
	sudo fdisk -u -l | grep "Disk" | awk -F "[ :,]" -v c=$e '{ if ( c == NR) print "Mounting Point : "$2"\nSize of Disk : "$4" "$5}'
done

