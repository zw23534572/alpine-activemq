FROM registry.cn-shenzhen.aliyuncs.com/sjroom/alpine-java8

ENV ACTIVEMQ_VERSION 5.15.3
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161
ENV SHA512_VAL=b6b73d15d6f54e459655009d3d8d84ab66a87f354aebfc656855371535914f538be1b52724ed153aaba0b2f92e93889f1e6d870e620cfddca8b6e922fb096081

ADD apache-activemq-5.15.3-bin.tar.gz /opt/
ENV ACTIVEMQ_HOME /opt/activemq
RUN set -x && \
    mkdir -p /opt && \
    apk --update add --virtual build-dependencies

RUN ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    addgroup -S activemq && adduser -S -H -G activemq -h $ACTIVEMQ_HOME activemq && \
    chown -R activemq:activemq /opt/$ACTIVEMQ && \
    chown -h activemq:activemq $ACTIVEMQ_HOME && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

ADD checkActivemq.sh /export/servers/checkActivemq.sh
ADD consul.json /export/servers/consul/consul.json
ADD activemq.xml /opt/activemq/conf/activemq.xml
RUN chmod 777 -R /export/servers/consul/

RUN echo "$ACTIVEMQ_HOME/bin/activemq console&" >> /export/servers/start.sh

#USER activemq
WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI



