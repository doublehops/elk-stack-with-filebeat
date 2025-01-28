This repo is a PoC of running Logstash and Elasticsearch locally.


Run `./build.sh` to build the app_service container.

Run `docker compose up -d` to start the containers.

The Docker instances are configured to use a named volume `shared_logs` which allows the containers to share a directory and its files, but doesn't create an actual directory on the file system.

##Logstash##

It's good to check at this time to see if Logstash is picking up files from the Nginx logs. Run `docker compose logs -f logstash` to watch any new log entries. Run `curl http://localhost:8880/` to create a new log entry to test.

##Elasticsearch##

Check that the index exists: `curl -X GET "localhost:9200/_cat/indices?v"`<br>
Query data in the index: `curl -X GET "localhost:9200/logstash-*/_search?pretty"`<br>
Get the count of log messages received by Elasticsearch: `curl -s -X GET "localhost:9200/_count" | jq`<br>
