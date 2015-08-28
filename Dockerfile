#
# Based on: `Dockerizing Neo4j graph database` (http://www.github.com/kbastani/docker-neo4j)
#
FROM       dockerfile/java:oracle-java8
MAINTAINER guidj Name <guilherme@predictry.com>

# Install Neo4j
RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
    apt-get update ; apt-get install neo4j=2.2.2 -y

RUN apt-get install nginx wget -y

# Neo4j service
ADD sbin/neo4j-service /etc/init.d/neo4j-service
#ADD sbin/neo4j-users.sh /tmp/neo4j-users.sh

# Install supervisor
RUN apt-get install vim nano supervisor -y

# Copy sueprvisor conf
ADD conf/supervisor/supervisor.conf /etc/supervisor/conf.d/

# Copy graph analytics plugin
COPY plugins /var/lib/neo4j/plugins

# Copy configurations
COPY conf/neo4j /var/lib/neo4j/conf

# Copy New Relic plugin
COPY newrelic /var/lib/neo4j/newrelic
ADD auth /var/lib/neo4j/data/dbms/auth

# Customize configurations
RUN apt-get clean && \
    sed -i "s|data/graph.db|/opt/data/graph.db|g" /var/lib/neo4j/conf/neo4j-server.properties && \
    sed -i "s|#org.neo4j.server.webserver.address|org.neo4j.server.webserver.address|g" /var/lib/neo4j/conf/neo4j-server.properties && \
    sed -i "s|#org.neo4j.server.thirdparty_jaxrs_classes=org.neo4j.examples.server.unmanaged=/examples/unmanaged|org.neo4j.server.thirdparty_jaxrs_classes=extension=/service|g" /var/lib/neo4j/conf/neo4j-server.properties

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Restart supervisor
RUN service supervisor restart

# Expose the Neo4j browser to the host OS on port 7474 and 1337 
EXPOSE 7474
EXPOSE 1337

# Run services via supervisor
CMD ["supervisord", "-n"]
