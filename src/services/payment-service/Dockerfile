FROM maven:3.8.1-openjdk-17-slim AS build
WORKDIR /workdir
COPY .mvn /workdir/.mvn
COPY mvnw /workdir/mvnw
COPY pom.xml /workdir/pom.xml
COPY src /workdir/src
RUN unset MAVEN_CONFIG
ENV MAVEN_CONFIG= 
RUN /workdir/mvnw dependency:go-offline
RUN /bin/bash /workdir/mvnw package -DskipTests

FROM openjdk:8-jdk-alpine
WORKDIR /workdir
RUN apk add --no-cache bash
COPY wait-for-it.sh /workdir/wait-for-it.sh
COPY --from=build /workdir/target/payment-session-0.0.1-SNAPSHOT.jar /workdir/target/payment-session-0.0.1-SNAPSHOT.jar
ENV POSTGRES_HOST=database
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=payments_db
RUN chmod +x wait-for-it.sh
EXPOSE 8084

CMD ["./wait-for-it.sh", "database:5432", "-s", "-t", "0", "--", "java", "-jar", "target/payment-session-0.0.1-SNAPSHOT.jar"]