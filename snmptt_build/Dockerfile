FROM centos7:latest
MAINTAINER DevNet
# 切换国内阿里YUM源镜像
RUN set -ex \
 && yum install -y wget \
 && cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak \
 && wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
 && yum clean all \
 && yum makecache \
 && yum -y update \
 && yum clean all \
 && mkdir -p /var/lib/zabbix/snmptraps/


WORKDIR /var/lib/zabbix/snmptraps/

RUN set -ex \
    # 预安装所需组件 perl(SNMP) perl(XML::Simple)无法装
    && yum install -y epel-release tar logrotate readline-devel tk-devel gcc make initscripts  net-snmp-utils net-snmp-perl net-snmp perl-Sys-Syslog perl-DBD-MySQL \
    && yum install -y net-snmp-devel \
    && yum install -y net-tools* \
    && yum install -y perl-Net-SNMP \
    && yum install -y snmptt \
    && mkdir -p /var/lib/zabbix \
    && mkdir -p /var/lib/zabbix/snmptraps \
    && mkdir -p /var/lib/zabbix/mibs \
    && mkdir -p /usr/share/snmp/mibs/HUAWEI \
    && mkdir -p /usr/share/snmp/mibs/H3C \
    && touch /var/lib/net-snmp/snmptrapd.conf
    
# 基础环境配置
RUN set -ex \
    # 修改系统时区为东八区
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    # 安装定时任务组件
    && yum -y install cronie
# 支持中文
RUN yum install kde-l10n-Chinese -y
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

COPY HUAWEI /usr/share/snmp/mibs/HUAWEI
COPY H3C /usr/share/snmp/mibs/H3C

ENV MIBDIRS=/usr/share/snmp/mibs:/var/lib/zabbix/mibs:/usr/share/snmp/mibs/HUAWEI:/usr/share/snmp/mibs/H3C/new_style_private:/usr/share/snmp/mibs/H3C/public:MIBS=+ALL

#ENV MIBDIRS=/usr/share/snmp/mibs/HUAWEI:/usr/share/snmp/mibs/H3C/new_style_private:/usr/share/snmp/mibs/H3C/public:MIBS=+ALL
COPY ["snmptt.conf", "/etc/snmp/"]
COPY ["snmptt.ini", "/etc/snmp/"]
COPY ["snmp.conf", "/etc/snmp/"]
COPY ["snmptt-init.d", "/etc/rc.d/init.d/snmptt"]
RUN set -ex \
   && chmod +x /usr/sbin/snmptt \
   && chmod +x /usr/sbin/snmptthandler \
   && mkdir -p /var/log/snmptt/ \
   && more /etc/sysconfig/snmptrapd \
   && echo 'OPTIONS="-m +ALL -On"' >> /etc/sysconfig/snmptrapd.conf \
   && echo 'OPTIONS="-m +ALL -On"' >> /etc/sysconfig/snmptrapd \
   && echo 'OPTIONS="-m +ALL -On' >> /etc/rc.d/init.d/snmptrapd \
   && chkconfig --add snmptt \
   && chkconfig --level 2345 snmptt on

#   && sed -i "s/SELINUX=enforcing/mode = standalone/g" /etc/snmp/snmptt.conf
#   && sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/snmp/snmptt.conf

EXPOSE 162/UDP

WORKDIR /var/log/snmptt

VOLUME ["/var/log/snmptt"]

COPY ["conf/etc/logrotate.d/snmptt", "/etc/logrotate.d/"]
COPY ["conf/etc/snmp/snmptrapd.conf", "/etc/snmp/"]
COPY ["snmptt.conf.h3c_new_style", "/etc/snmp/"]
COPY ["snmptt.conf.h3c_public", "/etc/snmp/"]
COPY ["snmptt.conf.huawei", "/etc/snmp/"]
COPY ["start.sh", "/etc/snmp/"]

CMD ["sh", "/etc/snmp/start.sh"]
#CMD ["/usr/sbin/snmptrapd", "-n", "-C", "-c", "/etc/snmp/snmptrapd.conf", "-Lo", "-A", "-f"]
#CMD ["/usr/sbin/snmptrapd", "-On", "-n", "-C", "-c", "/etc/snmp/snmptrapd.conf", "-Lo", "-A"]
