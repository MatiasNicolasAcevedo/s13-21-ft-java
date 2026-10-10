# T-006 · Set up backend test infrastructure (JaCoCo ratchet + Testcontainers)
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-006-backend-test-infra` (desde `develop` actualizado) · Depende de: — · Spec/ADR: [ADR 0001](../adr/0001-testcontainers-over-h2.md)
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
1 test (`WalamApplicationTests`) que depende de la DB del compose y de `Walam/.env`; cobertura de línea 11.1 %, rama 0 %; sin umbral. Bloquea CI confiable (T-007) y la caracterización (T-009, T-010, T-011). Auditoría §6.7.

## Objetivo
`./mvnw -B clean verify` corre sin `.env` ni compose (solo Docker), mide cobertura y falla si baja del umbral.

## Alcance
- Incluye: `org.testcontainers:postgresql` + `spring-boot-testcontainers` (versión del BOM de Boot 3.2; si hace falta, la más nueva compatible) y `@ServiceConnection` con `postgres:17-alpine`; configuración de test que no necesite `Walam/.env` (p. ej. clase `TestcontainersConfiguration` + `@Import`, propiedades de test para `JWT_SECRET` si T-001 ya está); `jacoco-maven-plugin` 0.8.15 con `prepare-agent`, `report` y `check` (umbral **línea 0.10**, rama 0.00 → trinquete); reporte en `target/site/jacoco/`; un **test de integración de referencia** (registro + login por HTTP con `MockMvc`) y un **`@WebMvcTest` de referencia** (p. ej. `TransactionController` con validación de monto ≤ 0 → 400); actualizar `docs/TESTING.md` §3 (archivos de referencia) y §5; `verify.sh` ya no necesita levantar la DB (dejar el `ensure_db` solo si algún test lo requiere).
- **No incluye:** caracterizar servicios (T-009, T-010), Flyway (T-011), CI (T-007), cambiar código de producción salvo lo mínimo para testear (justificarlo en el PR).

## Leer antes
- `Walam/pom.xml` · `src/test/java/.../WalamApplicationTests.java` · `docs/TESTING.md` · ADR 0001 · `scripts/verify.sh` (`verify_server`).

## Archivos previstos
- modificar: `Walam/pom.xml`, `WalamApplicationTests.java`, `scripts/verify.sh`, `docs/TESTING.md`, `Walam/AGENTS.md` (referencias) · crear: `src/test/java/.../TestcontainersConfiguration.java`, `src/test/java/.../auth/AuthFlowIntegrationTest.java`, `src/test/java/.../controller/TransactionControllerTest.java`.

## Tests
- Los dos de referencia + el de contexto, todos sin `.env`.

## Criterios de aceptación
- [ ] Con la DB del compose **apagada** y sin `Walam/.env`: `cd Walam && ./mvnw -B clean verify` → `BUILD SUCCESS`
- [ ] `target/site/jacoco/index.html` existe y el `check` falla si se sube el umbral por encima de la cobertura real (probalo y anotalo en el PR)
- [ ] `./scripts/verify.sh --server` muestra ≥ 3 tests
- [ ] `docs/TESTING.md` lista los archivos de referencia nuevos y el umbral

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
