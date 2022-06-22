## snmptrap日志收集器
1. 这是一个将snmptt功能封装进docker的项目，主要用于网络设备snmptrap信息采集。
2. 本示例已经包含国内华三和华为的常用mib节点解析功能。
3. 由于snmptt对于采集到的数据，并没有更优的上报方式，本示例采用的是snmptt自带的存入mysql的方式。
4. 存入mysql将会引入新的问题，例如如何进行消息订阅，且网络设备规模上来以后，其数据量也将是非常庞大，单靠SQL查询已经不是最优解。
5. 后期我们借助阿里开源的canal组件，并搭建kafka集群，通过cancal去同步mysql数据，并将同步到的数据存入kafka队列中
6. 最后，大家只需要在各自的业务逻辑代码中，通过python 的kafka插件，去消费队列中的trap数据，即可实现消息订阅

## 使用方法

1. snmptt_build 目录是用于构建一个snmptt的镜像，其中，里面的snmptt.ini需要根据实际场景填写mysql的连接参数
2. 进入snmptt_build目录下，通过docker build -t snmptraps:0.0.1 .  用来构建docker镜像
3. snmptrap_run 目录是用于将snmptt和mysql同步启动的compose配置文件。
4. snmptt容器镜像构建完后，进入snmptrap_run，通过docker-compose up -d可以直接将snmptt和mysql服务启动。
5. kafka_canal_run 目录是用于同步启动zookeeper、 kafka 三个实例组成的集群、canal数据同步任务同步启动，用于将mysql的数据实时同步进kafka消息队列