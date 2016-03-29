FROM ubuntu:latest

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common zlib1g-dev libgmp-dev zlib1g-dev libpq-dev libxml2-dev libxslt1-dev && \
    add-apt-repository -y ppa:pypy/ppa && \
    apt-get -y update && \
    apt-get -y install -y pypy pypy-dev curl supervisor nginx redis-server postgresql && \
    curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py && \
    pypy /tmp/get-pip.py && \
    rm -f /tmp/get-pip.py && \
    groupadd indus && \
    useradd -m -g indus indus && \
    mkdir -p /indus/bin /indus/lib /indus/etc /indus/var/log && \
    chown -R indus:indus /indus

COPY conf/users.cfg conf/users.conf /tmp

RUN mv /tmp/users.cfg /etc/nginx/sites-available && \
    ln -s /etc/nginx/sites-available/users.cfg /etc/nginx/sites-enabled/users.cfg && \
    mv /tmp/users.conf /etc/supervisor.d

USER indus

COPY ../shksystem.net/net users.py /home/indus

RUN pip install --user tornado sqlalchemy psycopg2cffi redis futures && \
    mv /home/indus/net /indus/lib && \
    touch /opt/indus/lib/__init__.py && \
    mv /home/indus/users.py /indus/bin

EXPOSE 443

