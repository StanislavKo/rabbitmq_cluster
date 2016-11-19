#!/bin/bash

sudo docker build --tag=stanislavko/rabbitmq_cluster_server ./rabbitmq_server
sudo docker build --tag=stanislavko/rabbitmq_cluster_bind9 ./bind9



