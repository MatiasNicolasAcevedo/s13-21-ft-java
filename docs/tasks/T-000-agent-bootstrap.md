# T-000 · Bootstrap the agent harness and audit the project
- Estado: En curso · Prioridad: P0 · Esfuerzo: L · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `chore/T-000-agent-bootstrap` · Depende de: — · Spec/ADR: [ADR 0001](../adr/0001-testcontainers-over-h2.md), [ADR 0002](../adr/0002-upgrade-path.md)
- Revisa: 👤 dueño (o 🧠 sub-agente si el dueño lo pide)

## Por qué
Proyecto de 2024 sin tests, CI, docs de setup ni sistema de trabajo para agentes.

## Objetivo
Auditoría inicial + harness (contenedores, `.example`, `verify.sh`, `dev.sh`), README verificado, docs vivos, tablero y protocolos, en un PR.

## Alcance
- Incluye: solo docs, configuración de ejemplo, infraestructura local y `.github/`.
- **No incluye:** código de la aplicación, versiones, borrar archivos.

## Criterios de aceptación
- [ ] Auditoría en `docs/audits/2026-10-10-initial.md`
- [ ] README probado desde un clon limpio en ambos modos
- [ ] Tablero con 5–10 tareas en "Listas" y protocolos en `docs/agents/`

## Notas de implementación
- Hecho: PC1–PC3 · Pendiente: PC4, Fase 4 · Próximo paso: pruebas en seco

## Resultado
- PR: #1 · Qué cambió: ver descripción del PR · Tests agregados: — · Pendientes → T-001…T-017
