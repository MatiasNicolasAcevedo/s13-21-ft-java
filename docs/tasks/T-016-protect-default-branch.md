# T-016 · Protect the default branch and clean up branches
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 👤 dueño
- Fase: P0 Estabilizar
- Rama: — · Depende de: — (los checks requeridos se agregan cuando exista T-007) · Spec/ADR: —
- Revisa: 👤 dueño

## Por qué
`develop` no tiene protección (auditoría §6.9) y hay una rama vieja sin mergear (`matias/api-run`).

## Pasos en GitHub (Settings del repo)
0. **Decisión (opcional):** renombrar `develop` → `main` en *Settings → General → Default branch* (GitHub redirige PRs y links). Si lo hacés, pedí una tarea 🤖 que reemplace `develop` por `main` en los `.md`, `.claude/settings.json` y `scripts/`.
1. *Settings → General → Pull Requests*: dejar solo **Allow squash merging** (default message: "Pull request title"), activar **Automatically delete head branches** y **Always suggest updating pull request branches**.
2. *Settings → Rules → Rulesets → New branch ruleset*: nombre `default-branch`, Enforcement **Active**, Target **Default branch**. Reglas:
   - Restrict deletions · Block force pushes · Require linear history
   - Require a pull request before merging (0 aprobaciones requeridas mientras no haya cuenta bot; **Require conversation resolution**)
   - Require status checks to pass + **Require branches to be up to date**: agregar `conventional-title` ahora; `server` y `client` cuando T-007 esté mergeado (`e2e` con T-014).
   - Bypass list: vacía (o solo vos, para emergencias).
3. Limpiar ramas (desde una terminal con el repo clonado):
   ```bash
   git fetch --prune origin
   ```
   ```bash
   git tag archive/matias-api-run origin/matias/api-run && git push origin archive/matias-api-run
   ```
   ```bash
   git push origin --delete matias/api-run
   ```
   La rama queda preservada en el tag (su idea útil ya está en T-002 y en Backlog). Ramas locales ya mergeadas: `git branch --merged develop | grep -vE '^\*|develop' | xargs -r git branch -d`.

## Criterios de aceptación
- [ ] Un `git push origin develop` directo es rechazado
- [ ] El ruleset muestra los checks requeridos
- [ ] `git ls-remote --heads origin` lista solo `develop` y las ramas de PR abiertos
- [ ] `docs/STATUS.md` actualizado (lo hace el próximo PR)

## Notas
- Hecho: … · Pendiente: …
