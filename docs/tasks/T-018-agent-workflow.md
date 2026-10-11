# T-018 · Clarify agent roles and session handoffs
- Estado: En curso · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `docs/T-018-agent-workflow` · Depende de: T-000 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
El dueño pidió corregir el nombre del agente gratuito, distinguir los modelos de frontera y evitar pérdidas de contexto o documentación sin commitear. Este ajuste documental se realiza antes de T-001 por pedido explícito; no cambia el orden de las tareas de producto.

## Objetivo
Que cada sesión indique la tarea siguiente, el ejecutor y un prompt copiable, y deje el trabajo persistido antes de un traspaso o una compactación.

## Alcance
- Incluye: AGENTS, protocolos, SETUP, CONTRIBUTING, STATUS, tablero, contratos y templates; regla de persistencia de comandos aprobados en la allowlist personal de Junie; corrección del tag de auditoría inexistente.
- **No incluye:** implementar T-001, modificar la aplicación, rotar secretos, cambiar permisos existentes sin una aprobación concreta, mergear este PR.

## Leer antes
- `AGENTS.md` §§1, 4, 5, 9
- `docs/agents/implementer.md`
- `docs/agents/reviewer.md`
- `CONTRIBUTING.md` §§3–5
- `docs/SETUP.md` (agentes)

## Archivos previstos
- Modificar: documentación activa de agentes, tareas, tablero, estado y template de PR.
- Crear: este contrato.

## Tests
- Revisión documental de nombres, enlaces locales, prompts, cola y estados; `git diff --check`.
- Ejecutar el gate e informar fallas previas o limitaciones del entorno. No se agregan tests de aplicación para cambios documentales.

## Criterios de aceptación
- [ ] Documentación activa usa 🤖 Junie Lite (Free, JetBrains Air), sin depender del nombre del modelo subyacente.
- [ ] 🧠 frontera admite los ejemplos del dueño: GPT 6.1 Sol u Opus 5.5, según disponibilidad.
- [ ] Compactación, reanudación y sesión nueva tienen reglas y prompts claros.
- [ ] Traspasos a Lite incluyen prompt completo; STATUS muestra tarea y ejecutor.
- [ ] Cierre exige commit, push y árbol limpio; revisión no deja documentación local pendiente; actualización posterior al merge se incorpora al comienzo de la siguiente tarea.
- [ ] Aprobaciones explícitas de comandos se persisten en `C:\Users\matia\.junie\allowlist.json` conservando formato y permisos existentes.
- [ ] Tag inexistente corregido, PR preparado y validación documentada.

## Notas de implementación
- Hecho: árbol inicial limpio; develop coincide con origin/develop; no hay PR abierto; tag `audit/2026-10-10` ausente en el remoto.
- Pendiente: cambios documentales y validación.
- Próximo paso: actualizar protocolos y documentación activa.

## Resultado
- PR: pendiente · Qué cambió: pendiente · Tests agregados: ninguno (documentación).
