install-spark:
	@mkdir -p /opt/spark
	@tar -zxvf /opt/hadoop/spark-3.5.0-bin-hadoop3.tgz -C /opt/spark

install-python3:
	@sudo yum install -y python3
	@sudo unlink /usr/bin/python || true
	@sudo ln -s /usr/bin/python3 /usr/bin/python

install-hive:
	@tar zxvf /opt/hadoop/apache-hive-3.1.3-bin.tar.gz -C /opt
	@mv /opt/apache-hive-3.1.3-bin /opt/hive
	@cp /opt/hadoop/mysql-connector-java-8.0.28.jar /opt/hive/lib/mysql-connector-java-8.0.28.jar
	@cp /opt/hive/conf/hive-env.sh.template /opt/hive/conf/hive-env.sh
	@echo "export HADOOP_HOME=/opt/hadoop" | sudo tee -a /opt/hive/conf/hive-env.sh
	@cp /opt/hadoop/hive-site.xml /opt/hive/conf/
	@sudo chmod +x /opt/hadoop/setup-hive-directories.sh

set-hive-env:
	@echo "export HIVE_HOME=/opt/hive" >> ~/.bashrc
	@echo "export PATH=\$$PATH:\$$HIVE_HOME/bin" >> ~/.bashrc
	@source ~/.bashrc && echo "HIVE_HOME is set to: $$HIVE_HOME"

init-hive-schema: set-hive-env
	@source ~/.bashrc && schematool -initSchema -dbType mysql

configure-zeppelin-hive:
	@cp /opt/hadoop/share/hadoop/common/hadoop-common-3.3.6.jar /opt/zeppelin/interpreter/jdbc/
	@ln -s /opt/hive/lib/*.jar /opt/zeppelin/interpreter/jdbc/
	@/opt/zeppelin/bin/zeppelin-daemon.sh restart

start-namenode:
	@hdfs namenode

install-zeppelin:
	@tar zxvf /opt/hadoop/zeppelin-0.11.2-bin-all.tgz -C /opt
	@mv /opt/zeppelin-0.11.2-bin-all /opt/zeppelin
	@cp /opt/zeppelin/conf/zeppelin-env.sh.template /opt/zeppelin/conf/zeppelin-env.sh

configure-zeppelin:
	@echo "export JAVA_HOME=/usr/lib/jvm/jre/" | sudo tee -a /opt/zeppelin/conf/zeppelin-env.sh
	@echo "export ZEPPELIN_ADDR=0.0.0.0" | sudo tee -a /opt/zeppelin/conf/zeppelin-env.sh
	@echo "export SPARK_HOME=/opt/spark/spark-3.5.0-bin-hadoop3" | sudo tee -a /opt/zeppelin/conf/zeppelin-env.sh

start-zeppelin:
	@/opt/zeppelin/bin/zeppelin-daemon.sh start

setup-zeppelin: install-zeppelin configure-zeppelin start-zeppelin
setup-hive: install-hive set-hive-env init-hive-schema configure-zeppelin-hive
