# Walam (back) · específico para agentes
Leé primero el [AGENTS.md raíz](../AGENTS.md). Esto solo agrega lo del back.

- Corré todo desde `Walam/` (spring-dotenv lee `.env` del directorio de trabajo). Gate: `../scripts/verify.sh --server`.
- Los tests de hoy necesitan la DB del compose (`docker compose up -d --wait` desde la raíz) hasta que T-006 agregue Testcontainers.
- Referencias por capa: controller `controller/TransactionController.java` · servicio `service/impl/TransactionServiceImpl.java` · entidad `model/entity/Account.java` · DTO `model/dto/UserDTO.java` · repo `model/repository/AccountRepository.java` · request validado `controller/WithdrawOrDepositRequest.java`.
- Inyección: preferí `@RequiredArgsConstructor` + `private final` (hay `@Autowired` en campos heredado; no lo copies).
- **Zona 🧠:** `config/SecurityConfig.java`, `config/CorsConfig.java`, `auth/**`, entidades (`model/entity/**`), `application.yaml`, `pom.xml`, `Dockerfile`. Si tu tarea 🤖 necesita tocarlos y no lo dice explícitamente: escalá.
- Nunca devuelvas entidades JPA desde un controller nuevo: usá DTOs (las entidades arrastran `password`).
- No copies valores de `JwtService.java:25`, `EmailConfig.java` ni `application.yaml:34-35` a ningún lado (secretos; T-001).
- Archivos grandes para leer por rangos: `controller/UserController.java` (183 líneas), `service/impl/UserServiceImpl.java` (171).
