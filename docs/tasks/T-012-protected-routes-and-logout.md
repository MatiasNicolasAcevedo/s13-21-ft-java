# T-012 · Protect private routes and clear the session on logout
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 Junie Lite
- Fase: P0 Estabilizar
- Rama: `fix/T-012-protected-routes-and-logout` (desde `develop` actualizado) · Depende de: T-008 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca autenticación)

## Prompt de arranque para Junie Lite (usar cuando sea la primera de Listas)
```text
Leé AGENTS.md y seguí docs/agents/implementer.md para implementar T-012.
Ejecutor: Junie Lite (Free) en JetBrains Air.
Contrato: docs/tasks/T-012-protected-routes-and-logout.md. Rama exacta: fix/T-012-protected-routes-and-logout.
Confirmá que no haya PR de tarea abierto y que T-012 sea la primera de Listas; si no, entregá el traspaso correcto y detenete.
Confirmá el merge anterior y conciliá su documentación en el primer commit de esta nueva rama.
Al cerrar o cambiar de contexto, persistí notas, commiteá y publicá todos los cambios propios y comprobá árbol limpio.
```

## Por qué
`/DashboardUser` y el resto de las rutas privadas se abren sin login (auditoría §6.5: `Walam_Front/src/Router/index.jsx:56-64`). "Cerrar sesión" es solo un link a `/` y no borra el token (`src/components/Navbar/LinkMenu.jsx:55`).

## Objetivo
Sin token, cualquier ruta hija de `UserLayout` redirige a `/Login`; "Cerrar sesión" borra `token` y `username` de `localStorage` y navega a `/Login`.

## Alcance
- Incluye (diseño decidido por 🧠):
  1. Crear `src/components/RequireAuth/RequireAuth.jsx`: si `window.localStorage.getItem('token')` es nulo → `<Navigate to='/Login' replace />`; si no → `children`.
  2. En `src/Router/index.jsx`, envolver el `element` de la ruta de `UserLayout` (líneas ~56-64) con `<RequireAuth>…</RequireAuth>`.
  3. En `LinkMenu.jsx:55`, reemplazar el `Link` por un `button` (mismas clases) que haga `localStorage.removeItem('token')`, `localStorage.removeItem('username')` y `navigate('/Login')`.
- **No incluye:** validar expiración del JWT, refresh, cambiar el back, rediseño visual.

## Leer antes
- `src/Router/index.jsx` · `src/components/Navbar/LinkMenu.jsx` · `src/Routes/Login/Presentation/LoginInfo.test.jsx` (referencia de T-008) · `docs/TESTING.md` §3.

## Archivos previstos
- crear: `src/components/RequireAuth/RequireAuth.jsx`, `RequireAuth.test.jsx`, `src/components/Navbar/LinkMenu.test.jsx` · modificar: `src/Router/index.jsx`, `LinkMenu.jsx`.

## Tests (con el estilo de `LoginInfo.test.jsx`)
- `RequireAuth`: sin token renderiza la pantalla de login (usar `MemoryRouter`); con token renderiza el hijo.
- `LinkMenu`: click en "Cerrar sesión" borra `token` y `username`.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --client` → `✅ lint ✅ build ✅ tests`
- [ ] Manual con `./scripts/dev.sh`: en una ventana privada, http://localhost:5173/DashboardUser redirige a `/Login`; después de login y "Cerrar sesión", volver atrás no muestra el dashboard

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
