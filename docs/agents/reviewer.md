# Protocolo: revisar un PR

**Lo usa:** el ejecutor que indique la tarea en "Revisa" (🤖 agente gratuito o 🧠 modelo de frontera). **Sesión nueva, un PR por sesión**, nunca la misma sesión que implementó. Repo: `MatiasNicolasAcevedo/s13-21-ft-java`, base **`develop`**.

## 0. ¿Me corresponde?
Abrí la tarea del PR (`docs/tasks/T-NNN-*.md`, en la rama del PR). Si dice "Revisa: 🧠" y sos el 🤖, **no revises**: terminá con el traspaso (§7) para que el 👤 abra una sesión de frontera.

## 1. Leer
`AGENTS.md`, `CONTRIBUTING.md`, `docs/TESTING.md`, la descripción del PR, la tarea y el diff completo:
- con `gh`: `gh pr view <N>` y `gh pr diff <N>`
- sin `gh`: `git fetch origin <rama> && git diff develop...origin/<rama>` (y `--stat` para el tamaño)

## 2. Verificar (no confíes solo en el PR)
- `git switch --detach origin/<rama>` y `./scripts/verify.sh`; compará con `develop` si había fallas previas conocidas.
- CI: `gh pr checks <N>` (sin `gh`: pedile al 👤 una captura de los checks o miralos en la web).
- Corré los comandos de cada criterio de aceptación.

## 3. Revisar, en este orden
1. **Criterios de aceptación**, uno por uno, con evidencia.
2. **Alcance y rama:** la rama se llama exactamente como en la tarea; nada de "No incluye"; nada fuera de alcance.
3. **Tests:** ¿fallarían si el código estuviera mal? (si podés, rompé una línea y probá) · ¿se borró, deshabilitó o debilitó alguno? · ¿bajó la cobertura?
4. **Corrección:** lógica, casos borde, errores, nulls.
5. **Seguridad:** secretos, autorización, datos sensibles en respuestas o logs, validación de entrada.
6. **Convenciones:** las de `AGENTS.md` §8 y los AGENTS de cada parte.
7. **Configuración:** `.example`, `docker-compose.yml`, `docs/SETUP.md` y README al día; sin valores reales.
8. **Registro:** tablero, tarea ("Notas" y "Resultado"), `docs/STATUS.md`, título Conventional Commit, tamaño (< ~400 líneas sin lockfiles).

## 4. Publicar el veredicto
Como review si la cuenta lo permite (`gh pr review <N> --comment --body-file <archivo>`); si no, comentario (`gh pr comment <N> --body-file <archivo>`); sin `gh`: dejale al 👤 el texto listo para pegar en el PR.
```
**Veredicto:** APROBADO | CAMBIOS REQUERIDOS | ESCALAR A 🧠/DUEÑO
Revisó: <🤖 agente gratuito | 🧠 modelo de frontera> · verify.sh: <resumen>
Criterios: ✅/❌ <criterio> — <evidencia>
Bloqueantes: <archivo:línea> — <problema> → <corrección sugerida>
Nits (opcionales, máx. 5): …
Fuera de alcance → Backlog: …
```

## 5. Reglas
- Sugerí, no reescribas (no commitees en la rama del PR salvo que el 👤 lo pida).
- Nada fuera de alcance como bloqueante: va a Backlog.
- **Segunda ronda:** solo lo pedido + regresiones. Si tampoco se aprueba: `ESCALAR`. Máximo 2 rondas.

## 6. Merge
Lo hace el 👤 (squash). **Excepción:** el 👤 pidió explícitamente "revisá y mergeá el PR #N" (revisión con sub-agente): con `APROBADO` y CI en verde (sin CI: `verify.sh` sin regresiones respecto de `develop`), `gh pr merge <N> --squash --delete-branch`. Nunca commitees a `develop`.

### 6b. Modo sub-agente
Si te lanzó un 🧠 como sub-agente: trabajá **solo** con este archivo y el PR (no asumas nada de la sesión que te lanzó) y devolvé el veredicto con el formato de §4.

## 7. Respuesta final (máx. 5 líneas) + traspaso
- `APROBADO` → **Próximo paso:** mergear PR #N · **ejecuta: 👤 dueño** · **Qué hacer:** GitHub → PR #N → "Squash and merge" → borrar la rama; después abrí <chat nuevo del agente de IntelliJ | sesión nueva de Claude Code> (según la primera de "Listas") y escribí «Seguí `docs/agents/implementer.md`».
- `CAMBIOS REQUERIDOS` → **ejecuta:** el mismo tipo de ejecutor que implementó · **Qué hacer:** abrí <chat nuevo del agente de IntelliJ | sesión nueva de Claude Code> y escribí «Seguí `docs/agents/implementer.md` para atender los cambios del PR #N».
- `ESCALAR` → **ejecuta: 🧠 modelo de frontera** (o 👤) · «Seguí `docs/agents/implementer.md` para retomar T-NNN (escalada desde la revisión del PR #N)».
