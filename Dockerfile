FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y update  && DEBIAN_FRONTEND=noninteractive apt-get -y install libapr1 wget lynx openjdk-11-jre-headless && apt-get clean

ENV tomcat_ver=$(lynx -dump https://apache.uib.no/tomcat/tomcat-9/|grep "apache.uib.no/tomcat/tomcat-9/v9" | sed 's/.*tomcat-9\/v9/9/' | sed 's/\/$//' | sort -n -k 1,1 -k 2,2 -k 3,3 -t . |tail -1)

RUN useradd -m -s /bin/bash tomcat
RUN mkdir -p /tomcat && chown tomcat /tomcat 
RUN cd /tomcat && wget https://apache.uib.no/tomcat/tomcat-9/v$tomcat_ver/bin/apache-tomcat-$tomcat_ver.tar.gz && tar xzf apache-tomcat-$tomcat_ver.tar.gz && rm -f apache-tomcat-$tomcat_ver.tar.gz

RUN ln -s /tomcat/apache-tomcat-$tomcat_ver/ /tomcat/tomcat
RUN cd /tomcat/tomcat && chgrp -R tomcat bin conf lib && chown -R tomcat logs temp webapps work &&  chmod -R g+rx conf
RUN chown -R tomcat /tomcat/tomcat/conf/

USER tomcat

EXPOSE 8080 

CMD /tomcat/tomcat/bin/catalina.sh run -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=true run
