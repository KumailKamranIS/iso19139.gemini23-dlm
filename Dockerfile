############################################
# Stage 1 — Build GEMINI schema plugin
############################################

FROM maven:3.9.14-eclipse-temurin-25 AS plugin-builder

WORKDIR /build

# copy only required files
COPY pom.xml .
COPY src ./src

# build plugin jar
RUN mvn clean package -DskipTests

# ---------------------------- # Stage 1: GeoNetwork Runtime # ----------------------------
FROM geonetwork:4.2.14

# Switch to root temporarily for file operations
USER root

# ---------------------------- # Copy Schema Plugin Directory # ----------------------------
COPY src/main/plugin/iso19139.gemini23-dlm \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.gemini23-dlm

# install compiled schema jar
COPY --from=plugin-builder \
  /build/target/schema-iso19139.gemini23-dlm-4.2.14-0.jar \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/lib

# ---------------------------- # Fix Permissions (CRITICAL) # ----------------------------
RUN chown -R jetty:jetty \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/lib

# Switch back to non-root user
USER jetty
