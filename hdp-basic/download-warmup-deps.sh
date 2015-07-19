#!/bin/bash

#The exit of download_deps needs to be trapped because the Docker build exits
function download_deps {
  yum install -y yum-plugin-downloadonly
  yum install -y --downloadonly hadoop_*-yarn* hadoop_*-hdfs* hadoop_*-hcatalog* hadoop_*-metastore* snappy snappy-devel ambari-log4j httpd python-rrdtool-1.4.5 hive_* mysql mysql-server tez_* fping
}
trap download_deps EXIT
