FROM maven:3.9.11-eclipse-temurin-17 AS plugin-builder

WORKDIR /build

COPY src/main/resources ./src/main/resources
COPY src/main/plugin/iso19139.gemini23 ./src/main/plugin/iso19139.gemini23
COPY src/main/config/translations/en-schema-iso19139.gemini23.json ./src/main/config/translations/en-schema-iso19139.gemini23.json

RUN cat > pom.xml <<'POM'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.geonetwork-opensource.schemas</groupId>
  <artifactId>schema-iso19139.gemini23</artifactId>
  <version>4.2.4-SNAPSHOT</version>
  <packaging>jar</packaging>

  <build>
    <resources>
      <resource>
        <directory>src/main/config/translations</directory>
        <targetPath>META-INF/catalog/locales</targetPath>
      </resource>
      <resource>
        <directory>src/main/resources</directory>
      </resource>
      <resource>
        <directory>src/main/plugin</directory>
        <targetPath>plugin</targetPath>
      </resource>
    </resources>
  </build>
</project>
POM

RUN mvn -B -DskipTests package

FROM scratch AS plugin-jar-export

COPY --from=plugin-builder /build/target/schema-iso19139.gemini23-4.2.4-SNAPSHOT.jar /schema-iso19139.gemini23-4.2.4-SNAPSHOT.jar

FROM geonetwork:4.2

USER root

COPY --chown=jetty:jetty --from=plugin-builder /build/target/schema-iso19139.gemini23-4.2.4-SNAPSHOT.jar /var/lib/jetty/webapps/geonetwork/WEB-INF/lib/schema-iso19139.gemini23-4.2.4-SNAPSHOT.jar
COPY --chown=jetty:jetty src/main/plugin/iso19139.gemini23 /var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.gemini23
COPY --chown=jetty:jetty src/main/config/translations/en-schema-iso19139.gemini23.json /var/lib/jetty/webapps/geonetwork/WEB-INF/classes/META-INF/catalog/locales/en-schema-iso19139.gemini23.json

USER jetty
