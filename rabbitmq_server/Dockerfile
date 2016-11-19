FROM rabbitmq:3.6.5-management

RUN apt-get update; apt-get install -y unzip wget tar openssh-server lighttpd

RUN sed -i 's/80/1180/' /etc/lighttpd/lighttpd.conf
RUN sed -i 's/\/var\/www\/html/\/var\/www_docker/' /etc/lighttpd/lighttpd.conf
RUN mkdir /var/www_docker

RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management sockjs 2>&1

# /usr/sbin/rabbitmq-server has some irritating behavior, and only exists to "su - rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server ..."
ENV PATH /usr/lib/rabbitmq/bin:$PATH

# set home so that any `--user` knows where to put the erlang cookie
ENV HOME /var/lib/rabbitmq

RUN mkdir -p /var/lib/rabbitmq /etc/rabbitmq \
	&& chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq \
	&& chmod 777 /var/lib/rabbitmq /etc/rabbitmq

ADD files/.erlang.cookie /var/lib/rabbitmq

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config  

RUN mkdir /opt/rabbit
ADD files/startrabbit.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/startrabbit.sh
ADD files/startrabbit2.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/startrabbit2.sh

EXPOSE 1180
EXPOSE 5672
EXPOSE 15672
EXPOSE 25672
EXPOSE 4369
EXPOSE 9100
EXPOSE 9101
EXPOSE 9102
EXPOSE 9103
EXPOSE 9104
EXPOSE 9105

CMD ["/opt/rabbit/startrabbit.sh"]

