# Cómo contribuir

Vale para personas y agentes (🧠 modelo de frontera, 🤖 Junie Lite (Free, JetBrains Air), 👤 dueño). Ver también [AGENTS.md](AGENTS.md).

## 1. Ramas (GitHub Flow)
- La rama por defecto es **`develop`** y está siempre en verde. Nadie commitea directo a `develop`.
- **Antes del primer commit de cualquier tarea** se crea su rama desde `develop` actualizado, con el nombre exacto que figura en la tarea:
  `<tipo>/T-NNN-slug-corto` con `tipo` ∈ `feat fix test refactor chore docs ci build perf`.
  ```bash
  git switch develop && git pull && git switch -c fix/T-001-externalize-secrets
  ```
- Ramas de vida corta. Si `develop` avanzó: `git fetch origin && git rebase origin/develop` (en tu rama, nunca en una ajena).

## 2. Commits (Conventional Commits)
`tipo(alcance): descripción en imperativo` + cuerpo opcional con el porqué + footer `Refs: T-NNN`.
```
fix(auth): read JWT secret from environment

The key was hardcoded in JwtService and is in the git history.

Refs: T-001
```
Atómicos. `!` y `BREAKING CHANGE:` para cambios incompatibles. Prohibido: "wip", "fix", "cambios", "Update README.md".

## 3. Pull requests
- **Uno por tarea, chico** (< ~400 líneas sin lockfiles ni generados) y **uno abierto a la vez**: no se empieza otra tarea hasta que el PR anterior se mergea o se cierra.
- **Título = Conventional Commit** (lo valida `.github/workflows/pr-title.yml`; se mergea con squash, así que el título es el commit final).
- Se abre en **draft apenas se crea la rama** y pasa a "ready" con `./scripts/verify.sh` sin regresiones y el template completo (`.github/pull_request_template.md`).
- Sin `gh` ni MCP (caso típico del 🤖): `git push -u origin <rama>` y dejarle al 👤 el link `https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/compare/develop...<rama>?expand=1` con título y cuerpo listos para pegar.

## 4. Revisión (sesión nueva, con [docs/agents/reviewer.md](docs/agents/reviewer.md))
| PR | Implementa | Revisa | Quién lanza la revisión |
|---|---|---|---|
| Tarea 🤖 S, sin riesgo | 🤖 Junie Lite | 🤖 Junie Lite, **chat nuevo** | 👤 abre el chat nuevo |
| Tarea 🤖 M, o que toca back y front, seguridad, datos, configuración o CI | 🤖 Junie Lite | 🧠 modelo de frontera | 👤 abre una sesión de frontera |
| Tarea 🧠 | 🧠 modelo de frontera | 🧠 sesión nueva o sub-agente (si el 👤 lo pide) + 👤 | 👤 |
| Dependabot | bot | 🤖; versión mayor → tarea 🧠 | 👤 |

La tarea dice en "Revisa" quién revisa; la respuesta final de quien implementó dice qué abrir y qué escribir. Máximo **2 rondas**; después se escala a 🧠 o al 👤. Sin cuenta bot, la revisión es un **comentario** con veredicto explícito: `APROBADO` / `CAMBIOS REQUERIDOS` / `ESCALAR A 🧠/DUEÑO`.

🤖 = **Junie Lite (Free) en JetBrains Air**; 🧠 = **modelo de frontera**, p. ej. GPT 6.1 Sol u Opus 5.5 según disponibilidad. El traspaso identifica tarea/PR, ejecutor y acción; si va a Lite, incluye un prompt completo para copiar. No se asume que Lite carezca de `gh` o MCP: comprobá las herramientas de la sesión.

## 5. Merge
Squash, con CI en verde (mientras no haya CI: `verify.sh` sin regresiones respecto de `develop`) y revisión aprobada. Lo hace el 👤, o el 🧠 solo si el 👤 se lo pidió explícitamente para ese PR. Después se borra la rama.

La tarea permanece **En revisión** hasta el merge. La documentación posterior al merge (Hecha, tablero, STATUS, dependencias y hallazgos del revisor) se incorpora al inicio de la siguiente tarea, en el primer commit de su nueva rama. El revisor entrega el traspaso sin modificaciones locales pendientes.

## 5b. Persistencia antes de cerrar o cambiar de contexto
Revisá diff y archivos nuevos, commiteá documentación y código propios con `Refs: T-NNN`, hacé push y comprobá `git status --short` vacío y sincronización con upstream. Identificá cambios ajenos existentes al inicio; no los borres ni los incluyas sin autorización. Si falta commit/push, reportá la causa y los archivos: la sesión todavía no está cerrada. La allowlist personal de Junie queda fuera de Git.

## 6. Protección de la rama por defecto
Pasos exactos en [T-016](docs/tasks/T-016-protect-default-branch.md) (👤).

## 7. Releases
Al cerrar cada fase del [ROADMAP](docs/ROADMAP.md): `git tag v0.x.0 && git push origin v0.x.0` y `gh release create v0.x.0 --generate-notes`.

## 8. Dependabot
Maven, npm y GitHub Actions, semanal, minor/patch agrupados, prefijos `build(deps)` / `ci(deps)`. Se activa **solo con CI en verde**: [T-013](docs/tasks/T-013-dependabot.md).

## 9. Configuración de ejemplo
Todo archivo con valores por entorno tiene su `.example` commiteado y el real en `.gitignore`. Todo cambio que agregue o renombre una variable actualiza en el **mismo PR** su `.example`, `docker-compose.yml`, `docs/SETUP.md` y el README si cambia un paso.

## 10. Tests
Reglas en [docs/TESTING.md](docs/TESTING.md): tests en el mismo PR, bugfix = primero un test que falla, prohibido borrar/deshabilitar/debilitar tests o bajar umbrales.
