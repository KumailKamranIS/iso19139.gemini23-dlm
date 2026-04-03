############################################
# Stage 1 — Build GEMINI 2.3 schema plugin
############################################

FROM maven:3.9.14-eclipse-temurin-25 AS iso19139-gemini23-plugin-builder

WORKDIR /build

# copy only required files
COPY iso19139.gemini23/pom.xml .
COPY iso19139.gemini23/src ./src

# build plugin jar
RUN mvn clean package -DskipTests

############################################
# Stage 2 — Build GEMINI 2.3 dlm schema plugin
############################################

FROM maven:3.9.14-eclipse-temurin-25 AS iso19139-gemini23-dlm-plugin-builder

WORKDIR /build

# copy only required files
COPY iso19139.gemini23-dlm/pom.xml .
COPY iso19139.gemini23-dlm/src ./src

# build plugin jar
RUN mvn clean package -DskipTests

# ---------------------------- # Stage 1: GeoNetwork Runtime # ----------------------------
FROM geonetwork:4.2.14

# Switch to root temporarily for file operations
USER root

# ---------------------------- # Copy Schema Plugin Directories # ---------------------------

COPY iso19139.gemini23/src/main/plugin/iso19139.gemini23 \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.gemini23

COPY iso19139.gemini23-dlm/src/main/plugin/iso19139.gemini23-dlm \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.gemini23-dlm

# install compiled schema jar for the iso19139-gemini23 plugin
COPY --from=iso19139-gemini23-plugin-builder \
  /build/target/schema-iso19139.gemini23-4.2.14-0.jar \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/lib

# install compiled schema jar for the iso19139-gemini23-dlm plugin
COPY --from=iso19139-gemini23-dlm-plugin-builder \
  /build/target/schema-iso19139.gemini23-dlm-4.2.14-0.jar \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/lib

# ---------------------------- # Fix Permissions (CRITICAL) # ----------------------------
RUN chown -R jetty:jetty \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins \
  /var/lib/jetty/webapps/geonetwork/WEB-INF/lib

# Switch back to non-root user
USER jetty
