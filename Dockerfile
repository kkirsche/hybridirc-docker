FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y install apt-utils && \
    apt-get -y install wget build-essential cmake openssl libssl-dev && \
    cd ~ && \
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
    apt-get --purge -y remove wget build-essential cmake openssl libssl-dev && \
    apt -y autoremove

ENTRYPOINT ["su", "-m", "ircd", "-c", "/home/ircd/hybrid/bin/ircd"]
