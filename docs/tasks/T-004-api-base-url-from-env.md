# T-004 · Read the API base URL from VITE_API_URL (shared client, part 1)
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `refactor/T-004-api-base-url-from-env` (desde `develop` actualizado) · Depende de: T-003 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca configuración)

## Por qué
El front llama siempre a producción: `https://s13-21-ft-java.onrender.com` está hardcodeado en 15 llamadas de 13 archivos (`grep -rn onrender Walam_Front/src`). No se puede desarrollar ni testear contra el back local. Auditoría §6.4.

## Objetivo
Existe un cliente HTTP único que usa `import.meta.env.VITE_API_URL` y agrega el token; las pantallas de autenticación y del dashboard lo usan.

## Alcance
- Incluye:
  1. Crear `Walam_Front/src/api/client.js` exactamente así (decisión de 🧠):
     ```js
     import axios from 'axios'

     const client = axios.create({
       baseURL: import.meta.env.VITE_API_URL ?? 'http://localhost:8080'
     })

     client.interceptors.request.use((config) => {
       const token = window.localStorage.getItem('token')
       if (token) config.headers.Authorization = `Bearer ${token}`
       return config
     })

     export default client
     ```
  2. En estos archivos, reemplazar `axios.<método>('https://s13-21-ft-java.onrender.com/<ruta>'` por `client.<método>('/<ruta>'`, cambiar `import axios from 'axios'` por `import client from '<ruta relativa>/api/client'` y borrar las líneas `axios.defaults.headers.common.Authorization = ...` y el `const token = window.localStorage.getItem('token')` que solo servía para eso: `src/Routes/Login/Presentation/LoginInfo.jsx:17` · `src/Routes/Register/Presentation/RegisterInfo.jsx:43` · `src/Context/BalanceContext.jsx:14` · `src/Routes/DashboardUser/Presentation/DashboardUserInfo.jsx:26` · `src/components/DashboardDesktop/DashboardDesktop.jsx:24` · `src/Routes/CVUUser/Presentation/CVUUserInfo.jsx:15`.
  3. En `Walam_Front/.env.example` quitar la línea "⚠️ Hoy el código NO la usa…" y la siguiente, y dejar: `# URL base del backend. Para producción se define en Vercel.`
- **No incluye:** los otros 7 archivos (van en T-017), cambiar rutas del back, manejo de errores, mover lógica entre componentes, TypeScript, tests de componentes (T-008).

## Leer antes
- `Walam_Front/AGENTS.md` · `Walam_Front/.env.example` · cada archivo de la lista, ±10 líneas alrededor de la línea citada.

## Archivos previstos
- crear: `src/api/client.js` · modificar: los 6 archivos de la lista + `.env.example` (todo en `Walam_Front/`).

## Tests
- Sin infraestructura de tests de front todavía (T-008). Verificación por comando (abajo) y manual con el back local.

## Pasos sugeridos
1. Crear `client.js`. 2. Migrar un archivo, `npm run lint && npm run build`. 3. Repetir con el resto. 4. Prueba manual con `./scripts/dev.sh`.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --client` → `✅ lint ✅ build`
- [ ] `grep -c onrender` en los 6 archivos migrados → 0 en cada uno (`grep -rln onrender Walam_Front/src | wc -l` → `7`)
- [ ] Con `./scripts/dev.sh`, login en http://localhost:5173/Login con `demo` / `Demo1234!` lleva al dashboard y en la pestaña Network las llamadas van a `localhost:8080`
- [ ] `npm run build` con `VITE_API_URL=http://example.test` y `grep -l example.test dist/assets/*.js` encuentra al menos un archivo

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: T-017
