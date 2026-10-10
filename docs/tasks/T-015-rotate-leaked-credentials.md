# T-015 · Rotate the credentials leaked in the repository
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 👤 dueño
- Fase: P0 Estabilizar
- Rama: — (no hay cambios de código) · Depende de: — (los pasos 3–4 esperan a que T-001 esté mergeado y desplegado) · Spec/ADR: —
- Revisa: 👤 dueño

## Por qué
🔴 Hay credenciales commiteadas y siguen en el historial de git aunque T-001 las saque del código (auditoría §6.6): app password de Gmail (`Walam/src/main/resources/application.yaml:34-35`, `EmailConfig.java:16,19`), secreto JWT (`JwtService.java:25`) y la clave web de Firebase (`Walam_Front/src/firebase/firebase.js:10`). **Borrarlas no alcanza: hay que invalidarlas.**

## Objetivo
Ninguna credencial presente en el historial sigue siendo válida.

## Pasos
1. **Ya (no espera a nadie):** entrá a la cuenta de Google del mail que figura en `application.yaml:34` → https://myaccount.google.com/apppasswords → **revocá** la contraseña de aplicación. Si la cuenta no es tuya, pedíselo a quien la administre o dala por comprometida.
2. **Ya:** en https://console.cloud.google.com/apis/credentials (proyecto de Firebase `ecopay-…`) → la API key del navegador → **Application restrictions: HTTP referrers** con tu dominio de Vercel y `localhost:5173`; o rotala (Regenerate key) y actualizá Vercel cuando exista `VITE_FIREBASE_*`.
3. **Después de mergear T-001:** generá un secreto nuevo con `openssl rand -base64 32` y cargalo en Render → servicio del back → Environment → `JWT_SECRET` (y `MAIL_USERNAME`/`MAIL_PASSWORD` con una app password nueva si querés mantener el mail). Redeploy. Todos los tokens viejos dejan de servir (es lo esperado).
4. Opcional: activá *Secret scanning* y *Push protection* en GitHub → Settings → Code security.
5. Opcional (decisión): reescribir el historial con `git filter-repo` no es necesario si rotaste todo; si igual lo querés, pedí una tarea 🧠 (rompe los clones existentes).

## Criterios de aceptación
- [ ] La app password vieja figura como revocada
- [ ] La API key de Firebase tiene restricción por referrer o fue regenerada
- [ ] Render tiene `JWT_SECRET` nuevo (después de T-001)
- [ ] Anotado en `docs/STATUS.md` → "Decisiones pendientes" como resuelto

## Notas
- Hecho: … · Pendiente: …
