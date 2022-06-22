!/bin/bash
for i in hh3c*
do
/usr/bin/snmpttconvertmib --in=$i --out=/data/snmptrap/snmptt.conf.h3c_new_style --net_snmp_perl
done

