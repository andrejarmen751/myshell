ARG  DOCKER_REGISTRY_CACHE
ARG IMATGE_MAVEN
FROM $DOCKER_REGISTRY_CACHE/$IMATGE_MAVEN
RUN mkdir -p /usr/src/dependencies
RUN mkdir -p ~/.m2/
WORKDIR /usr/src/dependencies
RUN cp -rfv /usr/share/zoneinfo/Europe/Madrid /etc/localtime && ls -la /etc/localtime
COPY env/pom.xml /usr/src/dependencies
#COPY env/settings.xml ~/.m2/settings.xml
COPY env/settings.xml /usr/share/maven/conf/settings.xml
RUN mvn install
#COPY Docker/docker-entrypoint.bash /docker-entrypoint.bash
#CMD [ "/docker-entrypoint.bash" ]