FROM openjdk:8-jdk-alpine
EXPOSE 8080
ENV access_token=gn@ajFM*<}a!x9fq
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]