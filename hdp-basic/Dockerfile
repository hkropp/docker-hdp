# OS
FROM centos:6.6

# Hostname Help
ENV HOSTNAME n1.hdp
ADD set_host.sh /tmp/

# Install HDP repos
ADD ambari.repo /etc/yum.repos.d/ambari.repo
ADD HDP.repo /etc/yum.repos.d/HDP.repo

# Enable DNS
RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Download and install packages
RUN yum update -y && yum install -y ambari-server ambari-agent wget git sudo tar curl postgresql-jdbc openssh-server openssh-clients
ADD download-warmup-deps.sh /tmp/
RUN sh /tmp/download-warmup-deps.sh

# Install Ambari server
RUN ambari-server setup -s 
RUN ambari-server setup --jdbc-db=postgres --jdbc-driver=/usr/share/java/postgresql-jdbc.jar

# Prepare DB for hive, oozie, ..
RUN rm -rf /tmp/.s.PGSQL.5432.*
RUN echo 'local hive hive md5' >> /var/lib/pgsql/data/pg_hba.conf
RUN echo 'local oozie oozie md5' >> /var/lib/pgsql/data/pg_hba.conf
RUN echo 'host hive hive 0.0.0.0/0 md5' >> /var/lib/pgsql/data/pg_hba.conf
RUN echo 'host oozie oozie 0.0.0.0/0 md5' >> /var/lib/pgsql/data/pg_hba.conf

# Setup env
ENV JAVA_HOME /usr/jdk64/jdk1.8.0_40
ENV PATH $JAVA_HOME/bin:$PATH
WORKDIR /tmp

# Setup networking for Ambari agent/server
ADD hostname.sh /etc/ambari-agent/conf/hostname.sh
#RUN sed -i "s/hostname=.*/hostname=n1\.hdp/" /etc/ambari-agent/conf/ambari-agent.ini
RUN sed -i "/\[agent\]/ a public_hostname_script=\/etc\/ambari-agent\/conf\/hostname.sh" /etc/ambari-agent/conf/ambari-agent.ini
RUN sed -i "/\[agent\]/ a hostname_script=\/etc\/ambari-agent\/conf\/hostname.sh" /etc/ambari-agent/conf/ambari-agent.ini
RUN sed -i "s/agent.task.timeout=900/agent.task.timeout=2000/" /etc/ambari-server/conf/ambari.properties

# External resources exposure
VOLUME /var/log
EXPOSE 8080

# Install HDP
RUN curl -o /tmp/ambari-shell.jar https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/ambari-shell/0.1.25/ambari-shell-0.1.25.jar
ADD blueprint.json /tmp/
ADD hostmapping.json /tmp/
ADD install-cluster.sh /tmp/
RUN /tmp/set_host.sh && /tmp/install-cluster.sh
ADD start-server /start-server

CMD ["/start-server"]
