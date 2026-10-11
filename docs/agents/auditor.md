# Protocolo: auditoría periódica

**Lo usa:** solo 🧠 modelo de frontera. Cuándo: cada 5–10 PR mergeados, antes de un cambio grande (p. ej. Boot 4) o cuando hay 2+ tareas `requiere 🧠`. Trabajá por bloques; al cerrar cada bloque, commit y (si el contexto lo pide) compactación opcional según `AGENTS.md` §5.

## 0. Rama
`git switch develop && git pull && git switch -c docs/audit-AAAA-MM-DD` (fecha de hoy). PR draft enseguida: título `docs: periodic audit AAAA-MM-DD`.

## 1. Situación
- Leé `docs/STATUS.md`, `docs/BACKLOG.md`, `docs/ROADMAP.md` y la última auditoría en `docs/audits/`.
- Cambios desde la auditoría anterior: confirmá primero el tag remoto (`git ls-remote --tags origin audit/<fecha-anterior>`). Si existe, traelo y usá `git log --oneline audit/<fecha-anterior>..develop`; si falta, usá el commit de merge confirmado de la auditoría anterior (la primera: T-000 / PR #1). No asumas que `audit/2026-10-10` existe.
- PR mergeados y sus revisiones: `gh pr list --state merged --limit 20` + `gh pr view <N> --comments`.

## 2. Trabajo de los agentes
- ¿Lo mergeado cumple de verdad los criterios? Elegí 2–3 PR y re-ejecutá sus criterios.
- ¿Alguna revisión dejó pasar problemas? Anotá el patrón.
- Spot check de tests: rompé una línea de lógica en un servicio y mirá si algo falla (revertí). Opcional: PIT en `service/impl`, Stryker en el front.

## 3. Salud
- Cobertura vs. umbral: si creció, **subí el umbral** (redondeado hacia abajo) en el mismo PR.
- Tests lentos o inestables (`.verify-logs/`, tiempos de CI).
- **Onboarding desde un clon limpio** en los dos modos del README (contenedores y desarrollo), sin exportar variables a mano. Corregí lo que falle.
- `.example` completos y coherentes con compose, SETUP y README.
- Deriva documental: comandos, versiones, puertos y nombres iguales en todos los docs; links vivos.
- `npm audit` y dependencias Maven desactualizadas.

## 4. Resolver y replanificar
- Decisiones del 👤 ya tomadas → ADR en `docs/adr/`.
- Tareas 🧠 prioritarias: **de a una**, cada una en su rama y PR (no en el de la auditoría).
- Relevamiento liviano de lo que cambió (dimensiones de la auditoría inicial que se movieron).
- Reordená la cola y refiná 5–10 tareas en "Listas" en orden de ejecución (≥ 3 para 🤖; Definición de Listo de `docs/agents/templates/task.md` y de la auditoría inicial).
- Si algo falla repetidamente, ajustá `AGENTS.md`, plantillas o protocolos.

## 5. Cerrar
- `docs/audits/AAAA-MM-DD-periodic.md` (resumen con semáforo, hallazgos con evidencia, decisiones, cambios de cola).
- `docs/STATUS.md` (fila "Última auditoría") y archivo (`docs/archive/`) de lo viejo.
- PR listo; después del merge, el 👤 (o vos si te lo pide): `git tag audit/AAAA-MM-DD origin/develop && git push origin audit/AAAA-MM-DD`.
- Antes del cierre o de una compactación, persistí notas, documentación y cambios propios con commit/push y verificá árbol limpio. El estado posterior al merge lo incorpora la siguiente tarea en su primer commit; ningún traspaso de revisión deja documentación local pendiente.
- Sugerí sesión nueva.

## 6. Respuesta final y traspaso
> **Próximo paso:** revisar y mergear PR #N (auditoría) · **ejecuta: 👤 dueño** · luego T-NNN · **ejecuta:** <🤖 | 🧠>
> **Qué hacer:** GitHub → PR #N; después abrí <sesión nueva de Junie Lite en Air | sesión nueva con un modelo de frontera> y escribí: «Seguí `docs/agents/implementer.md`»

Si la próxima tarea es Lite, agregá el prompt completo con datos reales de [implementer §11](implementer.md#11-respuesta-final-y-traspaso); indicá que se usa después del merge y que la nueva implementación concilia el cierre de la auditoría en su primer commit.
