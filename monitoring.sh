#!/bin/bash

arc=$(uname -a)
p_cpu=$(nproc)
v_cpu=$(getconf _NPROCESSORS_ONLN)
usage_ram=$(free -m | awk '/Mem/ {print $3}')
total_ram=$(free -m | awk '/Mem/ {print $2}')
p_ram=$(free | awk '/Mem/ {printf("%.2f", $3/$2*100)}')
usage_disk=$(df --total -BM | awk '/total/ {print $3}')
total_disk=$(df --total -h | awk '/total/ {print $2}')
p_disk=$(df --total | awk '/total/ {print $5}')
last_boot_day=$(who -b | awk '{print $3}')
last_boot_time=$(who -b | awk '{print $4}')
lv_count=$(vgdisplay | awk '/Open LV/ {print $3}')
lv_status=$(if [ $lv_count -eq 0 ]; then echo no; else echo yes; fi)
users_log=$(users | wc -w)
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
ip=$(hostname -I)
ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall << EOF
	#Architecture : $arc
	#CPU physical : $p_cpu
	#vCPU : $v_cpu
	#Memory Usage : $usage_ram/${total_ram}MB ($p_ram%)
	#Disk Usage : $usage_disk/$total_disk ($p_disk)
	#CPU load : $cpu_load
	#Last boot : $last_boot_day $last_boot_time
	#LVM use : $lv_status
	#Connections TCP : $ctcp ESTABLISHED
	#User log : $users_log
	#Network : IP $ip ($mac)
	#Sudo: $cmds cmd
EOF
