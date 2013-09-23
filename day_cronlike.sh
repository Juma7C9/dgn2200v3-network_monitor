#!/bin/sh

while true
do
	./print_graph_year.sh ./nas1.conf 2>&1 >> $logfile
	sleep 86400
done
