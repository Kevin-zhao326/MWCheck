#!/bin/bash

function get_jichu_date(){
read -p "Please input your  data path:"  data_path
read -p "Please input your middleware:" middleware
cd $data_path
for tar in *.tar.gz;do tar xvf $tar;done
rm -rf *.tar.gz
}

function get_os_data(){
    mkdir -p /tmp/data/$middleware
    new_data=/tmp/data/$middleware
    if [ "$(ls -A $new_data)" ];then  
        echo "$new_data is not empty!!!"
        rm -rf $new_data/*
        echo "clean $new_data !!!"
    else    
        echo "$new_data is empty!!!"
    fi    
    cd $data_path/tmp/tmpcheck
    for file in  $data_path/tmp/tmpcheck/*_os_*.txt ;
    do
        ip=`cat $file |grep 'ip info' -A2|tail -n1|awk '{print $2}'`
        result=$(echo $ip | grep "addr")
        if [[ "$result" != "" ]];
        then 
            ip=${ip#*:} 
        fi
        new_document=$new_data/$ip.txt
        App=$middleware
        echo "=====================OS基础信息=====================" >> $new_document
        IP_Address=`echo IP_Address=$ip >> $new_document`
        Hostname=`cat $file |grep -A 1 'hostname'|grep -v 'hostname'`&& echo Hostname=$Hostname >> $new_document
        OS_version=`cat $file|grep -A 1 'os kernal' |grep -v 'os kernal'|awk -F "#" '{print $1}'`&& echo OS_version=$OS_version >> $new_document
        CPU_cores=`cat $file|grep -A 1 'CPU cores'|grep -v 'CPU cores'`&& echo CPU_cores=$CPU_cores >> $new_document
        Max_user_processes=`cat $file |grep 'max user processes '|awk '{print $NF}'`&& echo Max_user_processes=$Max_user_processes >> $new_document
        Openfile=`cat $file|grep 'open files'|awk '{print $NF}'` && echo Openfile=$Openfile >> $new_document
        Mem_use_meminfo_total=`cat $file |grep -A 2 'mem usage:'|grep -v 'mem usage'|grep -v total |awk '{print $2}'`&& echo Mem_use_meminfo_total=$Mem_use_meminfo_total >> $new_document
        Mem_used=`cat $file |grep -A 2 'mem usage:'|grep -v 'mem usage'|grep -v total |awk '{print $3}'`&& echo Mem_used=$Mem_used >> $new_document
        Mem_free=`cat $file |grep -A 2 'mem usage:'|grep -v 'mem usage'|grep -v total |awk '{print $4}'`&& echo Mem_free=$Mem_free >> $new_document
        cat $file |sed -n /disk/,/dist/p|grep -v dist |grep -v disk >> $new_document
        IO_user=`cat $file |grep -A 4 'io usage'|tail -1|awk '{print $1}'` && echo IO_user=$IO_user >> $new_document
        IO_system=`cat $file |grep -A 4 'io usage'|tail -1|awk '{print $3}'` && echo IO_system=$IO_system >> $new_document
        IO_wait=`cat $file |grep -A 4 'io usage'|tail -1|awk '{print $4}'` && echo IO_wait=$IO_wait >> $new_document
        IO_idle=`cat $file |grep -A 4 'io usage'|tail -1|awk '{print $6}'` && echo IO_idle=$IO_idle >> $new_document
        Swap_method=`cat $file |grep -A 1 'swap method'|grep -v 'swap method'` && echo Swap_method=$Swap_method >> $new_document
    done
}

function get_kafka_data(){
    new_data=/tmp/data/$middleware
    cd $data_path/tmp/tmpcheck
    for file1 in `ls $data_path/tmp/tmpcheck/*_$middleware_*.txt|grep -v os` ;
    do
        ip_1=`ls $file1|awk -F "_" '{print $2}'`
        new_document=$new_data/$ip_1.txt
        echo "=====================Kafka基础信息=====================" >> $new_document
        Kafka_version=`cat $file1 |grep -io "kafka_.*"|awk -F ":" '{print $1}'|awk -F "_" '{print $2}'|cut -d "." -f1-4` && echo Kafka_version=$Kafka_version >> $new_document
        Installation_path=`cat $file1 |grep -io 'Dkafka.logs.dir=.*'|awk -F "=" '{print $2}'|cut -d "." -f1` && echo Installation_path=$Installation_path >> $new_document
        Start_User=`cat $file1  |grep -A1 "当前服务器Kafka进程地址(供参考)：" |grep -v "当前服务器Kafka进程地址(供参考)："|awk -F " " '{print $1}'` && echo Start_User=$Start_User >> $new_document
        JVM_Instal_path=`cat $file1 |grep -A1 "当前服务器Kafka进程地址(供参考)：" |grep -v "当前服务器Kafka进程地址(供参考)："|awk -F " " '{print $8}'` && echo JVM_Instal_path=$JVM_Instal_path >> $new_document
        JVM_run_parameters=`cat $file1 |grep -io 'Xms.*'|awk -F "-Djava" '{print $1}'` && echo JVM_run_parameters=$JVM_run_parameters >> $new_document
        Server_Port=`cat $file1 |grep "listeners=PLAINTEXT:"|grep -v "sensitive"|grep -v "advertised"|awk -F ":" '{print $NF}'` && echo Server_Port=$Server_Port >> $new_document
        echo "=====================Kafka配置文件=====================" >> $new_document
        Broker_id=`cat $file1 |grep "broker.id"|grep -v "generation"|grep -v "sensitive"` && echo $Broker_id >> $new_document
        delete_topic_enable=`cat $file1 |grep "delete.topic.enable"|grep -v "generation"|grep -v "sensitive"` && echo $delete_topic_enable >> $new_document
        listeners=`cat $file1 |grep "listeners"|grep -v "generation"|grep -v "sensitive"` && echo $listeners >> $new_document
        num_network_threads=`cat $file1 |grep "num.network.threads"|grep -v "generation"|grep -v "sensitive"` && echo $num_network_threads >> $new_document
        num_io_threads=`cat $file1 |grep "num.io.threads"|grep -v "generation"|grep -v "sensitive"` && echo $num_io_threads >> $new_document
        log_dirs=`cat $file1 |grep "log.dirs"|grep -v "generation"|grep -v "sensitive"` && echo $log_dirs >> $new_document
        num_partitions=`cat $file1 |grep "num.partitions"|grep -v "generation"|grep -v "sensitive"` && echo $num_partitions >> $new_document
        num_recovery_threads_per_data_dir=`cat $file1 |grep "num.recovery.threads.per.data.dir"|grep -v "generation"|grep -v "sensitive"` && echo $num_recovery_threads_per_data_dir >> $new_document
        default_replication_factor=`cat $file1 |grep "default.replication.factor"|grep -v "generation"|grep -v "sensitive"` && echo $default_replication_factor >> $new_document
        offsets_topic_replication_factor=`cat $file1 |grep "offsets.topic.replication.factor"|grep -v "generation"|grep -v "sensitive"` && echo $offsets_topic_replication_factor >> $new_document
        transaction_state_log_replication_factor=`cat $file1 |grep "transaction.state.log.replication.factor"|grep -v "generation"|grep -v "sensitive"` && echo $transaction_state_log_replication_factor >> $new_document
        transaction_state_log_min_isr=`cat $file1 |grep "transaction.state.log.min.isr"|grep -v "generation"|grep -v "sensitive"` && echo $transaction_state_log_min_isr >> $new_document
        log_retention_hours=`cat $file1 |grep "log.retention.hours"|grep -v "generation"|grep -v "sensitive"` && echo $log.retention.hours >> $new_document
        log_roll_hour=`cat $file1 |grep "log.roll.hour"|grep -v "generation"|grep -v "sensitive"` && echo $log_roll_hour >> $new_document
        log_cleaner_enable=`cat $file1 |grep "log.cleaner.enable"|grep -v "generation"|grep -v "sensitive"` && echo $log_cleaner_enable >> $new_document
        zookeeper_connection_timeout_ms=`cat $file1 |grep "zookeeper.connection.timeout.ms"|grep -v "generation"|grep -v "sensitive"` && echo $zookeeper_connection_timeout_ms >> $new_document
        echo "=====================Kafka运行数据=====================" >> $new_document
        echo "" >> $new_document
        cat $file1 |sed -n /查询集群描述/,/查询topic列表/p|grep -v 查询topic列表 >> $new_document
        cat $file1 |sed -n /查询topic列表/,/新消费者列表查询/p|grep -v 新消费者列表查询 >> $new_document
        cat $file1 |sed -n /新消费者列表查询/,/查询消费者成员信息/p|grep -v 查询消费者成员信息 >> $new_document
        cat $file1 |sed -n /查询消费者成员信息/,/查询消费者状态信息/p|grep -v 查询消费者状态信息 >> $new_document
        cat $file1 |sed -n /查询消费者状态信息/,/查询Kafka动静态配置/p|grep -v 查询Kafka动静态配置 >> $new_document
    done

}

get_jichu_date
get_os_data
get_kafka_data