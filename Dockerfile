# Use a Maven base image for building the project
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN mvn clean install -DskipTests

# Use the Eclipse Temurin Java 17 image for the runtime environment
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
# Copy only the built JAR from the build stage
COPY --from=build /app/target/*.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
