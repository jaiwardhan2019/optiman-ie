# Spring Boot JSP + PostgreSQL + JPA + BCrypt sample

## Prerequisites
- Java 17+
- Maven 3.9+
- PostgreSQL running locally

## Database setup
Create DB:

```sql
CREATE DATABASE gpdoc_sample;
```

Default DB credentials are in `src/main/resources/application.yml`:
- username: `postgres`
- password: `postgres`

You can change as needed.

## Run
From this module folder:

```bash
mvn spring-boot:run
```

Open:
- http://localhost:8080/login

## Sample user
- username: `demo`
- password: `password123`

The sample row is inserted from `schema.sql` with a BCrypt hash.
