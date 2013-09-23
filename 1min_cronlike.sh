#!/bin/sh

while true
do
	./poll_stats.sh ./nas1.conf 2>&1 >> $logfile
	./print_graph_4hour.sh ./nas1.conf 2>&1 >> $logfile
	sleep 60
done
