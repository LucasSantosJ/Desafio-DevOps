# Estágio 1: Build (Compilação)
# Use uma imagem Maven com OpenJDK 21 (Alpine)
FROM maven:3-eclipse-temurin-21-alpine AS builder

WORKDIR /app

# Copie o pom.xml e baixe as dependências
COPY pom.xml .
RUN mvn dependency:go-offline

# Copie o código-fonte e compile o projeto
COPY src ./src
RUN mvn clean package -DskipTests

# Estágio 2: Run (Execução)
# Use uma imagem Alpine com JRE 21
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copie o artefato .jar do estágio de build
COPY --from=builder /app/target/*.jar app.jar

# Exponha a porta que o Spring Boot usa
EXPOSE 8080

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]