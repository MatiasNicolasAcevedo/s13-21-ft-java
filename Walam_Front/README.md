# Walam_Front · front (React + Vite)

Interfaz de EcoPay. Visión general y modo "todo en contenedores": [README raíz](../README.md).

## Configurar y correr (desde `Walam_Front/`)
1. **Node 22** (`.nvmrc` en la raíz): `nvm install` desde la raíz. Resultado esperado: `node -v` → `v22.x`.
2. **Configuración local:**
   ```bash
   cp .env.example .env.local
   ```
   Resultado esperado: existe `.env.local`. ⚠️ Hoy `VITE_API_URL` no se usa: todas las llamadas van a producción hasta [T-004](../docs/tasks/T-004-api-base-url-from-env.md).
3. **Dependencias:**
   ```bash
   npm ci
   ```
   Resultado esperado: `added NNN packages` (aparecen avisos de `npm audit`: conocidos).
4. **Arrancar:**
   ```bash
   npm run dev
   ```
   Resultado esperado: `Local: http://localhost:5173/`.

## Comandos
| Para | Comando |
|---|---|
| Gate del front (lint + build + tests) | `../scripts/verify.sh --client` |
| Desarrollo | `npm run dev` |
| Lint | `npm run lint` (⚠️ hoy falla: [T-003](../docs/tasks/T-003-fix-frontend-lint.md)) |
| Build | `npm run build` → `dist/` |
| Preview del build | `npm run preview` |
| Tests / un solo test | todavía no hay ([T-008](../docs/tasks/T-008-frontend-test-infra.md)); después: `npx vitest run src/.../X.test.jsx` |
| Imagen Docker local | `docker build -t walam-client .` (nginx; no es la de Vercel) |

## Estructura
```
src/
  Router/index.jsx           rutas (createBrowserRouter)
  Layouts/                   MainLayout (público), UserLayout (privado), PrivateLayout
  Routes/<Pantalla>/
    Component/<Pantalla>.jsx contenedor
    Presentation/*Layout.jsx, *Info.jsx  vista + lógica de API
  components/<Nombre>/       reutilizables (Navbar, FormInput, Modal, …)
  Context/BalanceContext.jsx saldo del usuario
  api/                       store de Redux (sin uso)
  firebase/firebase.js       Analytics + login Google
public/img/                  imágenes estáticas
db/tasks.json                mock viejo de json-server (sin uso)
```
Instrucciones para agentes: [AGENTS.md](AGENTS.md).
