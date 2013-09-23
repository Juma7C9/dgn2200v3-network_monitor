#!/bin/sh

while true
do
	./print_graph_month.sh ./nas1.conf 2>&1 >> $logfile
	sleep 7200
done
