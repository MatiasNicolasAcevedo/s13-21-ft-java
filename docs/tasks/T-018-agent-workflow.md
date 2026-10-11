# T-018 · Clarify agent roles and session handoffs
- Estado: En revisión · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
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
- [x] Documentación activa usa 🤖 Junie Lite (Free, JetBrains Air), sin depender del nombre del modelo subyacente.
- [x] 🧠 frontera admite los ejemplos del dueño: GPT 6.1 Sol u Opus 5.5, según disponibilidad.
- [x] Compactación, reanudación y sesión nueva tienen reglas y prompts claros.
- [x] Traspasos a Lite incluyen prompt completo; STATUS muestra tarea y ejecutor.
- [x] Cierre exige commit, push y árbol limpio; revisión no deja documentación local pendiente; actualización posterior al merge se incorpora al comienzo de la siguiente tarea.
- [x] Aprobaciones explícitas de comandos se persisten en `C:\Users\matia\.junie\allowlist.json` conservando formato y permisos existentes.
- [x] Tag inexistente corregido, PR preparado y validación documentada.

## Notas de implementación
- Rama: `docs/T-018-agent-workflow` · PR: [#2](https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/pull/2) · Último commit publicado antes de este registro: `6bd1de2` (inicio); implementación posterior en el historial del PR.
- Hecho: árbol inicial limpio; develop coincide con origin/develop; no había PR abierto; tag `audit/2026-10-10` ausente en el remoto. Nombres, compactación, estados, persistencia y traspasos actualizados; contratos de las siete tareas Lite incluyen prompt de arranque concreto.
- Decisiones: el ejecutor refiere a la capacidad/nivel del agente; no se fija el modelo interno de Lite. El revisor no edita documentación de cierre; la siguiente tarea concilia el merge en su primer commit. Se comprueban las dependencias desbloqueadas antes de elegir esa tarea.
- Verificación: `git diff --check` sin errores; comprobación documental de enlaces/anclas, nombres y bloques; siete prompts Lite presentes; JSON personal válido. `verify.sh` ejecutado con Git Bash y `/usr/bin` en PATH: back build/test ✅ (1 test, 0 fallos, JDK 21.0.9), front build ✅, lint ❌ (64 problemas: 62 errores, 2 warnings), sin tests de front. Coincide con la falla previa registrada en T-003; ningún archivo de aplicación cambió.
- Limitaciones: primer intento de gate bloqueado por PATH y después por sandbox (red/Docker); ejecución con permisos del entorno completó el gate. Node local 24, diferente de `.nvmrc` (22); no se cambió configuración ni se certifica el gate con Node 22. No hubo aprobaciones manuales de comandos del dueño: no se agregó una entrada a la allowlist, que ya cubre varios ejecutables.
- Pendiente: revisión independiente de PR #2 y merge por el dueño si se aprueba.
- Próximo paso: sesión nueva con frontera, `docs/agents/reviewer.md` para PR #2. Después del merge, T-001 (frontera); registrar T-018 como Hecha en el primer commit de `fix/T-001-externalize-secrets`.

## Resultado
- PR: #2 · Estado: En revisión hasta el merge · Qué cambió: protocolos y documentación activa consistentes con Junie Lite y frontera; prompts completos y controles de persistencia. Tests agregados: ninguno (documentación).
