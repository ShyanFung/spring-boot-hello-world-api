FROM openjdk:8-jdk-alpine

LABEL developer="Shyan <shyan.fung@metronaviation.com>"

###############################################################################
# Container environment variables.
###############################################################################
ENV HOME "/home/app"

###############################################################################
# Java command run variables.
###############################################################################
ENV JAVA_CONTAINER_OPTS "-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
ENV JAVA_HEAP_OPTS "-Xms512m"
ENV JAVA_PERM_OPTS ""
ENV JAVA_GC1_OPTS "-XX:+UseParNewGC -XX:MaxTenuringThreshold=0"
ENV JAVA_GC2_OPTS "-XX:+UseTLAB -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:+UseStringCache"

###############################################################################
# Set app container's run profile (ie. dev,test,staging,development).
###############################################################################
ENV SPRING_APP_PROFILE="default"

###############################################################################
# Install curl to support possible health checks.
###############################################################################
RUN apk --update --no-cache add curl

###############################################################################
# Copy maven compiled spring-boot jar.
# TODO get from github, nexus or so built repo.
###############################################################################
COPY target/HelloWorld-*jar /tmp
RUN set -x && \
    mkdir $HOME && \
    cp /tmp/spring-boot-hello-world-*jar $HOME && \
    rm -fR /tmp/*

###############################################################################
# Generate run script.
###############################################################################
RUN echo "#!/bin/sh" >> $HOME/run.sh ; \
    echo "\
      java -server \$JAVA_CONTAINER_OPTS \$JAVA_HEAP_OPTS \$JAVA_PERM_OPTS \
      $JAVA_GC1_OPTS $JAVA_GC2_OPTS \
      -Duser.timezone=GMT -Dfile.encoding=UTF8 \
      -Dspring.profiles.active=\$SPRING_APP_PROFILE \
      -jar ./HelloWorld-*jar \
      " >> $HOME/run.sh && \
    chmod ug+x $HOME/run.sh

###############################################################################
# Set app user.
# - NOTE: Permission denied on ECS container when writing to /var/log; 
# - so keeping as non-app user for now. Docker4Mac does not do this.
###############################################################################
#RUN set -x && \
#    addgroup -S app && adduser -S -H -G app -h $HOME app && \
#    chown -R app:app $HOME && \
#    chown -h app:app $HOME
#USER app

###############################################################################
# Set working directory.
###############################################################################
WORKDIR $HOME

###############################################################################
# Mount properties volumes.
###############################################################################
VOLUME $HOME/config

###############################################################################
# Mount log volume.
###############################################################################
VOLUME $HOME/log

###############################################################################
# Expose app's default profile's default http port to map via docker, so it
# could be mapped to something else per deployment.
# - NOTE: The configured port might be overloaded within the app.properties
#   by server.port.
###############################################################################
EXPOSE 8080 8443

###############################################################################
# Set run script as container command.
###############################################################################
CMD ["/bin/sh", "-c", "$HOME/run.sh"]
