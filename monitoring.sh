#!/bin/bash
arc=$(uname -a)
p_cpu=$(nproc)
v_cpu=$(getconf _NPROCESSORS_ONLN)
mem_usage=$(free --mega | grep 'Mem' | awk '{printf("%d/%dMB(%.2f%%)", $3,$2, $3/$2 * 100)}')
usage_disk=$(df --total -BM | awk '/total/ {print $3}')
total_disk=$(df --total -h | awk '/total/ {print $2}')
p_disk=$(df --total | awk '/total/ {print $5}')
cpu_load=$(top -bn1 | grep '^%Cpu' | awk '{printf "%.1f%%", $2 + $4}')
last_boot=$(who -b | awk '{print $3, $4}')
lvm_use=$(lsblk | grep 'LVM' | wc -l | awk '{if($1>0) print "yes"; else print "no"}')
tcp=$(cat /proc/net/sockstat | grep 'TCP' | awk '{print $3}')
users=$(users | wc -l)
ipv4=$(hostname -I)
mac=$(ip link | grep 'link/ether' | awk '{print $2}')
sudo=$(cat /var/log/sudo/sudo.log | wc -l | tr '\n' ' ')
wall << EOF
	#Architecture: $arc
	#CPU physical: $p_cpu
	#vCPU: $v_cpu
	#Memory Usage:$mem_usage
	#Disk Usage: $usage_disk/$total_disk ($p_disk)
	#CPU load:$cpu_load
	#Last boot:$last_boot
	#LVM use:$lvm_use
	#Connections TCP:$tcp ESTABLISHED
	#User log:$users
	#Network:IP $ipv4($mac)
	#Sudo: $sudo cmd
EOF
