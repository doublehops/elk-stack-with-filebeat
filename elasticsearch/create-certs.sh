#!/bin/bash

# Create cert/s for Elasticsearch
# This script has been created from follwing steps on this page: https://www.elastic.co/guide/en/fleet/current/secure-logstash-connections.html
# To run this script, you must login to the container as the root user: docker compose -u root elasticsearch bash

TEMP_PATH=/usr/share/elasticsearch/temp
LOGSTASH_IP=192.0.2.1
LOGSTASH_HOSTNAME=elasticsearch


mkdir -p $TEMP_PATH

mkdir -p /usr/share/elasticsearch/config/certs
chown elasticsearch:elasticsearch /usr/share/elasticsearch/config/certs
# cd /usr/share/elasticsearch

# Generate a certificate authority (CA).
bin/elasticsearch-certutil ca --silent --pem --out $TEMP_PATH/ca.zip
unzip -o $TEMP_PATH/ca.zip -d $TEMP_PATH

# Generate a client SSL certificate signed by your CA.
./bin/elasticsearch-certutil cert \
  --name client \
  --ca-cert $TEMP_PATH/ca/ca.crt \
  --ca-key  $TEMP_PATH/ca/ca.key \
  --pem \
  --out $TEMP_PATH/client.zip

unzip -o $TEMP_PATH/client.zip -d $TEMP_PATH

# Generate a Logstash SSL certificate signed by your CA.
./bin/elasticsearch-certutil cert \
  --name logstash \
  --ca-cert $TEMP_PATH/ca/ca.crt \
  --ca-key $TEMP_PATH/ca/ca.key \
  --dns $ELASTICSEARCH_HOSTNAME \
  --ip $LOGSTASH_IP \
  --pem \
  --out $TEMP_PATH/logstash.zip


unzip -o $TEMP_PATH/logstash.zip -d $TEMP_PATH

# Convert the Logstash key to pkcs8.
openssl pkcs8 -inform PEM -in logstash.key -topk8 -nocrypt -outform PEM -out logstash.pkcs8.key
