# Tablero
> Reglas: **una tarea a la vez** (máx. 1 PR de tarea abierto) · "Listas" es la **cola en orden de ejecución**: se toma siempre la primera ·
> si la primera no te corresponde (🧠 o 👤), no saltees a la siguiente: avisá con el formato de "Traspasos" y terminá ·
> las 👤 que no bloquean nada van al final de "Listas" con "(no bloquea la cola)" ·
> formato: `- T-NNN · Pn · S/M/L · 🤖 Lite|🧠 frontera|👤 dueño · Título → [tarea](tasks/T-NNN-slug.md)`
> Próximo ID libre: T-019

**Leyenda:** 🧠 Frontera (p. ej. GPT 6.1 Sol u Opus 5.5, según disponibilidad) · 🤖 Junie Lite (Free, JetBrains Air) · 👤 dueño.

> **👉 Paso inmediato:** revisar PR #2 de T-018 · **🧠 Frontera** (sesión nueva), luego 👤 merge.
> **▶ Siguiente implementación después de ese merge:** **T-001 · 🧠 Frontera**.
> **🤖 Primer paso para Lite:** **T-003**, después del merge de T-002; traspaso con prompt completo obligatorio.
> La primera de Listas se toma cuando no hay PR abierto. Los cierres posteriores al merge se registran al inicio de la siguiente tarea, en su nueva rama.

## 🔨 En curso / en revisión (con su PR)
- T-018 · P0 · M · 🧠 frontera · Clarify agent roles and session handoffs → [tarea](tasks/T-018-agent-workflow.md) · [PR #2](https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/pull/2) (En revisión; pedido documental del dueño antes de T-001)

## ✅ Listas (cola en orden de ejecución, máx. 10)
1. T-001 · P0 · M · 🧠 frontera · Move hardcoded secrets to environment configuration → [tarea](tasks/T-001-externalize-secrets.md)
2. T-002 · P0 · M · 🧠 frontera · Lock down API authorization and stop leaking sensitive data → [tarea](tasks/T-002-lock-down-api.md)
3. T-003 · P0 · S · 🤖 Lite · Fix frontend lint errors so verify passes → [tarea](tasks/T-003-fix-frontend-lint.md)
4. T-004 · P0 · M · 🤖 Lite · Read the API base URL from VITE_API_URL (part 1) → [tarea](tasks/T-004-api-base-url-from-env.md)
5. T-017 · P0 · S · 🤖 Lite · Use the shared API client in the remaining screens (part 2) → [tarea](tasks/T-017-api-client-remaining-screens.md)
6. T-005 · P0 · S · 🤖 Lite · Remove unused frontend dependencies → [tarea](tasks/T-005-remove-unused-frontend-deps.md)
7. T-006 · P0 · M · 🧠 frontera · Set up backend test infrastructure (JaCoCo + Testcontainers) → [tarea](tasks/T-006-backend-test-infra.md)
8. T-008 · P0 · M · 🧠 frontera · Set up frontend test infrastructure (Vitest + RTL + MSW) → [tarea](tasks/T-008-frontend-test-infra.md)
9. T-015 · P0 · S · 👤 dueño · Rotate the credentials leaked in the repository (no bloquea la cola · **pasos 1–2 hacelos ya**) → [tarea](tasks/T-015-rotate-leaked-credentials.md)
10. T-016 · P0 · S · 👤 dueño · Protect the default branch and clean up branches (no bloquea la cola) → [tarea](tasks/T-016-protect-default-branch.md)

## ⛔ Bloqueadas (en el orden en que entrarán a la cola)
- T-007 · P0 · S · 🧠 frontera · Add CI workflow running verify on every PR · bloqueada por: T-003 y T-006 (entra **antes de T-008** si este no empezó) → [tarea](tasks/T-007-ci-workflow.md)
- T-009 · P0 · M · 🤖 Lite · Add characterization tests for deposit, withdraw and transfer · bloqueada por: T-006 → [tarea](tasks/T-009-transaction-characterization-tests.md)
- T-010 · P0 · S · 🤖 Lite · Add characterization tests for registration and login · bloqueada por: T-006 → [tarea](tasks/T-010-auth-characterization-tests.md)
- T-012 · P0 · S · 🤖 Lite · Protect private routes and clear the session on logout · bloqueada por: T-008 → [tarea](tasks/T-012-protected-routes-and-logout.md)
- T-013 · P0 · S · 🧠 frontera · Enable Dependabot · bloqueada por: T-007 → [tarea](tasks/T-013-dependabot.md)
- T-011 · P0 · M · 🧠 frontera · Replace ddl-auto=create with Flyway migrations · bloqueada por: T-009, T-010 → [tarea](tasks/T-011-flyway-baseline.md)
- T-014 · P0 · M · 🧠 frontera · Set up Playwright E2E smoke tests · bloqueada por: T-007, T-008, T-017 → [tarea](tasks/T-014-e2e-infra.md)

## 📥 Backlog (sin refinar)
### P0 Estabilizar
- 🤖 Externalizar la config de Firebase a `VITE_FIREBASE_*` con su `.example` (`firebase.js:9-17`)
- 🤖 Quitar el estado mutable `userDetails` de `AuthService` (`AuthService.java:35`) con test
- 🤖 Validar `RegisterRequest` (`@Valid`, `@NotBlank`, `@Email`) y devolver 409 si el usuario existe
- 🧠 Errores con `ProblemDetail` en `GlobalExceptionHandler` (404 de transacción inexistente, 409, 400 de JSON inválido)
- 🧠 Usuario demo seed para el perfil local (hoy lo crea `scripts/dev.sh` por API)
- 🤖 `docker-compose.yml:6` fija `name: walam`: documentar en SETUP que dos clones comparten contenedores/volumen (o usar `COMPOSE_PROJECT_NAME`)
### P1 Actualizar
- 🤖 Fijar las GitHub Actions a SHA en vez de tags móviles (`.github/workflows/pr-title.yml:17`), junto con T-013
- 🧠 Spring Boot 3.2 → 3.5 con OpenRewrite ([ADR 0002](adr/0002-upgrade-path.md)), luego Java 21 y Boot 4 (tareas separadas)
- 🧠 Node 24 + Vite 8 + React 19 + ESLint flat config (un paso por PR)
- 🤖 `npm audit fix` sin `--force` y revisar lo que quede
- 🤖 `SecureRandom` para número de cuenta, CVU, alias y tarjeta (`AuthService.java:120`, `UtilsCard.java:8,18`)
- 🤖 Actualizar Maven Wrapper a 3.3.x / Maven 3.9.16
### P2 Terminar
- 🧠 Spec: recuperar contraseña (pantalla sin API; `/send-email/recovery-data` a medias)
- 🧠 ADR: login con Google (Firebase) y 2FA TOTP (`googleauth/`): integrar o quitar
- 🧠 Dinero en `BigDecimal` + migración Flyway (`Account.java:31`, `Transaction.java:26`)
- 🧠 Servicios sin `ResponseEntity` ni `SecurityContextHolder` (`TransactionServiceImpl.java`)
- 🧠 Decidir Redux (configurado y sin uso) vs Context
- 🤖 Quitar código muerto: `GoogleMainApplication`, `AccountController` de prueba, `DemoController`, `db/tasks.json`
- 🤖 Reemplazar `System.out.println` (8) y `console.log` (14) por logging/nada
- 🧠 Paginación de transacciones; pantalla de divisas con API real o quitarla; tickets de soporte
- 🧠 Rescatar de `matias/api-run` el `OpenAPI` info (título "Ecopay", versión, licencia)
### P3 Pulir
- 🤖 Sin scroll horizontal en `/` (375 px) y `/DashboardUser` (1280 px)
- 🤖 Un `h1` por página y labels en todos los inputs
- 🧠 Spotless/Checkstyle en el back; Prettier en el front
- 👤 Licencia (MIT sugerida), demo online verificada, capturas y GIF nuevos, badges

## 🏁 Hecho reciente (máx. 10)
- T-000 · P0 · L · 🧠 frontera · Bootstrap the agent harness and audit the project → [tarea](tasks/T-000-agent-bootstrap.md) · PR #1 (mergeado 2026-10-10)
