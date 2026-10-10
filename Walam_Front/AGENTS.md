# Walam_Front (front) · específico para agentes
Leé primero el [AGENTS.md raíz](../AGENTS.md). Esto solo agrega lo del front.

- Corré todo desde `Walam_Front/`. Gate: `../scripts/verify.sh --client` (lint + build + tests si existen).
- Estilo actual: JavaScript (JSX), 2 espacios, sin `;`, comillas simples, Tailwind en `className`, `react-icons`.
- Patrón por pantalla: `src/Routes/<Pantalla>/Component/<Pantalla>.jsx` (contenedor) + `Presentation/<Pantalla>Layout.jsx` y `<Pantalla>Info.jsx` (vista; hoy también hace las llamadas a la API). Referencia: `src/Routes/Login/`.
- Formularios: Formik + Yup (referencia `src/Routes/Register/Presentation/RegisterInfo.jsx`).
- Llamadas HTTP: hoy `axios` directo con URL hardcodeada; después de T-004 **usá siempre el cliente único** que esa tarea crea, nunca una URL literal.
- No abras `package-lock.json` ni `dist/`. `npm audit` muestra vulnerabilidades conocidas: no corras `npm audit fix --force` sin tarea.
- Variables nuevas: `VITE_*` en `.env.example` con comentario (regla de `.example`).
