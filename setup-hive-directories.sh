#!/bin/bash

# Create necessary directories in HDFS
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp/hive

# Set appropriate permissions
hdfs dfs -chmod 777 /tmp/
hdfs dfs -chmod 777 /user/hive/warehouse
hdfs dfs -chmod 777 /tmp/hive

# Optional: Print directory structure to verify
hdfs dfs -ls /user/hive/warehouse
hdfs dfs -ls /tmp/hive

# Start HiveServer2
source ~/.bashrc && /opt/hive/bin/hive --service hiveserver2 &