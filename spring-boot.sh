#!/bin/bash
#
# Startup script for a spring boot project
#
# chkconfig: - 84 16
# description: spring boot project

# Source function library.
[ -f "/etc/rc.d/init.d/functions" ] && . /etc/rc.d/init.d/functions
[ -z "$JAVA_HOME" -a -x /etc/profile.d/java.sh ] && . /etc/profile.d/java.sh


# the name of the project, will also be used for the war file, log file, ...
export PROJECT_NAME=springboot
# the user which should run the service
SERVICE_USER=root
# base directory for the spring boot jar
export SPRINGBOOTAPP_HOME=/usr/local/$PROJECT_NAME
# the spring boot jar-file
export SPRINGBOOTAPP_JAR="$SPRINGBOOTAPP_HOME/$PROJECT_NAME.jar"
# java executable for spring boot app, change if you have multiple jdks installed
export SPRINGBOOTAPP_JAVA=$JAVA_HOME/bin/java
# java or spring boot options
export JAVA_OPT=""
# spring boot pid-file
export PIDFILE=/var/run/$PROJECT_NAME/$PROJECT_NAME.pid
# killproc wait [sec]
KILL_WAIT_SEC=15

RETVAL=0

start() {
    [ -f "$PIDFILE" ] && echo "$PROJECT_NAME is already started" && return 0
    
    echo -n $"Starting $PROJECT_NAME: "

    # turn off history substitution
    set +H
    
    su $SERVICE_USER -c "cd \"$SPRINGBOOTAPP_HOME\"; \
 nohup \"$SPRINGBOOTAPP_JAVA\" $JAVA_OPT -jar \"$SPRINGBOOTAPP_JAR\" > /dev/null 2>&1 & \
 echo \$! > \"$PIDFILE\"; exit"

    # turn on again
    set -H

    RETVAL=$?
    [ $RETVAL = 0 ] && success $"$STRING" || failure $"$STRING"
    echo
}

stop() {
    [ ! -f "$PIDFILE" ] && echo "$PROJECT_NAME is already stopped" && return 0

    echo -n $"Stopping $PROJECT_NAME: "

    killproc -p "$PIDFILE" -d $KILL_WAIT_SEC "$PROJECT_NAME"
    RETVAL=$?
    echo
}

status() {
    if [ -f "$PIDFILE" ]; then 
        pid=`cat "$PIDFILE"`
        if checkpid $pid; then
            echo "$PROJECT_NAME (pid $pid) is running..."
            return 0
        else
            echo "$PROJECT_NAME is dead and pid file ($PIDFILE) exists"
            return 2
        fi
    fi
    echo "$PROJECT_NAME is stopped"
    return 3
}

# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit $RETVAL
