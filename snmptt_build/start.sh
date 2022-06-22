!/bin/bash
/etc/rc.d/init.d/snmptt start
/usr/sbin/snmptrapd -n -C -c /etc/snmp/snmptrapd.conf -Lo -A -f
