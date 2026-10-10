# T-011 · Replace ddl-auto=create with Flyway migrations
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `feat/T-011-flyway-baseline` (desde `develop` actualizado) · Depende de: T-006, T-009, T-010 · Spec/ADR: crear ADR 0003
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
🟠 `ddl-auto: create` (`Walam/src/main/resources/application.yaml:18`) **borra y recrea el esquema en cada arranque**, también en producción. No hay historial del esquema. Auditoría §6.3.

## Objetivo
El esquema se crea y evoluciona con Flyway (`V1__baseline.sql` igual al esquema actual) y Hibernate solo valida (`ddl-auto: validate`).

## Alcance
- Incluye: `flyway-core` + `flyway-database-postgresql`; `V1__baseline.sql` generado desde el esquema actual (`pg_dump --schema-only` de la DB local recién creada) y revisado a mano; `ddl-auto: validate`; ADR 0003 (por qué Flyway, cómo se aplica en Render con una DB existente: `baselineOnMigrate`); actualizar `docs/SETUP.md` (resetear datos), README (problema frecuente de usuarios que desaparecen) y `docs/ARCHITECTURE.md`.
- **No incluye:** cambiar tipos (`Double` → `BigDecimal` es otra tarea), seed de datos, tocar entidades.

## Leer antes
- `application.yaml` · `model/entity/*.java` (solo anotaciones) · ADR 0001 · tests de T-009/T-010 (deben seguir pasando).

## Archivos previstos
- modificar: `Walam/pom.xml`, `application.yaml`, `docs/SETUP.md`, `README.md`, `docs/ARCHITECTURE.md` · crear: `src/main/resources/db/migration/V1__baseline.sql`, `docs/adr/0003-flyway-migrations.md`.

## Tests
- Test de integración (Testcontainers): la migración aplica en DB vacía y Hibernate valida sin errores; T-009 y T-010 siguen verdes.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa
- [ ] Reiniciar el back local **no** borra el usuario demo (registrar, reiniciar, login OK)
- [ ] `docker compose --profile app down -v && docker compose --profile app up -d --build --wait` arranca de cero sin errores
- [ ] ADR 0003 con el procedimiento para producción

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
