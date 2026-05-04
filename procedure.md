## Ozone set up
add these properties to ozone repo docker-config

```
OZONE-SITE.XML_ozone.replication=1
OZONE-SITE.XML_ozone.replication.type=RATIS
```

build and start ozone form compose directory and keep it running.

create vol1 and bucket1

```
docker compose exec scm bash                               
bash-5.1$ ozone sh volume create vol1
bash-5.1$ ozone sh bucket create vol1/bucket1
```


## Do either one of Part-A or Part-B

# PART-A
## Hive container setup

cd to docker/hive-ozone if not in it already.
docker build -f <path to docker file> -t my-hive-ozone:4.0.0 .
### build 
```
docker build -f docker/hive-ozone/Dockerfile -t my-hive-ozone:4.0.0 .
```
### run
```
docker run --rm -it \
--network ozone_default \
-p 10000:10000 \
-p 10002:10002 \
-e SERVICE_NAME=hiveserver2 \
my-hive-ozone:4.0.0
```

### In a seperate terminal from the same docker-hive-ozone path:
Run beeline command inside container created.

docker exec -it <container-name> /opt/hive/bin/beeline -u 'jdbc:hive2://127.0.0.1:10000/' -n hive -p hive

```
docker exec -it dreamy_lehmann /opt/hive/bin/beeline -u 'jdbc:hive2://127.0.0.1:10000/' -n hive -p hive
```

# PART-B
### OR INSTEAD OF BUILD:
```
cd docker/hive-ozone/                                                
docker compose up --build
```
```
docker compose exec hiveserver2 /opt/hive/bin/beeline -u 'jdbc:hive2://127.0.0.1:10000/' -n hive -p hive
```

## Check if everything is working:

```
0: jdbc:hive2://127.0.0.1:10000/> SHOW DATABASES;
```
INFO  : Compiling command(queryId=hive_20260428041332_183a33ee-169a-44a6-ac4d-a57c85d726d9): SHOW DATABASES
INFO  : Semantic Analysis Completed (retrial = false)
INFO  : Created Hive schema: Schema(fieldSchemas:[FieldSchema(name:database_name, type:string, comment:from deserializer)], properties:null)
INFO  : Completed compiling command(queryId=hive_20260428041332_183a33ee-169a-44a6-ac4d-a57c85d726d9); Time taken: 0.798 seconds
INFO  : Concurrency mode is disabled, not creating a lock manager
INFO  : Executing command(queryId=hive_20260428041332_183a33ee-169a-44a6-ac4d-a57c85d726d9): SHOW DATABASES
INFO  : Starting task [Stage-0:DDL] in serial mode
INFO  : Completed executing command(queryId=hive_20260428041332_183a33ee-169a-44a6-ac4d-a57c85d726d9); Time taken: 0.051 seconds
### Hive Database List
| database_name               |
| :--- |
| `default` |
1 row selected (1.273 seconds)||

```
0: jdbc:hive2://127.0.0.1:10000/> SET hive.metastore.warehouse.dir;
```

| set                                                           |
|:--------------------------------------------------------------|
| hive.metastore.warehouse.dir=ofs://om/vol1/bucket1/warehouse/ |
| 1 row selected (0.018 seconds)                                |

```
0: jdbc:hive2://127.0.0.1:10000/> SET hive.metastore.warehouse.external.dir;
```
| set                                                                   |
|:----------------------------------------------------------------------|
| hive.metastore.warehouse.external.dir=ofs://om/vol1/bucket1/external/ |
| 1 row selected (0.011 seconds)                                        |


### run this command and then check in ozone if key is created under vol1/bucket1
```
CREATE DATABASE IF NOT EXISTS oz_test;
USE oz_test;
CREATE TABLE t1 (id INT, name STRING);
INSERT INTO t1 VALUES (1, 'hello');
SELECT * FROM t1;
SHOW CREATE TABLE t1;
```