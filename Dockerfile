FROM ubuntu:16.04

RUN apt-get update

#RUN apt-get install -y software-properties-common dmidecode
#RUN add-apt-repository -y ppa:saltstack/salt
ADD https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub /tmp/SALTSTACK-GPG-KEY.pub
RUN apt-key add /tmp/SALTSTACK-GPG-KEY.pub
RUN echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" > /etc/apt/sources.list.d/saltstack.list

RUN apt-get update

RUN apt -y install python-pip
RUN pip install pyVmomi
RUN pip install pyOpenSSL
RUN pip install pywinrm

RUN apt-get -y install salt-api
RUN apt-get -y install salt-cloud
RUN apt-get -y install salt-master
RUN apt-get -y install salt-ssh
RUN apt-get -y install salt-syndic

RUN wget https://github.com/CoreSecurity/impacket/releases/download/impacket_0_9_15/impacket-0.9.15.tar.gz
RUN tar -xvzf impacket-0.9.15.tar.gz
RUN cd impacket-0.9.15 && python setup.py install

COPY config/cloud.profiles.d/vmware.conf /etc/salt/cloud.profiles.d/
COPY config/cloud.providers.d/vmware.conf /etc/salt/cloud.providers.d/
COPY config/master /etc/salt/
ADD run_salt_master.sh /run_salt_master.sh
RUN chmod a+x /run_salt_master.sh

COPY Salt-Minion-2017.7.2-Py2-AMD64-Setup.exe /

# Patch cloud.py... hopefully we don't need this for long!
COPY config/patch/cloud.py /usr/lib/python2.7/dist-packages/salt/utils/

EXPOSE 4505 4506 5985 5986 443

CMD ["/run_salt_master.sh"]