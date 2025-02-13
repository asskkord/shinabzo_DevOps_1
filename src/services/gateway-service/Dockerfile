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
COPY --from=build /workdir/target/gateway-service-0.0.1-SNAPSHOT.jar /workdir/target/gateway-service-0.0.1-SNAPSHOT.jar
ENV SESSION_SERVICE_HOST=session-service
ENV SESSION_SERVICE_PORT=8081
ENV HOTEL_SERVICE_HOST=hotel-service
ENV HOTEL_SERVICE_PORT=8082
ENV BOOKING_SERVICE_HOST=booking-service
ENV BOOKING_SERVICE_PORT=8083
ENV PAYMENT_SERVICE_HOST=payment-service
ENV PAYMENT_SERVICE_PORT=8084
ENV LOYALTY_SERVICE_HOST=loyalty-service
ENV LOYALTY_SERVICE_PORT=8085
ENV REPORT_SERVICE_HOST=report-service
ENV REPORT_SERVICE_PORT=8086
RUN chmod +x wait-for-it.sh
EXPOSE 8087

CMD ["./wait-for-it.sh", "database:5432", "-s", "-t", "0", "--", "java", "-jar", "target/gateway-service-0.0.1-SNAPSHOT.jar"]