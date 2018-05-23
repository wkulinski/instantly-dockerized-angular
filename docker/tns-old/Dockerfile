FROM runmymind/docker-android-sdk:alpine-standalone

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN sdkmanager --update && yes | sdkmanager --licenses

# Use sdkmanager --list to list packages
RUN sdkmanager "tools"
RUN sdkmanager "platform-tools"
RUN sdkmanager "platforms;android-27"
RUN sdkmanager "build-tools;27.0.3"
RUN sdkmanager "extras;android;m2repository"
RUN sdkmanager "extras;google;m2repository"
RUN sdkmanager "system-images;android-27;google_apis;x86"
RUN sdkmanager "extras;google;instantapps"
RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"
RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"

RUN echo 'no' | avdmanager create avd --force --name testAVD --abi google_apis/x86 --package "system-images;android-27;google_apis;x86" | echo 'no'

ARG NODE_VERSION
ARG NATIVESCRIPT_CLI_VERSION

# NodeJS
RUN apk update && apk add --update nodejs nodejs-npm

# NativeScript
RUN npm install -g nativescript@$NATIVESCRIPT_CLI_VERSION  --unsafe-perm \
    && tns usage-reporting disable \
    && tns error-reporting disable

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

#VOLUME ["/app","/dist"]

#CMD ["/docker-entrypoint.sh"]

WORKDIR /tmp/nativescript

#FROM kristophjunge/nativescript
#
#USER root
#RUN apt-get update && apt-get install -y git --no-install-recommends && rm -r /var/lib/apt/lists/*

#RUN npm install npm@latest -g

#USER nativescript

#FROM ubuntu:latest
##MAINTAINER Kristoph Junge <kristoph.junge@gmail.com>
#
#RUN useradd -ms /bin/bash nativescript
#
#COPY docker-entrypoint.sh /docker-entrypoint.sh
#
## Utilities
#RUN apt-get update && \
#    apt-get -y install apt-transport-https unzip curl usbutils git --no-install-recommends && \
#    rm -r /var/lib/apt/lists/*
#
## JAVA
#RUN apt-get update && \
#    apt-get -y install default-jdk --no-install-recommends && \
#    rm -r /var/lib/apt/lists/*
#
## NodeJS
#RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
#    apt-get update && \
#    apt-get -y install nodejs --no-install-recommends && \
#    rm -r /var/lib/apt/lists/*
#
## NativeScript
#RUN npm install -g nativescript && \
#    tns error-reporting disable
#
## Android build requirements
#RUN apt-get update && \
#    apt-get -y install lib32stdc++6 lib32z1 --no-install-recommends && \
#    rm -r /var/lib/apt/lists/*
#
## Android SDK
#ARG ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip"
#ARG ANDROID_SYSTEM_PACKAGE="android-25"
#ARG ANDROID_BUILD_TOOLS_PACKAGE="build-tools-25.0.2"
#ARG ANDROID_PACKAGES="platform-tools,$ANDROID_SYSTEM_PACKAGE,$ANDROID_BUILD_TOOLS_PACKAGE,extra-android-m2repository,extra-google-m2repository"
#ADD $ANDROID_SDK_URL /tmp/android-sdk.zip
#RUN mkdir /opt/android-sdk /app /dist && \
#    chown nativescript:nativescript /tmp/android-sdk.zip /opt/android-sdk /app /dist
#USER nativescript
#ENV ANDROID_HOME /opt/android-sdk
#ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
#RUN tns error-reporting disable && \
#    unzip -q /tmp/android-sdk.zip -d /opt/android-sdk && \
#    rm /tmp/android-sdk.zip && \
#    echo "y" | /opt/android-sdk/tools/android --silent update sdk -a -u -t $ANDROID_PACKAGES
## Self-update of 'tools' package is currently not working?
##RUN echo "y" | /opt/android-sdk/tools/android --silent update sdk -a -u -t tools


#FROM runmymind/docker-android-sdk:alpine-standalone


#ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
#
##ARG NODE_VERSION=8
##ARG TYPESCRIPT_CLI_VERSION=latest
##
##FROM node:$NODE_VERSION
#
#COPY docker-entrypoint.sh /docker-entrypoint.sh
#RUN chmod +x /docker-entrypoint.sh
#
## NodeJS
##RUN apk update && apk add --update nodejs-current nodejs-npm
##
##RUN node -v
##RUN npm -v
#
##RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
##    apt-get update && \
##    apt-get -y install nodejs --no-install-recommends && \
##    rm -r /var/lib/apt/lists/*
#
##RUN npm install npm@latest -g
##RUN npm update -g
#
## NativeScript
#RUN npm install nativescript@latest -g --unsafe-perm
##RUN npm install -g nativescript && \
##    tns error-reporting disable
#
#VOLUME ["/app","/dist"]
#
#WORKDIR /app
#
#CMD ["/docker-entrypoint.sh"]

