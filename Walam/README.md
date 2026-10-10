# Walam · back (Spring Boot)

API REST de EcoPay: autenticación JWT, cuentas, transacciones y usuarios sobre PostgreSQL. Visión general y modo "todo en contenedores": [README raíz](../README.md).

## Configurar y correr (desde `Walam/`)
1. **Configuración local** (los valores sirven tal cual):
   ```bash
   cp .env.example .env
   ```
   Resultado esperado: existe `Walam/.env` (lo lee spring-dotenv desde este directorio).
2. **DB** (desde la raíz del repo):
   ```bash
   docker compose up -d --wait
   ```
   Resultado esperado: `Container walam-db-1 Healthy`.
3. **Arrancar:**
   ```bash
   ./mvnw spring-boot:run
   ```
   Chequeo (otra terminal):
   ```bash
   curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/v3/api-docs
   ```
   Resultado esperado: `200`. Swagger: http://localhost:8080/swagger-ui/index.html.

## Comandos
| Para | Comando (desde `Walam/`) |
|---|---|
| Build + tests (gate del back) | `../scripts/verify.sh --server` |
| Build + tests a mano | `./mvnw -B clean verify` (con la DB arriba y `.env`) |
| Un test | `./mvnw -B test -Dtest=WalamApplicationTests#contextLoads` |
| Cobertura (sin tocar el pom) | `./mvnw -B clean org.jacoco:jacoco-maven-plugin:0.8.15:prepare-agent test org.jacoco:jacoco-maven-plugin:0.8.15:report` → `target/site/jacoco/index.html` |
| Imagen Docker | `docker build -t walam-server .` (la usa Render y el compose; ⚠️ en el bootstrap se verificó con el CA del proxy inyectado) |
| Windows | `mvnw.cmd` en lugar de `./mvnw` |

## Estructura
```
src/main/java/org/nocountry/walam/main/
  auth/        login/registro, JwtService, JwtAuthenticationFilter
  config/      SecurityConfig, CorsConfig, ApplicationConfig, GlobalExceptionHandler
  controller/  REST (users, transactions, cards, account) + requests
  email/       envío de mails (Thymeleaf en resources/templates/)
  googleauth/  2FA TOTP (código suelto, sin uso)
  model/       entity/, dto/, repository/, mapper/
  service/     interfaces + impl/
  utils/       generación de números de cuenta y tarjeta
src/main/resources/application.yaml
src/test/java/.../WalamApplicationTests.java
```
Instrucciones para agentes: [AGENTS.md](AGENTS.md).
