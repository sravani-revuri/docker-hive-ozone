FROM apache/hive:4.0.0

USER root

COPY hadoop-ozone/ozonefs-hadoop3/target/ozone-filesystem-hadoop3-2.2.0-SNAPSHOT.jar \
  /opt/hive/lib/ozone-filesystem-hadoop3.jar

COPY docker/hive-ozone/core-site.xml /opt/hive/conf/core-site.xml
COPY docker/hive-ozone/ozone-site.xml /opt/hive/conf/ozone-site.xml
COPY docker/hive-ozone/hive-site.xml /opt/hive/conf/hive-site.xml

RUN chmod 644 /opt/hive/lib/ozone-filesystem-hadoop3.jar \
    /opt/hive/conf/core-site.xml \
    /opt/hive/conf/ozone-site.xml \
    /opt/hive/conf/hive-site.xml

ENV HADOOP_CONF_DIR=/opt/hive/conf

USER hive
