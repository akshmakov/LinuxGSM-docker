#!/bin/bash

## can be simplified.

## name of the docker process
InstanceName='arkserver'
## arkserver for me (it's the script name in the serveur directory)
ServerType='arkserver'
## Image name to run (i have build with the lgsm-build.sh)
Img='lgsm-docker'
## current path; plz execute this script from it folder
Path=`pwd`
## Set the Network Used by docker
network='host'
## Set the hostname for the docker container
hostname='LGSM'

## check if the container already running (true or '')
status=$(sudo docker inspect --format="{{.State.Running}}" $InstanceName 2> /dev/null)

fn_command_sender(){

	case $cmd in
		"install")
		    if[ $2 != "" ]
		    then
			read -a type
			sudo docker exec $InstanceName $ServerType install $type
		    else
		    	echo "Missing parameter for the serveur name to install"
		    	sudo docker exec $InstanceName $ServerType install
		    fi
		    ;;

		"start")
		    sudo docker exec $InstanceName $ServerType start
		    sleep 2
		    sudo docker exec $InstanceName alert_discord.sh start
		    ;;

		"stop")
		    if [ "$status" == "true" ]
		    then
			sudo docker exec $InstanceName alert_discord.sh stop
			sudo docker exec $InstanceName $ServerType stop
			sudo docker kill $InstanceName
		    fi
		    ;;

		"restart")
		    sudo docker exec $InstanceName alert_discord.sh restart
		    sudo docker exec $InstanceName $ServerType restart
		    ;;

		"console")
		    sudo docker exec $InstanceName $ServerType console
		    ;;

		"monitor")
		    sudo docker exec $InstanceName $ServerType monitor
		    ;;

		"update") ## update stop the server if is already running(lgsm script).
		    sudo docker exec $InstanceName alert_discord.sh update
		    sudo docker exec $InstanceName $ServerType update
		    ;;
		    
		"validate")
		    sudo docker exec $InstanceName $ServerType validate
		    ;;

		"backup")
		    sudo docker exec $InstanceName $ServerType backup
		    ;;

		"conjob")
		    crontab -l > CronTemp
		    echo "* */3 * * * bash ${Path}/linuxgsm-docker.sh command bash check_version.sh >/dev/null 2>&1" >> CronTemp
		    crontab CronTemp
		    rm CronTemp
		    ;;

		"attach")
		    echo "dettach with ctrl+p & ctrl+q"
		    sudo docker attach $InstanceName
		    ;;

		"command")
		    ## Need to be test (take all parameter after the first one)
		    sudo docker exec -it $InstanceName ${@:2}
		    ;;

		*)
		    echo "Parameter invalid, exit."
		    exit 1
	esac

}


if [ "$status" != "true" ] && [ "$1" != "stop" ]
then
	echo "docker container was not running. start it for you."
	sudo docker rm $InstanceName 2> /dev/null
	sudo docker run --name $InstanceName --restart always --net=${network} --hostname ${hostname} -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
elif [ "$status" == "true" ]
then
	echo "docker container already running, append command."
else
	echo "docker container not running."
fi

## check if we have a parameter
if [ "${#}" > 0 ]
then
       	cmd=$1
	fn_command_sender $cmd
else
	echo $"Usage: $0 {start|stop|restart|console|monitor|update|backup|attach|command|install}"
	read -a cmd
	fn_command_sender $cmd
fi

#sudo docker run --name arkserver --rm -it -d -v "/home/lgsm/:/home/lgsm" lgsm-docker bash $@
