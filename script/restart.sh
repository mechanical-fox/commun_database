
#!/bin/bash

# A script than restart all docker container stopped

for container in $(docker container ps -a -q); do

    if [ $(docker container ps -q | grep -e $container | wc -l) == 0 ]
    then
        echo "Script restart.sh at" $(date) ": restarting container \"$container\""
        echo "Script restart.sh at" $(date) ": restarting container \"$container\"" 1>> log.txt 2>> log.txt
        docker container start $container 
    fi
done

