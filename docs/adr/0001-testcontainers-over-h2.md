# 0001 · Tests de integración con Testcontainers PostgreSQL, no H2

- Estado: Aceptado · Fecha: 2026-10-10 · Decide: 🧠 (bootstrap T-000)

## Contexto
Producción usa PostgreSQL. Hoy el único test (`WalamApplicationTests`) necesita una DB real y un `Walam/.env`, lo que lo vuelve frágil en CI. H2 no reproduce tipos, constraints ni SQL de PostgreSQL.

## Decisión
Los tests de integración (`@SpringBootTest`, `@DataJpaTest`) usan **Testcontainers** con la misma imagen de PostgreSQL que `docker-compose.yml` (`postgres:17-alpine`), vía `@ServiceConnection`. Un perfil/config de test evita depender de `Walam/.env`. Los unitarios no usan DB.

## Alternativas
- H2 en modo PostgreSQL: rápido, pero diverge (dialecto, `columnDefinition`, secuencias) y oculta bugs.
- DB del compose: funciona hoy (lo usa `verify.sh`), pero acopla los tests al entorno y a datos compartidos.

## Consecuencias
- Los tests necesitan Docker (local y CI; GitHub Actions lo trae).
- Arranque ~2–5 s por contenedor (se reutiliza por contexto de Spring).
- Implementación: [T-006](../tasks/T-006-backend-test-infra.md).
