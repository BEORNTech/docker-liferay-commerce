FROM mdelapenya/jdk:8-openjdk
MAINTAINER Boubker Tagnaouti <boubker.tagnaouti@beorntech.com>

RUN apt-get update \
  && apt-get install -y curl telnet tree \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && useradd -ms /bin/bash liferay

ENV LIFERAY_HOME=/liferay
ENV LIFERAY_SHARED=/storage/liferay
ENV LIFERAY_CONFIG_DIR=/tmp/liferay/configs
ENV LIFERAY_DEPLOY_DIR=/tmp/liferay/deploy
ENV CATALINA_HOME=$LIFERAY_HOME/tomcat-9.0.6
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV LIFERAY_TOMCAT_URL=https://sourceforge.net/projects/lportal/files/Liferay%20Portal/7.1.0%20RC1/liferay-ce-portal-tomcat-7.1-rc1-20180626164228923.zip/download
ENV LIFERAY_COMMERCE_URL=https://s3.us-east-2.amazonaws.com/beorn-liferay/liferay-commerce-7.1.zip
ENV GOSU_VERSION 1.10
ENV GOSU_URL=https://github.com/tianon/gosu/releases/download/$GOSU_VERSION

WORKDIR $LIFERAY_HOME

RUN mkdir -p "$LIFERAY_HOME" \
      && set -x \
      && curl -fSL "$LIFERAY_TOMCAT_URL" -o /tmp/liferay-ce-portal-tomcat-7.1-rc1-20180626164228923.zip \
      && unzip /tmp/liferay-ce-portal-tomcat-7.1-rc1-20180626164228923.zip -d /tmp/liferay \
      && mv /tmp/liferay/liferay-ce-portal-7.1-rc1/* $LIFERAY_HOME/ \
      && rm /tmp/liferay-ce-portal-tomcat-7.1-rc1-20180626164228923.zip \
      && rm -fr /tmp/liferay/liferay-ce-portal-7.1-rc1 \
      && mkdir -p "$LIFERAY_DEPLOY_DIR" \
      && mkdir -p "$LIFERAY_CONFIG_DIR/osgi" \
      && echo "module.framework.properties.lpkg.index.validator.enabled=false" >> "$LIFERAY_CONFIG_DIR/portal-ext.properties" \
      && curl -fSL "$LIFERAY_COMMERCE_URL" -o /tmp/liferay-commerce-7.1.zip \
      && unzip /tmp/liferay-commerce-7.1.zip -d /tmp/liferay-commerce \
      && mv /tmp/liferay-commerce/liferay-commerce-7.1/modules/* $LIFERAY_DEPLOY_DIR/ \
      && mv /tmp/liferay-commerce/liferay-commerce-7.1/war/* $LIFERAY_DEPLOY_DIR/ \
      && mv /tmp/liferay-commerce/liferay-commerce-7.1/configs/* $LIFERAY_CONFIG_DIR/osgi/ \
      && rm /tmp/liferay-commerce-7.1.zip \
      && rm -fr /tmp/liferay-commerce \
      && chown -R liferay:liferay $LIFERAY_HOME \
      && wget -O /usr/local/bin/gosu "$GOSU_URL/gosu-$(dpkg --print-architecture)" \
      && wget -O /usr/local/bin/gosu.asc "$GOSU_URL/gosu-$(dpkg --print-architecture).asc" \
      && export GNUPGHOME="$(mktemp -d)" \
      && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
      && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
      && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
      && chmod +x /usr/local/bin/gosu \
      && gosu nobody true

COPY ./configs/setenv.sh $CATALINA_HOME/bin/setenv.sh
COPY ./entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x $CATALINA_HOME/bin/catalina.sh

EXPOSE 8080/tcp
EXPOSE 9000/tcp
EXPOSE 11311/tcp

VOLUME /storage

ENTRYPOINT ["entrypoint.sh"]
CMD ["catalina.sh", "run"]