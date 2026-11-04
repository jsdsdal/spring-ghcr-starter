FROM maven:3.9.12-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml .
# This step is to cache dependencies
# Rettelse - kendt bug i JDK på visse VM -> https://bugs.openjdk.org/browse/JDK-8353670
ENV MAVEN_OPTS="-XX:+UnlockDiagnosticVMOptions -XX:-UseIntPolyIntrinsics"
RUN mvn dependency:resolve

COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
