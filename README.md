Dockerfiles for building RabbitMQ cluster. Minor refactoring of https://github.com/bijukunjummen/docker-rabbitmq-cluster/ to remove one configuration issue.

Minor problem in https://github.com/bijukunjummen/docker-rabbitmq-cluster/
------------
Nodes don't see each other:
![cluster overview](images/bijukunjummen_02.png)

This cluster doesn't have such an issue
------------
Nodes are accessible from each other:
![cluster overview](images/stanislavko_cluster_status.png)

YAML file
------------
Typical configuration:
![cluster overview](images/stanislavko_yaml.png)

DNS hard code can be found during starting up
![cluster overview](images/stanislavko_dns.gif)
