# Protocolo: implementar una tarea

**Lo usan:** 🤖 agente gratuito de IntelliJ y 🧠 modelo de frontera. Una tarea por sesión. Repo: `MatiasNicolasAcevedo/s13-21-ft-java`, rama por defecto **`develop`**.

## 1. Orientarse (sin escribir código)
- Leé `AGENTS.md`, `docs/STATUS.md` y `docs/BACKLOG.md`.
- `git status` y `git log --oneline -10`.
- PRs abiertos: `gh pr list` · sin `gh`: `git fetch origin && git ls-remote --heads origin` (cada rama `<tipo>/T-NNN-*` remota = tarea tomada; mirá "En curso" en el tablero).

## 2. Primero lo que está en vuelo
- Si un PR tuyo tiene **cambios pedidos**: `git switch <su rama> && git pull`, atendé solo lo pedido y seguí desde el paso 6.
- Si hay **un PR de tarea abierto** esperando revisión o merge: no tomes otra. Terminá con el traspaso (§11) diciendo quién revisa (según "Revisa" de la tarea) o que el 👤 tiene que mergear.

## 3. Línea de base
- `git switch develop && git pull` y `./scripts/verify.sh`.
- Si falla por algo que **ya tiene tarea** en la cola (hoy: lint del front → T-003), anotalo y seguí: tu criterio es "sin regresiones respecto de `develop`". Si falla por algo nuevo, creá la línea en Backlog y avisá en la respuesta final.

## 4. Tomar la tarea
- Es **la primera** de "✅ Listas" que no tenga PR ni rama remota.
- Si es 🧠 y sos el 🤖, o es 👤 (y no dice "no bloquea la cola"): **no la tomes ni saltees a otra**. Terminá con el traspaso (§11).
- Si es 👤 "(no bloquea la cola)", saltala y tomá la siguiente.
- **Antes de cualquier commit:** `git switch -c <rama exacta de la tarea>`.
- Primer commit: mover la tarea a "🔨 En curso" en `docs/BACKLOG.md` y `Estado: En curso` en la tarea → `git commit -m "docs(board): start T-NNN" -m "Refs: T-NNN"` → `git push -u origin <rama>`.
- PR en **draft** con el template (`.github/pull_request_template.md`) y título = Conventional Commit (el de la tarea en minúscula, p. ej. `fix: fix frontend lint errors so verify passes`):
  - con `gh`: `gh pr create --draft --base develop --title "<título>" --body-file <archivo>`
  - sin `gh` ni MCP (🤖): dejale al 👤 el link `https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/compare/develop...<rama>?expand=1` + el título + el cuerpo listos para pegar, y pedile que lo cree como **draft** y te diga el número.

## 5. Contexto mínimo
Leé la tarea y **solo** lo de "Leer antes" y "Archivos previstos", por rangos de líneas. No abras lockfiles, `target/`, `node_modules/`, `dist/`, `docs/archive/` ni auditorías.

## 6. Implementar con tests
- Respetá "No incluye". Bugfix: primero el test que falla.
- Entre pasos, el test más específico (`./mvnw -B test -Dtest=Clase` o `npx vitest run <archivo>`); al final `./scripts/verify.sh`.
- Si agregás o cambiás una variable: `.example`, `docker-compose.yml`, `docs/SETUP.md` (y README si cambia un paso) en el mismo PR.
- Commits atómicos Conventional Commits con footer `Refs: T-NNN`. `git push` después de cada commit sano.

## 7. Contexto largo
Si se cumple la política de `AGENTS.md` §5: completá "Notas de implementación" (hecho / pendiente / próximo paso), commit, push y:
- 🧠: sugerí `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` + «después escribime "seguí con T-NNN"».
- 🤖: «Abrí un chat nuevo y escribí: Seguí `docs/agents/implementer.md` (retomando T-NNN)».

## 8. Reglas duras
No edites criterios de aceptación · no borres, deshabilites ni debilites tests · no bajes umbrales · no cambies versiones mayores, arquitectura, seguridad, CI ni configuración de producción sin que la tarea lo diga · no toques secretos ni `.env` reales · no commitees a `develop` · no mergees. Trabajo extra → línea en Backlog.

## 9. Escalar
Tras **2 intentos fallidos**, una decisión de diseño o algo fuera de alcance: commiteá lo sano, completá "Notas" con lo probado, mové la tarea a "⛔ Bloqueadas" con `bloqueada por: requiere 🧠` (o `requiere dueño`) — **la cola queda detenida en esa tarea** —, comentá en el PR draft (o dejale el texto al 👤) y terminá con el traspaso, p. ej.: «Próximo paso: T-NNN · ejecuta: 🧠 · abrí una sesión de Claude Code y escribí: Seguí `docs/agents/implementer.md` para retomar T-NNN».

## 10. Cerrar
- Cada criterio comprobado (comando + resultado) y marcado en la tarea.
- "Notas" y "Resultado" completos; tarea a "🏁 Hecho reciente" con el número de PR (si hay más de 10, mové la más vieja a `docs/archive/tasks/`).
- `docs/STATUS.md`: salud, cobertura, próximo paso, "Últimas sesiones" (máx. 5; las viejas a `docs/archive/log/AAAA-MM.md`).
- Descripción del PR completa (resumen de `verify.sh`, capturas 375/1280 px si hay UI) y pasarlo a **ready** (`gh pr ready <N>`; sin `gh`, pedíselo al 👤).

## 11. Respuesta final (máx. 5 líneas) + traspaso
Qué hiciste, resultado de `verify.sh`, link o número de PR y:
> **Próximo paso:** revisar PR #N · **ejecuta:** <🤖 agente gratuito (IntelliJ) | 🧠 modelo de frontera> (según "Revisa" de la tarea)
> **Qué hacer:** abrí <un chat nuevo del agente de IntelliJ | una sesión nueva de Claude Code> y escribí: «Seguí `docs/agents/reviewer.md` para el PR #N»
