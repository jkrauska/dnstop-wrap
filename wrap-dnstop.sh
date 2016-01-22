#!/bin/bash

workdir="${HOME}/dns-watcher"

stamp=`date "+%Y-%m-%d %H:%M:%S"`
hostname=`hostname -f`
emailto='myemail@sample.com'
duration='3550'
cd $workdir

# Run tshark for just about 1 hour (3600 seconds is one hour)
/usr/bin/tshark -a duration:${duration} -w dump.${stamp}.pcap -s 512 'udp dst port 53' > /dev/null 2> /dev/null

# Analyze the data
echo "<pre>" >  dnstop.report.${stamp}.txt
/usr/bin/dnstop -l 4 dump.${stamp}.pcap >> dnstop.report.${stamp}.txt

# Show the results
#cat dnstop.report.${stamp}.txt

# Email the results
cat dnstop.report.${stamp}.txt | mailx -s "DNSTOP ${stamp} ${hostname}" ${emailto}

# Zip up the data and results
gzip -9 dump.${stamp}.pcap dnstop.report.${stamp}.txt
