FROM ubuntu:20.04

ENV SERVERINFO_NAME="irc.domain.com" \
    SERVERINFO_DESCRIPTION="ircd-hybrid test server" \
    SERVERINFO_NETWORKNAME="MyIRCNetwork" \
    SERVERINFO_NETWORKDESC="My IRC Network Description" \
    SERVERINFO_HUB=no \
    SERVERINFO_DEFAULTMAXCLIENTS=512 \
    SERVERINFO_MAXNICKLENGTH=30 \
    SERVERINFO_MAXTOPICLENGTH=300 \
    OPERATOR_NAME=sheep \
    OPERATOR_PASSWORD=$5$x5zof8qe.Yc7/bPp$5zIg1Le2Lsgd4CvOjaD20pr5PmcfD7ha/9b2.TaUyG4 \
    OPERATOR_ENCRYPTEDPASSWORD=yes \
    CONNECT_NAME=services.domain.com \
    CONNECT_HOST=10.10.10.137 \
    CONNECT_SENDPASSWORD=password \
    CONNECT_ACCEPTPASSWORD=password \
    CONNECT_ENCRYPTEDACCEPTPASSWORD=no \
    CONNECT_PORT=6697

RUN apt-get update && \
    apt-get -y install apt-utils && \
    apt-get -y install wget build-essential cmake openssl libssl-dev && \
    cd ~ && \
    wget https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 && \
    chmod +x confd-0.11.0-linux-amd64 && \
    wget http://prdownloads.sourceforge.net/ircd-hybrid/ircd-hybrid-8.2.19.tgz && \
    tar -xzf ircd-hybrid-8.2.19.tgz && \
    cd ircd-hybrid-8.2.19 && \
    # adduser's -m flag, to create a home directory, is not used on Ubuntu
    adduser --disabled-password --gecos 'Hybrid-IRC' ircd && \
    ./configure --prefix=/home/ircd/hybrid && \
    make && \
    make install && \
    cd /home/ircd && \
    chown -R ircd:ircd hybrid && \
    # -y MUST be after --purge to work!
    apt-get --purge -y remove wget build-essential cmake && \
    apt -y autoremove && \
    mkdir -p /etc/confd/{conf.d,templates}

ADD ircd.toml /etc/confd/conf.d/ircd.toml
ADD ircd.conf.tmpl /etc/confd/templates/ircd.conf.tmpl
ADD boot.sh /home/ircd/boot.sh

EXPOSE 6697

ENTRYPOINT ["/home/ircd/boot.sh"]
