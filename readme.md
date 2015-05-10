Spring Boot init.d script
=========================

This script is meant to run a **Spring Boot 1.2** project as a linux service using initd. 
It is meant as a template that can be reconfigured to an arbitrary war file. 

**New feature will be added on Spring Boot 1.3 for this purpose.**
http://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/html/deployment-service.html

Use the variable names at the top of the script to customize to your specific project.

This file is known to work with CentOS, however, will not work yet for Ubuntu (due to the differences in `/etc/init.d/functions`).

Parameter | Description | Default Value
----------| ----------- | ----------
`PROJECT_NAME` | the name of the project, will also be used for the war file, log file, ... | `springboot`
`SERVICE_USER` | the user which should run the service | `root`
`SPRINGBOOTAPP_HOME` | base directory for the spring boot jar |  `/usr/local/$PROJECT_NAME`
`SPRINGBOOTAPP_JAR` | the jar/war file to start via `java -jar` | `$SPRINGBOOTAPP_HOME/$PROJECT_NAME.jar`
`SPRINGBOOTAPP_JAVA` | java executable for spring boot app, change if you have multiple jdks installed | `$JAVA_HOME/bin/java`
`JAVA_OPT` | java or spring boot options | `(blank)`
`PIDFILE` | spring boot pid-file | `/var/run/$PROJECT_NAME/$PROJECT_NAME.pid`
`KILL_WAIT_SEC` | killproc wait [sec] | `15`

