ARG NODE_VERSION
FROM node:${NODE_VERSION}-alpine

ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_BUILD_TIME
ARG ANGULAR_CLI_VERSION

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
    CI_BUILD_TIME=$CI_BUILD_TIME \
    ANGULAR_CLI_VERSION=$ANGULAR_CLI_VERSION

RUN apk add --update \
    xvfb \
    git \
    nano \
    openrc

#COPY xvfb.sh /etc/init.d/xvfb
#COPY entrypoint.sh /entrypoint.sh
#
#RUN chmod +x /etc/init.d/xvfb \
#    && chmod +x /entrypoint.sh

#ENV DISPLAY :99.0
#ENV CHROME_BIN /usr/bin/google-chrome

RUN npm install -g @angular/cli@$ANGULAR_CLI_VERSION

#ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /tmp/angular

EXPOSE 4200
