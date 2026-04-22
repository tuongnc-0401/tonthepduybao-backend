# AGENTS.md

## Project Overview

This repository is a Spring Boot 3.2 Java backend for "Tôn Thép Duy Bảo" CRM, focused on managing branches, customers, debts, invoices, products, properties, and users. The architecture is modular, with clear separation between controllers, services, repositories, entities, mappers, and security. Data is persisted in PostgreSQL, with MyBatis and JPA for data access. The project uses both annotation-based and configuration-based patterns.

## Key Architectural Patterns

- **Domain Structure:**
  - `controller/`: REST API endpoints, grouped by domain (e.g., UserController, BranchController).
  - `service/`: Business logic, typically one service per domain (e.g., UserService).
  - `repository/`: Data access, using Spring Data JPA and MyBatis. Repositories are named `<Domain>Repository.java`.
  - `entity/`: JPA entities, often matching database tables.
  - `model/`: DTOs and form objects for API input/output.
  - `mapper/`: MyBatis mappers for custom queries.
  - `security/`: Custom authentication, JWT, and role-based access control.

- **Configuration:**
  - Main config in `application.yaml`, with overrides in `application-dev.yaml` and `application-prod.yaml`.
  - Security config in `security/SecurityConfig.java`.
  - Logging via `logback-spring.xml` (logs to `/tmp/tonthepduybao-api/logs`).

- **Data Initialization:**
  - Mock data endpoints in `MockController` (protected by a hardcoded key).
  - Static data in `src/main/resources/static/` (e.g., `branch.json`, `customers.json`, `props.json`).
  - Database initialization for local/dev via `docker/init.sql` and `docker-compose.yml`.

## Developer Workflows

- **Build:**
  - Use `gradlew.bat clean build -x test` (Windows) or `./gradlew clean build -x test` (Linux/macOS).
  - The `deploy.sh` script automates build, pulls latest code, and restarts the app on port 7700 (Linux only).

- **Run:**
  - Main class: `TonthepduybaoApiApplication.java`.
  - Default profile is `prod` (see `application.yaml`). Override with `-Dspring.profiles.active=dev` for development.
  - Example: `java -jar -Dspring.profiles.active=dev build/libs/tonthepduybao-api-1.0.jar`

- **Database:**
  - Start PostgreSQL with `docker-compose up -d` in the `docker/` directory.
  - Credentials and DB name are set in `application-dev.yaml` and `application-prod.yaml`.

- **Testing:**
  - Tests are in `src/test/java/com/tonthepduybao/api/`.
  - Run with `gradlew.bat test` or `./gradlew test`.

## Project-Specific Conventions

- **API Prefix:** All endpoints are under `/ttdb/api/` (e.g., `/ttdb/api/user`).
- **Security:**
  - Most endpoints require authentication except `/ttdb/api/mock/**`, `/ttdb/api/auth/login`, `/ttdb/api/auth/reset-password`, and `/ttdb/api/branch/public/**`.
  - JWT-based stateless sessions.
- **Entity IDs:**
  - Some entities use UUIDs, others use numeric IDs. See `init.sql` for initial data and conventions.
- **Data Faker:**
  - `MockController` uses `net.datafaker.Faker` for generating test data.
- **Vietnamese Support:**
  - Custom `unaccent` function in `init.sql` for Vietnamese search.

## Integration Points

- **Email:** Configured via `spring.mail.*` in `application.yaml` (uses Gmail SMTP).
- **AWS S3:** AWS SDK dependencies included for S3 integration (see `build.gradle`).
- **Thymeleaf:** Used for server-side rendering (see `spring.thymeleaf.*` in config).

## Examples

- To add a new domain (e.g., Product):
  - Create `ProductController`, `ProductService`, `ProductRepository`, `Product.java` (entity), and optionally a MyBatis mapper.
  - Register endpoints under `/ttdb/api/product`.
- To mock data, call `/ttdb/api/mock/{key}` with the hardcoded key in `MockController`.

## Key Files/Directories

- `src/main/java/com/tonthepduybao/api/` — Main source code
- `src/main/resources/` — Config and static data
- `docker/` — Local database setup
- `build.gradle` — Dependencies
- `deploy.sh` — Build/deploy automation (Linux)

