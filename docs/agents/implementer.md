# Protocolo: implementar una tarea

**Lo usan:** 🤖 Junie Lite (Free, JetBrains Air) y 🧠 modelo de frontera. Una tarea por sesión. Repo: `MatiasNicolasAcevedo/s13-21-ft-java`, rama por defecto **`develop`**.

## 1. Orientarse (sin escribir código)
- Leé `AGENTS.md`, `docs/STATUS.md` y `docs/BACKLOG.md`.
- `git status` y `git log --oneline -10`.
- Registrá archivos previos modificados o nuevos; no los mezcles con la tarea ni los descartes. Respetá `AGENTS.md` §4.7 y §6 (persistencia y comandos aprobados).
- PRs abiertos: `gh pr list` · sin `gh`: `git fetch origin && git ls-remote --heads origin` (cada rama `<tipo>/T-NNN-*` remota = tarea tomada; mirá "En curso" en el tablero).

## 2. Primero lo que está en vuelo
- Si un PR tuyo tiene **cambios pedidos**: `git switch <su rama> && git pull`, atendé solo lo pedido y seguí desde el paso 6.
- Si hay **un PR de tarea abierto** esperando revisión o merge: no tomes otra. Terminá con el traspaso (§11) diciendo quién revisa (según "Revisa" de la tarea) o que el 👤 tiene que mergear.
- Si venís a **retomar T-NNN**, usá su rama y notas; no elijas una tarea nueva. Confirmá el estado real del PR y continuá desde el pendiente registrado.
- Si el PR anterior ya se mergeó pero la documentación aún dice En revisión, reconciliá **primero en lectura** el orden efectivo: qué dependencias se desbloquearon y dónde deben entrar según BACKLOG y los contratos. Elegí la primera de esa cola resultante; las ediciones se persisten después en su nueva rama (§4). Por ejemplo, después de T-006, T-007 entra antes de T-008 si T-003 también está mergeada. No elijas usando una cola desactualizada.

## 3. Línea de base
- `git switch develop && git pull` y `./scripts/verify.sh`.
- Si falla por algo que **ya tiene tarea** en la cola (hoy: lint del front → T-003), anotalo y seguí: tu criterio es "sin regresiones respecto de `develop`". Si falla por algo nuevo, creá la línea en Backlog y avisá en la respuesta final.

## 4. Tomar la tarea
- Es **la primera** de "✅ Listas" que no tenga PR ni rama remota.
- Si es 🧠 y sos el 🤖, o es 👤 (y no dice "no bloquea la cola"): **no la tomes ni saltees a otra**. Terminá con el traspaso (§11).
- Si es 👤 "(no bloquea la cola)", saltala y tomá la siguiente.
- **Antes de cualquier commit:** `git switch -c <rama exacta de la tarea>`.
- **Conciliar el merge anterior en esta rama:** confirmá en GitHub (API/CLI/web) que el PR previo está mergeado, no solo cerrado ni que desapareció su rama. Incorporá aquí su estado final: tarea a Hecha, tablero a "🏁 Hecho reciente", STATUS y dependencias desbloqueadas. Registrá también lo que el revisor dejó para Backlog. Esto pertenece al primer commit de la tarea nueva; nunca deja cambios sueltos en `develop`. Si no podés confirmar el merge, detené la toma y entregá el traspaso.
- Primer commit: incluir esa conciliación si corresponde, mover la tarea nueva a "🔨 En curso" en `docs/BACKLOG.md`, `Estado: En curso` en la tarea y actualizar tabla de foco, siguiente ejecutor y prompts de STATUS/BACKLOG (sin conservar números de PR o tareas anteriores) → `git commit -m "docs(board): start T-NNN" -m "Refs: T-NNN"` → `git push -u origin <rama>`.
- PR en **draft** con el template (`.github/pull_request_template.md`) y título = Conventional Commit (el de la tarea en minúscula, p. ej. `fix: fix frontend lint errors so verify passes`):
  - con `gh`: `gh pr create --draft --base develop --title "<título>" --body-file <archivo>`
  - sin `gh` ni MCP: dejale al 👤 el link `https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/compare/develop...<rama>?expand=1` + el título + el cuerpo listos para pegar, y pedile que lo cree como **draft** y te diga el número. No asumas que Lite carece de estas herramientas: comprobalo.

## 5. Contexto mínimo
Leé la tarea y **solo** lo de "Leer antes" y "Archivos previstos", por rangos de líneas. No abras lockfiles, `target/`, `node_modules/`, `dist/`, `docs/archive/` ni auditorías.

## 6. Implementar con tests
- Respetá "No incluye". Bugfix: primero el test que falla.
- Entre pasos, el test más específico (`./mvnw -B test -Dtest=Clase` o `npx vitest run <archivo>`); al final `./scripts/verify.sh`.
- Si agregás o cambiás una variable: `.example`, `docker-compose.yml`, `docs/SETUP.md` (y README si cambia un paso) en el mismo PR.
- Commits atómicos Conventional Commits con footer `Refs: T-NNN`. `git push` después de cada commit sano.

## 7. Contexto largo
Aplicá `AGENTS.md` §5: solo dentro de la misma tarea, al terminar una sub-etapa y con contexto alto o señales de degradación. Persistí las notas completas, commit y push; verificá árbol limpio. Indicá claramente **“Podés compactar y continuar T-NNN”** si la herramienta admite compactación, o **“Abrí sesión nueva para retomar T-NNN”** si no la admite.

Si existe `/compact` en la herramienta, ejemplo de instrucción:
```text
/compact Conservar: tarea T-NNN, rama y PR, decisiones, commit publicado, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.
```

Para continuar tras compactar o desde una sesión nueva, entregá este prompt con datos reales. En Lite es obligatorio copiarlo completo; no asumas que Air conserva el chat anterior:
```text
Leé AGENTS.md y seguí docs/agents/implementer.md para retomar T-NNN.
Tarea: docs/tasks/T-NNN-slug.md. Ejecutor: <Junie Lite (Free) | modelo de frontera>.
Rama: <rama>. PR: #N (<URL>). Último commit publicado: <hash>.
Leé las Notas de implementación: contienen hecho, decisiones y verificación.
Pendiente inmediato: <acción concreta>. Limitaciones: <detalle o ninguna>.
Confirmá rama, commit, estado del PR y git status antes de editar.
Continuá esta tarea; no tomes la siguiente de Listas.
Antes del próximo traspaso, actualizá notas, commiteá y publicá los cambios propios y comprobá árbol limpio.
```

## 8. Reglas duras
No edites criterios de aceptación · no borres, deshabilites ni debilites tests · no bajes umbrales · no cambies versiones mayores, arquitectura, seguridad, CI ni configuración de producción sin que la tarea lo diga · no toques secretos ni `.env` reales · no commitees a `develop` · no mergees. Trabajo extra → línea en Backlog.

## 9. Escalar
Tras **2 intentos fallidos**, una decisión de diseño o algo fuera de alcance: commiteá lo sano, completá "Notas" con lo probado, mové la tarea a "⛔ Bloqueadas" con `bloqueada por: requiere 🧠` (o `requiere dueño`) — **la cola queda detenida en esa tarea** —, comentá en el PR draft (o dejale el texto al 👤), publicá todos los cambios propios y terminá con el traspaso: «Próximo paso: T-NNN · ejecuta: 🧠 · abrí una sesión nueva con un modelo de frontera y escribí: Seguí `docs/agents/implementer.md` para retomar T-NNN».

## 10. Cerrar
- Cada criterio comprobado (comando + resultado) y marcado en la tarea.
- "Notas" y "Resultado" completos; tarea **En revisión**, con número de PR, en "🔨 En curso / en revisión". No la marques Hecha ni pases a la siguiente mientras falta revisión/merge.
- `docs/STATUS.md`: salud, cobertura, **paso inmediato = revisar el PR y ejecutor**, tarea de producto siguiente identificada como **después del merge**, "Últimas sesiones" (máx. 5; las viejas a `docs/archive/log/AAAA-MM.md`).
- Incluí y revisá toda la documentación de esta sesión en los commits de la rama; push, `git status --short` vacío y `git rev-list --left-right --count HEAD...@{upstream}` = `0 0` (citá la referencia entre comillas en PowerShell). Si hay archivos ajenos previos, identificá cuáles; no declares árbol limpio. No cierres como completo con archivos propios pendientes o commits sin publicar.
- Descripción del PR completa (resumen de `verify.sh`, capturas 375/1280 px si hay UI) y pasarlo a **ready** (`gh pr ready <N>`; sin `gh`, pedíselo al 👤).
- El revisor no registra el merge en archivos locales. La documentación posterior al merge se incorpora **al inicio de la siguiente tarea**, en su rama y primer commit (§4).

## 11. Respuesta final y traspaso
Resumen breve: qué hiciste, resultado de `verify.sh`, URL del PR, commit/push y estado del árbol. Después, el traspaso (el prompt copiable no cuenta como parte del resumen):
> **Próximo paso:** revisar PR #N · **ejecuta:** <🤖 Junie Lite (Free, JetBrains Air) | 🧠 modelo de frontera> (según "Revisa" de la tarea)
> **Qué hacer:** abrí <una sesión nueva de Junie Lite en Air | una sesión nueva con un modelo de frontera> y escribí: «Seguí `docs/agents/reviewer.md` para el PR #N»

Si el ejecutor del próximo paso es Lite, **siempre** agregá este prompt completo, reemplazando los placeholders. Para implementar/escalar/retomar usá el mismo formato cambiando protocolo y acción:
```text
Leé AGENTS.md y seguí docs/agents/reviewer.md para revisar el PR #N (<URL>).
Ejecutor: Junie Lite (Free) en JetBrains Air.
Tarea: T-NNN · <título>. Contrato: docs/tasks/T-NNN-slug.md.
Rama: <rama>. Acción: revisión en una sesión nueva; verificá que Revisa corresponda a Lite.
No implementes otra tarea. Entregá veredicto y siguiente paso con ejecutor y prompt.
No modifiques documentación local para registrar el merge ni el traspaso.
```
