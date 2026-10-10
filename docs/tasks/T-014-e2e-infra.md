# T-014 · Set up Playwright E2E smoke tests and scripts/e2e.sh
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-014-e2e-infra` (desde `develop` actualizado) · Depende de: T-007, T-008, T-017 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
Ningún test cubre el flujo de punta a punta (flujo 9 de la auditoría §6.7). Necesita que el front hable con el back local (T-004/T-017) y CI (T-007).

## Objetivo
`./scripts/e2e.sh` levanta el stack con `docker compose --profile app` y corre smoke tests de Playwright en desktop (1280) y mobile (375), con trazas y screenshots en fallos; job `e2e` en CI.

## Alcance
- Incluye: proyecto Playwright (carpeta `e2e/` en la raíz con su `package.json`, versión vigente verificada en npm), smoke: registro por API + login por UI → dashboard muestra saldo; depósito de 100 actualiza el saldo; ruta privada sin token redirige a login (si T-012 ya está; si no, `test.fixme` con link); `scripts/e2e.sh`; job `e2e` en `ci.yml` (después de `server` y `client`); `docs/TESTING.md` (referencia E2E) y README §Tests.
- **No incluye:** tests visuales, cobertura de todas las pantallas.

## Leer antes
- `docker-compose.yml` · `scripts/dev.sh` (espera de health y usuario demo) · `docs/TESTING.md` · `.github/workflows/ci.yml`.

## Archivos previstos
- crear: `e2e/package.json`, `e2e/playwright.config.js`, `e2e/tests/smoke.spec.js`, `scripts/e2e.sh` · modificar: `.github/workflows/ci.yml`, `docs/TESTING.md`, `README.md`, `.gitignore` (reportes).

## Criterios de aceptación
- [ ] `./scripts/e2e.sh` en verde desde un clon limpio (solo Docker + Node)
- [ ] Romper el login en el front hace fallar el smoke (anotarlo en el PR)
- [ ] Job `e2e` en verde en el PR, con artefacto de traza en fallos

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
