#!/bin/bash

#Luke Doherty

#trap "rm -f system_metrics.csv apm*_metrics.csv" EXIT


spawn_processes () {	#This function spawns the necessary processes
/home/student/project1/project1_executables/APM1 192.168.203.116 &
/home/student/project1/project1_executables/APM2 192.168.203.116 &
/home/student/project1/project1_executables/APM3 192.168.203.116 &
/home/student/project1/project1_executables/APM4 192.168.203.116 &
/home/student/project1/project1_executables/APM5 192.168.203.116 &
/home/student/project1/project1_executables/APM6 192.168.203.116 &
}

monitor_metrics(){	#This function monitors and captures the metrics
rm -f system_metrics.csv  apm*_metrics.csv	#Delete the previous metrics files

while [[ $run -ge $SECONDS ]]
do
	
	#SYSTEM LEVEL METRICS LOOP:
	for((i = 0 ; i <= 4 ; i++))
	do
		currentSeconds=$SECONDS
		ifstat | grep ens192 > netstats.txt
		df | grep /dev/mapper/centos-root > util.txt
		iostat | grep sda > kbs.txt

		rx=$(awk -F " " '{print $7}' netstats.txt)
		tx=$(awk -F " " '{print $9}' netstats.txt)
		kbs=$(awk -F " " '{print $4}' kbs.txt)
		util=$(($(awk -F " " '{print $4}' util.txt) / 1024 + 1))

		echo "$currentSeconds,"$rx","$tx","$kbs","$util >> system_metrics.csv
		sleep 1
	done

	#PROCESS LEVEL METRICS:
	ps aux | grep /home/student/project1/project1_executables/APM1 > apm1.txt
	ps aux | grep /home/student/project1/project1_executables/APM2 > apm2.txt
	ps aux | grep /home/student/project1/project1_executables/APM3 > apm3.txt
	ps aux | grep /home/student/project1/project1_executables/APM4 > apm4.txt
        ps aux | grep /home/student/project1/project1_executables/APM5 > apm5.txt
        ps aux | grep /home/student/project1/project1_executables/APM6 > apm6.txt

	cpu1=$(awk -F " " 'NR==1{print $3}' apm1.txt)
	mem1=$(awk -F " " 'NR==1{print $4}' apm1.txt)

	cpu2=$(awk -F " " 'NR==1{print $3}' apm2.txt)
	mem2=$(awk -F " " 'NR==1{print $4}' apm2.txt)

	cpu3=$(awk -F " " 'NR==1{print $3}' apm3.txt)
	mem3=$(awk -F " " 'NR==1{print $4}' apm3.txt)

	cpu4=$(awk -F " " 'NR==1{print $3}' apm4.txt)
        mem4=$(awk -F " " 'NR==1{print $4}' apm4.txt)

        cpu5=$(awk -F " " 'NR==1{print $3}' apm5.txt)
        mem5=$(awk -F " " 'NR==1{print $4}' apm5.txt)

        cpu6=$(awk -F " " 'NR==1{print $3}' apm6.txt)
        mem6=$(awk -F " " 'NR==1{print $4}' apm6.txt)

	echo $currentSeconds","$cpu1","$mem1 >> apm1_metrics.csv
	echo $currentSeconds","$cpu2","$mem2 >> apm2_metrics.csv
	echo $currentSeconds","$cpu3","$mem3 >> apm3_metrics.csv
	echo $currentSeconds","$cpu4","$mem4 >> apm4_metrics.csv
	echo $currentSeconds","$cpu5","$mem5 >> apm5_metrics.csv
	echo $currentSeconds","$cpu6","$mem6 >> apm6_metrics.csv
	 
done
}

cleanup(){	#This function terminates the running processes
killall APM1
killall APM2
killall APM3
killall APM4
killall APM5
killall APM6
}

#**************************MAIN************************

run=$1
spawn_processes
monitor_metrics
cleanup
