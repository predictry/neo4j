sudo docker stop viper4j
sudo docker rm viper4j
sudo docker run -d -i -t -p 49155:1337 -p 49156:7474 -v /volumes/viper/neo4j/data:/opt/data --name viper4j predictry/neo4j
