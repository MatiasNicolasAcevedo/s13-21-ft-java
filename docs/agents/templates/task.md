# T-NNN · <Título en imperativo>
- Estado: Lista · Prioridad: P0–P3 · Esfuerzo: S/M/L · Ejecuta: 🤖 Junie Lite | 🧠 modelo de frontera | 👤 dueño
- Fase: <P0 Estabilizar | P1 Actualizar | P2 Terminar | P3 Pulir>
- Rama: `<tipo>/T-NNN-slug` (crearla desde `develop` actualizado antes del primer commit) · Depende de: T-NNN · Spec/ADR: <links o "—">
- Revisa: <🤖 Junie Lite (chat nuevo) | 🧠 modelo de frontera | 👤 dueño> (según la matriz de CONTRIBUTING)

## Por qué
<2–4 líneas: problema y evidencia (archivo:línea o hallazgo de la auditoría)>

## Objetivo
<resultado observable en 1–2 líneas>

## Alcance
- Incluye: ...
- **No incluye:** ... (lo que NO se debe tocar aunque parezca relacionado)

## Leer antes (máx. 5 referencias, con sección o rango de líneas)
## Archivos previstos
- modificar: ... · crear: ...

## Tests
- Agregar: <qué tests, de qué tipo, qué casos (incluido el de error)>
- Si es bugfix: test que reproduce el bug y falla antes del fix.

## Pasos sugeridos
## Criterios de aceptación (verificables, de a uno)
- [ ] `./scripts/verify.sh` pasa y la cobertura no baja
- [ ] <comando o prueba concreta con resultado esperado>
- [ ] Si cambió la configuración o cómo se levanta: `.example`, compose, README y SETUP actualizados y probados

## Notas de implementación  _(las completa quien implementa; también antes de compactar)_
- Rama: ... · PR/URL: ... · Último commit publicado antes de este registro: ...
- Hecho: ... · Decisiones: ... · Verificación (comandos/resultados): ...
- Pendiente: ... · Limitaciones: ... · Próximo paso concreto: ...
- Contexto: <seguir | compactar misma tarea | reanudar misma tarea en sesión nueva> · Ejecuta: ...

## Prompt para el próximo agente _(obligatorio si ejecuta Lite; completar datos reales)_
```text
Leé AGENTS.md y seguí docs/agents/<implementer|reviewer>.md para <acción concreta>.
Ejecutor: Junie Lite (Free) en JetBrains Air.
Tarea: T-NNN · <título>. Contrato: docs/tasks/T-NNN-slug.md.
Rama: <rama>. PR: <número/URL o todavía no creado>.
Estado y pendiente inmediato: <detalle>. Verificación/decisiones: ver Notas de implementación.
Confirmá estado del PR, rama y git status; trabajá solo en esta tarea.
Si tomás una tarea nueva, confirmá el merge anterior y conciliá su documentación en el primer commit de la nueva rama.
Antes del traspaso, commiteá y publicá los cambios propios y comprobá árbol limpio.
```

## Resultado  _(al cerrar)_
- PR: #N · Estado: En revisión hasta el merge · Qué cambió: ... · Tests agregados: ... · Pendientes → nuevas tareas: T-NNN
- La siguiente implementación registra Hecha tras confirmar el merge; el revisor no edita documentación local de cierre.
