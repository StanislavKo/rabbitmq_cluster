Dockerfiles for building RabbitMQ cluster

Why https://github.com/bijukunjummen/docker-rabbitmq-cluster/ doesn't work
------------
Nodes don't see each other:
![cluster overview](images/bijukunjummen_02.png)

This cluster is configured better
------------
Nodes are accessible from each other:
![cluster overview](images/stanislavko_cluster_status.png)

YAML file
------------
Typical configuration:
![cluster overview](images/stanislavko_yaml.png)

DNS hard code can be found during starting up
![cluster overview](images/stanislavko_dns.gif)
