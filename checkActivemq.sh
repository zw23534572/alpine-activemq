#!/bin/bash

function getStatus(){
        cmd=`nc -z $1 $2`;
        return `echo $?`;
}

container_name=`curl -s http://rancher-metadata/2016-07-29/self/container/name`;
container_name=${container_name%-*};

activemq_num=0;

for i in `seq 1 $1`
        do
        echo -ne "$container_name-${i}\t"
        getStatus $container_name-${i} $2
        count=`echo $?`;
        if [ $count == 0 ];then
                echo "master";
                activemq_num=$activemq_num+1;
        else
                echo "slave";
        fi
done
if [ $activemq_num == 0 ];then
        exit 1;
fi
exit 0;