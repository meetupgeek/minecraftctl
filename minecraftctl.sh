#!/bin/bash
####################
# NAME: minecraftctl.sh
# DESCRIPTION
#   This script is help start or stop the Minecraft server
# USAGE
#   minecraftctl.sh [status|start|stop]
####################

# Value
# Minecraft server jar file
MCFILE=minecraft_server.1.19.jar

# Using max memory sixe (Xmx)
MEMMAX=640M

# Initial memory size (Xms)
MEMMIN=512M

# Minecraft server log file (Full path)
MCLOG="/opt/minecraft_server/logs/latest.log"

RUNCMD="java -Xmx${MEMMAX} -Xms${MEMMIN} -jar ${MCFILE} nogui"
PSCHK='ps aux | grep '\ "${MCFILE}"' | grep java | grep -v grep > /dev/null'

# Function
func_status () {
    eval ${PSCHK}
    if [ $? -eq 0 ] ; then
        echo -e "${MCFILE} prosecce is already running"
        echo -e "----LOG----"
        tail -10 "${MCLOG}"
        return 0
    else
        echo -e "${MCFILE} prosecce is may be stopped"
        echo -e "----LOG----"
        tail -10 "${MCLOG}"
        return 0
    fi
}

func_start () {
    eval ${PSCHK}
    if [ $? -eq 0 ] ; then
        echo -e "Error: ${MCFILE} is already running"
        return 1
    fi
    # TODO: Check screen name (priority low)
    screen -dmS minecraft ${RUNCMD}
    echo -e "${MCFILE} is running"
    return 0
}

func_stop () {
    eval ${PSCHK}
    if [ $? -eq 0 ] ; then
        # TODO: Check screen name (priority low)
        screen -S minecraft -X staff "stop\n"
        return 0
    fi
    echo -e "Error: ${MCFILE} is may be stopped."
    return 1
}

# Main
COMMAND=$1
case "${COMMAND}" in
    "status" )
        func_status ;;
    "start" )
        func_start ;;
    "stop" )
        func_stop ;;
    * )
        echo -e "USAGE: $0 [status|start|stop]"
        exit 1 ;;
esac
exit $?
