FROM runmymind/docker-android-sdk:ubuntu-standalone

ENV PATH $PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

RUN sdkmanager --update && yes | sdkmanager --licenses

# Use sdkmanager --list to list packages
RUN sdkmanager "tools"
RUN sdkmanager "platform-tools"
RUN sdkmanager "platforms;android-27"
RUN sdkmanager "build-tools;27.0.3"
RUN sdkmanager "extras;android;m2repository"
RUN sdkmanager "extras;google;m2repository"
RUN sdkmanager "system-images;android-27;google_apis;x86"
#RUN sdkmanager "extras;google;instantapps"
#RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"
#RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"

RUN echo 'no' | avdmanager create avd --force --name testAVD --abi google_apis/x86 --package "system-images;android-27;google_apis;x86" | echo 'no'

ARG NODE_VERSION
ARG NATIVESCRIPT_CLI_VERSION

# NodeJS
RUN apt-get update && apt-get upgrade -y && apt-get install -y nodejs npm

# NativeScript
RUN npm install -g nativescript@$NATIVESCRIPT_CLI_VERSION  --unsafe-perm \
    && tns usage-reporting disable \
    && tns error-reporting disable

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

#VOLUME ["/app","/dist"]

CMD ["/docker-entrypoint.sh"]

WORKDIR /tmp/nativescript
