# T-003 · Fix frontend lint errors so verify passes
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 Junie Lite
- Fase: P0 Estabilizar
- Rama: `fix/T-003-frontend-lint` (desde `develop` actualizado) · Depende de: — · Spec/ADR: —
- Revisa: 🤖 Junie Lite (chat nuevo)

## Prompt de arranque para Junie Lite (usar cuando sea la primera de Listas)
```text
Leé AGENTS.md y seguí docs/agents/implementer.md para implementar T-003.
Ejecutor: Junie Lite (Free) en JetBrains Air.
Contrato: docs/tasks/T-003-fix-frontend-lint.md. Rama exacta: fix/T-003-frontend-lint.
Confirmá que no haya PR de tarea abierto y que T-003 sea la primera de Listas; si no, entregá el traspaso correcto y detenete.
Confirmá el merge anterior y conciliá su documentación en el primer commit de esta nueva rama.
Al cerrar o cambiar de contexto, persistí notas, commiteá y publicá todos los cambios propios y comprobá árbol limpio.
```

## Por qué
`npm run lint` falla con 64 problemas (62 errores, 2 warnings; el script usa `--max-warnings 0`), así que `./scripts/verify.sh --client` está en rojo. 53 son `react/prop-types`. Auditoría §6.10.

## Objetivo
`cd Walam_Front && npm run lint` termina con código 0, sin cambiar el comportamiento de la app.

## Alcance
- Incluye (decisiones ya tomadas por 🧠, no las cambies):
  1. En `Walam_Front/.eslintrc.cjs`, dentro de `rules`, agregar `'react/prop-types': 'off'` con el comentario `// El proyecto migrará a TypeScript (P2); React 19 ya no valida propTypes.`
  2. Borrar imports sin uso: `import React from 'react'` en `src/Routes/OnBoarding/Presentation/OnBoardingLayout.jsx:1` y en los 5 archivos de `src/components/Loader/` (línea 1 de `Loader.jsx`, `Component/Loader.jsx`, `Presentation/Loader.jsx`, `Presentation/LoaderElements.jsx`, `Presentation/LoaderLayout.jsx`); `Navbar` en `src/Routes/OnBoarding/Presentation/OnBoarding.jsx:3`; el parámetro `transactions` sin uso en `src/Routes/HistoryDetails/Presentation/HistoryDetailsInfo.jsx:6`.
  3. `src/Routes/OnBoarding/Presentation/OnBoardingInfo.jsx:82`: reemplazar cada `"` del texto JSX por `&quot;`.
  4. `src/Routes/UsersDataForm/Presentation/UsersDataFormInfo.jsx`: borrar las dos líneas `console.log(userData)` y `console.log(formValues)` dentro del `useEffect` (≈ líneas 40-41). Eso elimina el warning `react-hooks/exhaustive-deps` sin tocar el array de dependencias.
  5. `src/Context/BalanceContext.jsx:31`: agregar arriba de `export const useBalance` la línea `// eslint-disable-next-line react-refresh/only-export-components`.
- **No incluye:** agregar PropTypes, cambiar lógica, renombrar archivos, actualizar ESLint o plugins, tocar otras reglas, sacar otros `console.log`.

## Leer antes
- `Walam_Front/.eslintrc.cjs` (completo, 21 líneas) · `Walam_Front/AGENTS.md` · las líneas citadas arriba (±5 líneas).

## Archivos previstos
- modificar: `.eslintrc.cjs` y los 10 archivos citados (todos dentro de `Walam_Front/`). Diff esperado < 40 líneas.

## Tests
- No hay infraestructura de tests de front (llega con T-008). La verificación es por comando: lint + build.

## Pasos sugeridos
1. `cd Walam_Front && npm ci` (si falta `node_modules`) y `npm run lint` para ver la lista.
2. Aplicar 1–5 de a uno; repetir `npm run lint`.
3. `npm run build` para confirmar que nada se rompió.

## Criterios de aceptación
- [ ] `cd Walam_Front && npm run lint` → exit 0, sin errores ni warnings
- [ ] `cd Walam_Front && npm run build` → `✓ built in …`
- [ ] `./scripts/verify.sh --client` → `client: ✅ lint ✅ build ⚠️ sin tests`
- [ ] `git diff --stat develop` muestra solo archivos de `Walam_Front/` (más tablero/STATUS/tarea)

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
