FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y install apt-utils && \
    apt-get -y install wget build-essential cmake openssl libssl-dev && \
    cd ~ && \
    wget http://prdownloads.sourceforge.net/ircd-hybrid/ircd-hybrid-8.2.19.tgz && \
    tar -xzf ircd-hybrid-8.2.19.tgz && \
    cd ircd-hybrid-8.2.19 && \
    adduser --disabled-password --gecos 'Hybrid-IRC' ircd && \
    ./configure --prefix=/home/ircd/hybrid && \
    make && \
    make install && \
    cd /home/ircd && \
    chown -R ircd:ircd hybrid && \
    apt -y autoremove

ENTRYPOINT ["su", "-m", "ircd", "-c", "/home/ircd/hybrid/bin/ircd"]
