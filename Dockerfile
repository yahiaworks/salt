FROM ubuntu:16.04

RUN apt-get update

ADD https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub /tmp/SALTSTACK-GPG-KEY.pub
RUN apt-key add /tmp/SALTSTACK-GPG-KEY.pub
RUN echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" > /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

# Salt
RUN apt -y install python-pip
RUN pip install pyvmomi

RUN apt-get -y install salt-api=2017.7.2+ds-1
RUN apt-get -y install salt-cloud=2017.7.2+ds-1
RUN apt-get -y install salt-master=2017.7.2+ds-1
RUN apt-get -y install salt-ssh=2017.7.2+ds-1
RUN apt-get -y install salt-syndic=2017.7.2+ds-1

RUN pip uninstall -y cherrypy
RUN pip install cherrypy==3.2.3
####

# Salt cloud
RUN pip install pyOpenSSL --upgrade
RUN pip install pywinrm

RUN wget https://github.com/CoreSecurity/impacket/releases/download/impacket_0_9_15/impacket-0.9.15.tar.gz
RUN tar -xvzf impacket-0.9.15.tar.gz
RUN cd impacket-0.9.15 && python setup.py install

COPY config/cloud.profiles.d/vmware.conf /etc/salt/cloud.profiles.d/
COPY config/cloud.providers.d/vmware.conf /etc/salt/cloud.providers.d/

# SSL
RUN mkdir /etc/salt/certs
COPY config/certs/star.vistaprint.net/star.vistaprint.net.crt /etc/salt/certs/
COPY config/certs/star.vistaprint.net/star.vistaprint.net.key.encrypted /etc/salt/certs/
####

# SaltPad
RUN apt-get -y install unzip
RUN wget https://github.com/Lothiraldan/saltpad/releases/download/v0.3.1/dist.zip
RUN unzip dist.zip -d /
RUN mv /dist /saltpad
COPY saltpad/settings.json /saltpad/static/

RUN apt-get -y install nginx
COPY saltpad/nginx/default /etc/nginx/sites-enabled/default
####

COPY config/master /etc/salt/
ADD scripts/run_salt_master.sh /run_salt_master.sh
ADD scripts/replace_credentials.sh /
RUN chmod a+x /run_salt_master.sh
RUN chmod a+x /replace_credentials.sh

ADD https://repo.saltstack.com/windows/Salt-Minion-2017.7.2-Py2-AMD64-Setup.exe /

# Patch some salt files... hopefully we don't need this for long!
COPY config/patch/cloud.py.patch /tmp/
COPY config/patch/vmware.py.patch /tmp/
RUN patch /usr/lib/python2.7/dist-packages/salt/utils/cloud.py < /tmp/cloud.py.patch
RUN patch /usr/lib/python2.7/dist-packages/salt/cloud/clouds/vmware.py < /tmp/vmware.py.patch

EXPOSE 4505 4506 5985 5986 443 8000 8080

ENTRYPOINT ["/run_salt_master.sh"]