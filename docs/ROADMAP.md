# Roadmap

Una tarea a la vez, en el orden de [BACKLOG.md](BACKLOG.md). Cada fase cierra con un tag `v0.x.0` ([CONTRIBUTING §7](../CONTRIBUTING.md)).

## P0 · Estabilizar → `v0.1.0`
**Objetivo:** seguro, verificable y levantable por cualquiera.
**Criterio de salida (verificable):**
- [ ] `git grep` no encuentra los secretos de la auditoría en el árbol actual y fueron rotados (T-001, T-015).
- [ ] Sin token, `GET /api/v1/users-all` y `/api/v1/transactions` devuelven 401; ninguna respuesta incluye `password` (T-002).
- [ ] `./scripts/verify.sh` en verde en `develop` y **CI en verde** (T-003, T-007).
- [ ] El front local habla con el back local (`VITE_API_URL`) (T-004).
- [ ] README verificado de punta a punta en ambos modos, sin ⚠️.
- [ ] Infra de tests back (JaCoCo con umbral + Testcontainers), front (Vitest+RTL+MSW) y E2E smoke (T-006, T-008, T-014).
- [ ] Flujos críticos 1–6 de la auditoría caracterizados (T-009, T-010).
- [ ] Esquema con Flyway, sin `ddl-auto: create` (T-011).
- [ ] Rama por defecto protegida (T-016).
**Tareas:** T-001 … T-016.

## P1 · Actualizar → `v0.2.0`
**Objetivo:** versiones vigentes en pasos chicos, protegidos por la red de P0 ([ADR 0002](adr/0002-upgrade-path.md)).
**Criterio de salida:** Boot 3.5 (luego 4.x) y Java 21+; Node 24, Vite 8, React 19, ESLint flat; `npm audit` sin críticas/altas; Dependabot activo (T-013); CI en verde.

## P2 · Terminar → `v0.3.0`
**Objetivo:** cerrar la funcionalidad a medias, cada feature con spec y tests.
**Criterio de salida:** recuperar contraseña, logout real, decisión sobre login Google/2FA/divisas/soporte implementada o eliminada; dinero en `BigDecimal`; errores `ProblemDetail`; sin código muerto (`googleauth/`, endpoints de prueba).

## P3 · Pulir para portfolio → `v1.0.0`
**Objetivo:** presentable.
**Criterio de salida:** sin scroll horizontal en 375/768/1280 px; accesibilidad básica (labels, un `h1` por página, foco); cobertura ≥ 70 % en servicios y lógica de front; README con capturas actuales, badges de CI/cobertura y licencia; demo online verificada; release `v1.0.0`.
