# T-005 · Remove unused frontend dependencies
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `chore/T-005-remove-unused-frontend-deps` (desde `develop` actualizado) · Depende de: T-003 · Spec/ADR: —
- Revisa: 🤖 agente gratuito (chat nuevo)

## Por qué
Dependencias sin ningún import en `src/` (auditoría §6.2): `dom`, `router` (con vulnerabilidad alta), `json-server` en `dependencies`; `standard`, `eslint-config-airbnb`, `eslint-config-standard` en `devDependencies` (no figuran en `.eslintrc.cjs`). Suman superficie de ataque y ruido en `npm audit`.

## Objetivo
`package.json` sin esas 6 dependencias y el front sigue compilando y pasando lint.

## Alcance
- Incluye: `cd Walam_Front && npm uninstall dom router json-server standard eslint-config-airbnb eslint-config-standard` (actualiza `package.json` y `package-lock.json`).
- **No incluye:** borrar `db/tasks.json`, actualizar otras dependencias, `npm audit fix`, tocar Redux/Firebase (son decisiones de 🧠, ya están en Backlog).

## Leer antes
- `Walam_Front/package.json` (completo) · `Walam_Front/.eslintrc.cjs`.

## Archivos previstos
- modificar: `Walam_Front/package.json`, `Walam_Front/package-lock.json` (no lo abras: lo genera npm).

## Tests
- Verificación por comando. Antes de desinstalar, confirmá que no hay imports: `grep -rnE "from '(dom|router|json-server)'" Walam_Front/src` → sin resultados.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --client` → `✅ lint ✅ build`
- [ ] `grep -cE '"(dom|router|json-server|standard|eslint-config-airbnb|eslint-config-standard)"' Walam_Front/package.json` → `0`
- [ ] `cd Walam_Front && npm audit 2>/dev/null | tail -1` muestra igual o menos vulnerabilidades que antes (anotá ambos números en el PR)

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
