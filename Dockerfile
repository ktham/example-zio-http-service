################################################################################
### Build Image
################################################################################
FROM eclipse-temurin:21-jdk as build-image

WORKDIR /scala-example-service

# Copy Build Tools
COPY .mill-version /scala-example-service/.mill-version
COPY mill /scala-example-service/mill
COPY build.mill /scala-example-service/build.mill

# Copy Source
COPY server /scala-example-service/server

# Build Jar
RUN ./mill show server.assembly

################################################################################
### Final Image
################################################################################
FROM eclipse-temurin:21-jre-alpine-3.21

# Ensure DNS lookups aren't indefinitely cached
RUN sed -i 's/#networkaddress.cache.ttl.*/networkaddress.cache.ttl=10/' /opt/java/openjdk/conf/security/java.security

# Create a non-root user
RUN addgroup -g 1000 -S appuser && adduser -u 1000 -S appuser -G appuser

WORKDIR /home/appuser

COPY --from=build-image /scala-example-service/out/server/assembly.dest/out.jar /home/appuser/server.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0","-jar","/home/appuser/server.jar"]
