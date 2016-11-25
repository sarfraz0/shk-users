#!/bin/bash

useradd -m -s /bin/bash administrator
su - administrator -c "mkdir ~/.ssh; touch ~/.ssh/authorized_keys; chmod 750 ~/.ssh; chmod 600 ~/.ssh/authorized_keys; vi ~/.ssh/authorized_keys"
usermod -aG sudo administrator
passwd administrator
vi /etc/ssh/ssh_config
## Package generated configuration file
## See the sshd_config(5) manpage for details
#
## What ports, IPs and protocols we listen for
#Port 220
## Use these options to restrict which interfaces/protocols sshd will bind to
##ListenAddress ::
##ListenAddress 0.0.0.0
#Protocol 2
## HostKeys for protocol version 2
#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
##Privilege Separation is turned on for security
#UsePrivilegeSeparation yes
#
## Lifetime and size of ephemeral version 1 server key
#KeyRegenerationInterval 3600
#ServerKeyBits 1024
#
## Logging
#SyslogFacility AUTH
#LogLevel INFO
#
## Authentication:
#LoginGraceTime 120
#PermitRootLogin no
#StrictModes yes
#
#RSAAuthentication yes
#PubkeyAuthentication yes
##AuthorizedKeysFile	%h/.ssh/authorized_keys
#
## Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes
## For this to work you will also need host keys in /etc/ssh_known_hosts
#RhostsRSAAuthentication no
## similar for protocol version 2
#HostbasedAuthentication no
## Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication
##IgnoreUserKnownHosts yes
#
## To enable empty passwords, change to yes (NOT RECOMMENDED)
#PermitEmptyPasswords no
#
## Change to yes to enable challenge-response passwords (beware issues with
## some PAM modules and threads)
#ChallengeResponseAuthentication no
#
## Change to no to disable tunnelled clear text passwords
##PasswordAuthentication yes
#PasswordAuthentication no
#
## Kerberos options
##KerberosAuthentication no
##KerberosGetAFSToken no
##KerberosOrLocalPasswd yes
##KerberosTicketCleanup yes
#
## GSSAPI options
##GSSAPIAuthentication no
##GSSAPICleanupCredentials yes
#
#X11Forwarding yes
#X11DisplayOffset 10
#PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
##UseLogin no
#
##MaxStartups 10:30:60
##Banner /etc/issue.net
#
## Allow client to pass locale environment variables
## AcceptEnv LANG LC_*
#
#Subsystem sftp /usr/lib/openssh/sftp-server
#
## Set this to 'yes' to enable PAM authentication, account processing,
## and session processing. If this is enabled, PAM authentication will
## be allowed through the ChallengeResponseAuthentication and
## PasswordAuthentication.  Depending on your PAM configuration,
## PAM authentication via ChallengeResponseAuthentication may bypass
## the setting of "PermitRootLogin without-password".
## If you just want the PAM account and session checks to run without
## PAM authentication, then enable this but set PasswordAuthentication
## and ChallengeResponseAuthentication to 'no'.
#UsePAM yes
#UseDNS no

service ssh restart

apt-get update
apt-get upgrade

apt-get -y install zlib1g-dev libgmp-dev zlib1g-dev libpq-dev libxml2-dev libxslt1-dev
apt-get -y install  curl supervisor nginx redis-server postgresql

mkdir -p /opt/pypy/5.0.1
wget https://bitbucket.org/pypy/pypy/downloads/pypy-5.0.1-linux64.tar.bz2
tar xvf pypy-5.0.1-linux64.tar.bz2
mv pypy*/* /opt/pypy/5.0.1
rm -rf pypy*

curl https://bootstrap.pypa.io/get-pip.py > /tmp/get-pip.py
/opt/pypy/5.0.1/bin/pypy /tmp/get-pip.py
rm -f /tmp/get-pip.py

groupadd indus
useradd -m -g indus indus
mkdir -p /indus/bin /indus/lib /indus/etc /indus/var/log
chown -R indus:indus /indus

hostnamectl set-hostname users.variablentreprise.com
hostname users.variablentreprise.com

#openssl genrsa -out users.variablentreprise.com.key 4096
#openssl req -new -x509 -sha512 -days 1095 -key users.variablentreprise.com.key -out users.variablentreprise.com.crt
openssl req -newkey rsa:4096 -keyout users.variablentreprise.com.key -out users.variablentreprise.com.csr -sha512
mv users.variablentreprise.com.key users.variablentreprise.com.key.orig
openssl rsa -in users.variablentreprise.com.key.orig  -out users.variablentreprise.com.key
screen openssl dhparam 4096 -out users.variablentreprise.com.pem

mv /home/administrator/users.variablentreprise.com.* /etc/ssl
groupadd ssl_users
usermod -aG ssl_users indus
usermod -aG ssl_users www-data
chown indus:ssl_users /etc/ssl/users.variablentreprise.com.*
chmod 640 /etc/ssl/users.variablentreprise.com.*

vi iptables.sh
##!/bin/bash

## Open all chains
#iptables -P INPUT ACCEPT
#iptables -P OUTPUT ACCEPT
#iptables -P FORWARD ACCEPT

## Flush all rules (may remove fail2ban rules)
#iptables -F INPUT
#iptables -F OUTPUT
#iptables -F FORWARD

## Allow established and related input
#iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## Allow local input
#iptables -A INPUT -i eth0 -p tcp -m state --state NEW -s 10.1.0.0/16 -j ACCEPT

## Allow loopback access
#iptables -A INPUT -i lo -j ACCEPT
#iptables -A OUTPUT -o lo -j ACCEPT

## Allow incoming SSH
#iptables -A INPUT -i eth0 -p tcp --dport 220 -m state --state NEW -j ACCEPT

## Allow incoming HTTPS
#iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW -j ACCEPT

## Limit ssh
#iptables -A INPUT -i eth0 -p tcp --dport 220 -m limit --limit 5/minute --limit-burst 75 -j ACCEPT

#iptables -P INPUT DROP

bash -x iptables.sh
apt-get install iptables-persistent fail2ban

vi /etc/supervisor
#[program:users]
#command=/opt/pypy/5.0.1/bin/pypy /indus/bin/users.py -p 8081 -l /indus/var/log/users.out -d postgresql://tool:human@localhost:5432/users -b psycopg2cffi
#user=indus
#environment=PYTHONPATH="/indus/lib"
#autostart=true
#autorestart=true
#stderr_logfile=/indus/var/log/users_stderr.out
#stdout_logfile=/indus/var/log/users_stdout.out
vi /etc/nginx/sites-available/users
#server {
#    listen 80;
#    return 301 https://$host$request_uri;
#}
#
#server {
#
#    listen 443;
#    server_name localhost;
#
#    auth_basic "Restricted";
#    auth_basic_user_file /etc/nginx/.htpasswd;
#
#    ssl_certificate           /etc/ssl/users.variablentreprise.com.crt;
#    ssl_certificate_key       /etc/ssl/users.variablentreprise.com.key;
#
#    ssl  on;
#    ssl_dhparam /etc/ssl/dh4096.pem;
#    ssl_session_timeout  10m;
#    ssl_prefer_server_ciphers on;
#    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
#    ssl_ciphers 'AES256+EECDH:AES256+EDH';
#    ssl_session_cache shared:SSL:10m;
#    ssl_stapling on;
#    ssl_stapling_verify on;
#    add_header Strict-Transport-Security max-age=535680000;
#
#    access_log            /var/log/nginx/users.access.log;
#
#    location / {
#
#      proxy_set_header        Host $host;
#      proxy_set_header        X-Real-IP $remote_addr;
#      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
#      proxy_set_header        X-Forwarded-Proto $scheme;
#
#      # Fix the “It appears that your reverse proxy set up is broken" error.
#      proxy_pass          http://localhost:8081;
#      proxy_read_timeout  90;
#
#      proxy_redirect      http://localhost:8081 https://localhost;
#    }
#}
ln -s /etc/nginx/sites-available/users /etc/nginx/sites-enabled/users
echo -n 'admin:' >> /etc/nginx/.htpasswd
openssl passwd -apr1 >> /etc/nginx/.htpasswd

# AS indus

/opt/pypy/5.0.1/bin/pip install --user tornado sqlalchemy psycopg2cffi redis futures passlib
mv /home/indus/net /indus/lib
touch /opt/indus/lib/__init__.py
mv /home/indus/users.py /indus/bin

export PATH=/opt/pypy/5.0.1/bin:$PATH
export PYTHONPATH=/indus/lib

