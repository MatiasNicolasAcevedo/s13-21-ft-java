# T-007 · Add CI workflow running verify on every PR
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `ci/T-007-ci-workflow` (desde `develop` actualizado) · Depende de: T-003, T-006 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
No hay CI (auditoría §6.8). No se agregó en el bootstrap porque `verify.sh` falla (lint del front, T-003) y los tests del back dependen de la DB del compose (T-006).

## Objetivo
Cada PR y cada push a `develop` corre `verify.sh` por parte; el check es requerido en la protección de rama (T-016).

## Alcance
- Incluye: `.github/workflows/ci.yml` (propuesta abajo; versiones de actions verificadas el 2026-10-10 con `git ls-remote --tags`), artefacto de cobertura JaCoCo, badge de CI en el README.
- **No incluye:** E2E (T-014 agrega el job), deploy, Dependabot (T-013).

## Propuesta
```yaml
name: CI
on:
  push: { branches: [develop] }
  pull_request:
jobs:
  server:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-java@v6
        with: { distribution: temurin, java-version: '17', cache: maven }
      - run: ./scripts/verify.sh --server
      - if: always()
        uses: actions/upload-artifact@v7
        with: { name: jacoco, path: Walam/target/site/jacoco/ }
      - if: failure()
        uses: actions/upload-artifact@v7
        with: { name: server-logs, path: .verify-logs/ }
  client:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-node@v7
        with: { node-version-file: .nvmrc, cache: npm, cache-dependency-path: Walam_Front/package-lock.json }
      - run: ./scripts/verify.sh --client
      - if: failure()
        uses: actions/upload-artifact@v7
        with: { name: client-logs, path: .verify-logs/ }
```

## Leer antes
- `scripts/verify.sh` · `CONTRIBUTING.md` §5–6 · T-016.

## Archivos previstos
- crear: `.github/workflows/ci.yml` · modificar: `README.md` (badge), `docs/STATUS.md` (fila CI).

## Criterios de aceptación
- [ ] El PR de esta tarea muestra los checks `server` y `client` en verde
- [ ] Un commit de prueba que rompe un test pone `server` en rojo (probalo en la rama y revertilo; anotalo en el PR)
- [ ] Badge visible en el README

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
