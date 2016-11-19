FROM ubuntu:trusty

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y bind9 openssh-server

RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config  

RUN groupadd -r named
RUN useradd -r -m -g named named

ADD files/init.sh /init.sh
RUN chmod 750 /init.sh

ADD files/lighttpd.sh /lighttpd.sh 
RUN chmod a+x /lighttpd.sh

EXPOSE 53/udp
WORKDIR /etc/bind

CMD ["/init.sh"]
