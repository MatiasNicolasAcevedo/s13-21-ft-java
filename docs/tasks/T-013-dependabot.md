# T-013 · Enable Dependabot for Maven, npm and GitHub Actions
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `ci/T-013-dependabot` (desde `develop` actualizado) · Depende de: T-007 (CI en verde) · Spec/ADR: [ADR 0002](../adr/0002-upgrade-path.md)
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
Dependencias desactualizadas y vulnerables (auditoría §5, §6.2). Sin CI, los PR de Dependabot no se pueden validar: por eso espera a T-007.

## Objetivo
Dependabot abre PRs semanales agrupados (minor/patch) con títulos compatibles con `pr-title.yml`.

## Propuesta (`.github/dependabot.yml`)
```yaml
version: 2
updates:
  - package-ecosystem: maven
    directory: /Walam
    schedule: { interval: weekly }
    commit-message: { prefix: "build(deps)" }
    groups: { minor-patch: { update-types: [minor, patch] } }
  - package-ecosystem: npm
    directory: /Walam_Front
    schedule: { interval: weekly }
    commit-message: { prefix: "build(deps)" }
    groups: { minor-patch: { update-types: [minor, patch] } }
  - package-ecosystem: github-actions
    directory: /
    schedule: { interval: weekly }
    commit-message: { prefix: "ci(deps)" }
```

## Alcance
- Incluye: el archivo; mencionar en `CONTRIBUTING.md` §8 que los mayores pasan por tarea 🧠.
- **No incluye:** mergear PRs de Dependabot (los revisa 🤖 según la matriz), subir versiones a mano.

## Criterios de aceptación
- [ ] En GitHub → Insights → Dependency graph → Dependabot, los 3 ecosistemas aparecen sin errores de parseo
- [ ] El primer PR de Dependabot pasa el check de título

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Pendientes → nuevas tareas: …
