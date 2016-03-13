FROM ubuntu:latest

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common zlib1g-dev libgmp-dev zlib1g-dev libpq-dev libxml2-dev libxslt1-dev && \
    add-apt-repository -y ppa:pypy/ppa && \
    apt-get -y update && \
    apt-get -y install -y pypy pypy-dev curl supervisor nginx redis-server && \
    curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py && \
    pypy /tmp/get-pip.py && \
    rm -f /tmp/get-pip.py && \
    groupadd indus && \
    useradd -m -g indus indus && \
    mkdir -p /opt/indus/bin /opt/indus/lib /opt/indus/etc /opt/indus/var/log && \
    chown -R indus:indus /opt/indus

COPY resources/shksystem.net-0.1.9.15.tar.gz /tmp
COPY resources/bashrc /home/indus/.bashrc
COPY resources/users_api.py /opt/indus/bin

RUN chown -R indus:indus /home/indus /opt/indus /tmp/shksystem.net-0.1.9.15.tar.gz

USER indus

RUN pip install --user tornado sqlalchemy psycopg2cffi redis futures && \
    tar xvf /tmp/shksystem.net-0.1.9.15.tar.gz -C /opt/indus/lib && \
    touch /opt/indus/lib/__init__.py && \
    rm -f /tmp/shksystem.net-0.1.9.15.tar.gz

