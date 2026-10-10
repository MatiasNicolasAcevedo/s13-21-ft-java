# T-008 · Set up frontend test infrastructure (Vitest + RTL + MSW)
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `test/T-008-frontend-test-infra` (desde `develop` actualizado) · Depende de: T-004 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
El front no tiene ningún test (auditoría §6.7). Sin infraestructura, las tareas 🤖 de front (T-012) no pueden especificar tests de referencia.

## Objetivo
`npm test` corre Vitest con React Testing Library y MSW, con cobertura v8 y un umbral de trinquete; `verify.sh --client` lo ejecuta.

## Alcance
- Incluye: devDependencies compatibles con **Vite 5** (Vitest de la línea que soporte Vite 5 —verificar en npm—, `@testing-library/react`, `@testing-library/user-event`, `@testing-library/jest-dom`, `jsdom`, `msw`, `@vitest/coverage-v8`); `test` en `vite.config.js` (environment jsdom, setupFiles, coverage con umbral = base medida redondeada hacia abajo); scripts `test` (`vitest`) y `coverage`; `src/test/setup.js` + `src/test/server.js` (MSW con handlers para `/auth/login` y `/api/v1/users`); **test de referencia** `src/Routes/Login/Presentation/LoginInfo.test.jsx` (login OK guarda el token y navega; credenciales malas muestran error); actualizar `docs/TESTING.md` §3/§5 y `Walam_Front/README.md`.
- **No incluye:** subir Vite/React (P1), tests de otras pantallas, E2E (T-014).

## Leer antes
- `Walam_Front/package.json` · `Walam_Front/vite.config.js` · `src/Routes/Login/Presentation/LoginInfo.jsx` · `src/api/client.js` (de T-004) · `docs/TESTING.md`.

## Archivos previstos
- modificar: `package.json`, `package-lock.json`, `vite.config.js`, `.eslintrc.cjs` (globals de test si hace falta), `docs/TESTING.md`, `Walam_Front/README.md` · crear: `src/test/setup.js`, `src/test/server.js`, `src/Routes/Login/Presentation/LoginInfo.test.jsx`.

## Criterios de aceptación
- [ ] `cd Walam_Front && npm test -- --run` → tests en verde
- [ ] `./scripts/verify.sh --client` → `✅ lint ✅ build ✅ tests`
- [ ] Romper a propósito el guardado del token hace fallar el test (anotarlo en el PR)
- [ ] `docs/TESTING.md` tiene el archivo de referencia y el comando de un solo test verificado

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
