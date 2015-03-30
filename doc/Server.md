Server Configuration
=====================


Service (neo4j-service)
------------------------

The number of files neo4j is allowed to access should be be raise high for best performance.
```sh neo4j-service.sh

do_start()

         ulimit -n 60000000
...
```



