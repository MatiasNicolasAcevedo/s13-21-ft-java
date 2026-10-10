# T-002 · Lock down API authorization and stop leaking sensitive data
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-002-lock-down-api` (desde `develop` actualizado) · Depende de: — (va después de T-001 en la cola) · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
🔴 `.requestMatchers("/api/**").permitAll()` (`config/SecurityConfig.java:44`): sin token, `GET /api/v1/users-all`, `/user/{id}`, `/transactions`, `/transaction/{id}` devuelven hashes BCrypt, emails, saldos y CVU (probes de la auditoría §4). `/error` bloqueado → todo error es 403. CORS `*` (`CorsConfig.java:75`), headers deshabilitados (`SecurityConfig.java:55`), `/h2-console/**` permitido.

## Objetivo
Solo `/auth/**`, `/v3/api-docs/**`, `/swagger-ui/**` y `/error` son públicos; ninguna respuesta incluye `password`; los errores devuelven el código correcto.

## Alcance
- Incluye: reglas de autorización explícitas (idea rescatable de la rama `matias/api-run`: lista de endpoints públicos); `/error` permitido; 401 para no autenticado (entry point) y 403 para prohibido; `@JsonIgnore`/DTO para que `password` y `authorities` nunca se serialicen (`User.java`, `UserDTO.java:40`); `/transactions` y `/transaction/{id}` limitados a las del usuario logueado (o eliminados `users-all`/`user/{id}` si no los usa el front — ver ARCHITECTURE); CORS por propiedad `CORS_ALLOWED_ORIGINS` (default local `http://localhost:5173`) con su `.example`; quitar `/h2-console/**` y reactivar headers por defecto; agregar `spring-security-test`.
- **No incluye:** `ProblemDetail` global (Backlog P0), cambiar rutas (`/api/v1/...` se mantienen: el front depende de ellas), refresh tokens, roles ADMIN.

## Leer antes
- `config/SecurityConfig.java` · `config/CorsConfig.java` · `controller/UserController.java:20-45` · `controller/TransactionController.java` · `model/dto/UserDTO.java` · auditoría §4 (tabla de probes).

## Archivos previstos
- modificar: `SecurityConfig.java`, `CorsConfig.java`, `UserController.java`, `TransactionController.java`, `TransactionServiceImpl.java`, `UserDTO.java`, `User.java`, `pom.xml` (test dep), `application.yaml`, `Walam/.env.example`, `docker-compose.yml`, `docs/SETUP.md`, `docs/ARCHITECTURE.md` · crear: `src/test/java/.../security/ApiSecurityIntegrationTest.java`.

## Tests (bugfix: primero fallan)
- `@SpringBootTest` + `MockMvc` (DB del compose hasta T-006): sin token → 401 en `users-all`, `user/1`, `transactions`, `transaction/1`, `deposit`; token inválido → 401; con token → 200 en `/users` y el JSON **no** contiene `password`; `transaction/{id}` de otro usuario → 403/404; JSON inválido en login → 400; login con password incorrecta y con usuario inexistente → 401 con el mismo cuerpo.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa con los tests nuevos
- [ ] `curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/api/v1/users-all` → `401`
- [ ] `curl -s http://localhost:8080/api/v1/users -H "Authorization: Bearer <token>" | grep -c password` → `0`
- [ ] El flujo del front (login → dashboard → depósito) sigue funcionando contra el back local (si T-004 aún no está, probar con curl)
- [ ] Tabla de probes de la auditoría re-ejecutada y pegada en el PR con obtenido vs. esperado

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
