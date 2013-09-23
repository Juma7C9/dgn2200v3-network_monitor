#!/bin/sh

while true
do
	./print_graph_daily.sh ./nas1.conf 2>&1 >> $logfile
	sleep 300
done
