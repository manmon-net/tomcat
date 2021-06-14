FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y update  && DEBIAN_FRONTEND=noninteractive apt-get -y install wget openjdk-11-jre-headless && apt-get clean
RUN useradd -m -s /bin/bash tomcat
RUN mkdir -p /tomcat && chown tomcat /tomcat 
RUN cd /tomcat && wget https://apache.uib.no/tomcat/tomcat-9/v9.0.46/bin/apache-tomcat-9.0.46.tar.gz && tar xzf apache-tomcat-9.0.46.tar.gz && rm -f apache-tomcat-9.0.46.tar.gz

RUN ln -s /tomcat/apache-tomcat-9.0.46/ /tomcat/tomcat
RUN cd /tomcat/tomcat && chgrp -R tomcat bin conf lib && chown -R tomcat logs temp webapps work &&  chmod -R g+rx conf
RUN chown -R tomcat /tomcat/tomcat/conf/

USER tomcat

EXPOSE 8080 

CMD /tomcat/tomcat/bin/catalina.sh run -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=true run
