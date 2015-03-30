sudo docker stop neo4j
sudo docker rm neo4j
sudo docker run -d -i -t -p 49155:1337 -p 49156:7474 -v /volumes/neo/neo4j/data:/opt/data --name neo4j predictry/neo4j
