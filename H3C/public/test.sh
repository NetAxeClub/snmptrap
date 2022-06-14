!/bin/bash
for i in *.mib
do
/usr/bin/snmpttconvertmib --in=$i --out=/data/snmptrap/snmptt.conf.h3c_public --net_snmp_perl
done
