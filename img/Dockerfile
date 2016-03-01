FROM ubuntu:latest

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y python-software-properties && \
    add-apt-repository -y ppa:pypy/ppa && \
    apt-get -y update && \
    apt-get -y install -y pypy pypy-dev curl supervisor nginx redis-server

RUN curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py && \
    pypy /tmp/get-pip.py && \
    rm -f /tmp/get-pip.py && \
    apt-get -y install build-essential zlib1g-dev libgmp-dev zlib1g-dev libpq-dev libxml2-dev libxslt1-dev

RUN groupadd indus && \
    useradd -m -g indus indus && \
    mkdir -p /opt/indus/{bin,lib,etc} /opt/indus/var/log && \
    chmod 770 -R /opt/indus

ENV PYTHONPATH /indus/lib/shksystem.net.egg

