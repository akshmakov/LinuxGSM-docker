#!/bin/bash

## can be simplified.

## name of the docker process
InstanceName="arkserver"
## arkserver for me (it's the script name in the serveur directory)
ServerType="arkserver"
## Image name to run (i have build with the lgsm-build.sh)
Img="lgsm-docker"

## check if the container already running (true or '')
status=$(sudo docker inspect --format="{{.State.Running}}" $InstanceName 2> /dev/null)

if [ "$status" != "true" ] && [ "$1" != "stop" ]
then
	echo "docker container was not running. start it for you."
	sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
elif [ "$status" == "true" ]
then
	echo "docker container already running, append command."
else
	echo "docker container not running."
fi

if [ "$1" != "" ]
then
       	cmd=$1
else
	echo $"Usage: $0 {start|stop|restart|console|monitor|update|backup|attach|command|cronjob}"
	read -a cmd
fi


case $cmd in
        "install")
            read -a type
	    sudo docker exec $InstanceName $ServerType install $type
            ;;

        "start")
            sudo docker exec $InstanceName $ServerType start
            ;;

        "stop")
	    if [ "$status" == "true" ]
	    then
            	sudo docker exec $InstanceName $ServerType stop
	    	sudo docker kill $InstanceName
	    fi
            ;;

        "restart")
            sudo docker exec $InstanceName $ServerType restart
            ;;

        "console")
            sudo docker exec $InstanceName $ServerType console
            ;;

        "monitor")
            sudo docker exec $InstanceName $ServerType monitor
            ;;

        "update") ## update stop the server if is already running(lgsm script).
            sudo docker exec $InstanceName $ServerType update
            ;;

        "backup")
            sudo docker exec $InstanceName $ServerType backup
            ;;

        "conjob") ## need to be test.
            sudo docker exec $InstanceName crontab -l > tempcronfile
	    sudo docker exec $InstanceName echo "0 5 * * *  /home/lgsm/$ServerType update > /dev/null 2>&1" > tempcronfile
 	    sudo docker exec $InstanceName crontab tempcronfile && rm tempcronfile
            ;;

	"attach")
	    sudo docker attach $InstanceName
	    ;;

	"command")
	    echo "input the complete command to execute in virtual container"
	    read -a $command
	    sudo docker exec $InstanceName $command
	    ;;

        *)
            exit 1

esac

#sudo docker run --name arkserver --rm -it -d -v "/home/lgsm/:/home/lgsm" lgsm-docker bash $@
