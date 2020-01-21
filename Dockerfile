FROM centos:centos7

LABEL maintainer OSG Software <help@opensciencegrid.org>

# Create the squid user with a fixed GID/UID
RUN groupadd -o -g 10941 squid
RUN useradd -o -u 10941 -g 10941 -s /sbin/nologin -d /var/lib/squid squid


RUN yum -y install epel-release \
                   yum-plugin-priorities 

RUN yum clean all && \
    yum update -y 

RUN yum install -y cronie http://frontier.cern.ch/dist/rpms/RPMS/x86_64/frontier-squid-4.9-4.1.x86_64.rpm supervisor

RUN yum clean all --enablerepo=* && rm -rf /var/cache/yum/

ADD sbin/* /usr/local/sbin/

ADD supervisord.conf /etc/
ADD supervisord.d/* /etc/supervisord.d/
RUN mkdir -p /var/log/supervisor

EXPOSE 3128

CMD ["/usr/local/sbin/supervisord_startup.sh"]
