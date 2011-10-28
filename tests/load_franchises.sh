#!/bin/bash

outfile=test_results_franchises.txt
echo "TEST RUN `date`">outfile
echo "testing the parsing of data from http://127.0.0.1:28017/bdb/franchises/" >>outfile
echo "cleaning up the /tmp dir....removing all *.rb files">>outfile
rm /tmp/*.rb


/usr/bin/ruby /home/rob/code/Generator/bin/generator -i url -url http://127.0.0.1:28017/bdb/franchises/ -l ruby -sod /tmp -mod /tmp >>$outfile 


ls -lt /tmp/*.rb >>outfile
echo "">>outfile

cat /tmp/*.rb >>outfile