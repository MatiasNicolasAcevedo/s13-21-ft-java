# T-001 · Move hardcoded secrets to environment configuration
- Estado: Lista · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🧠 modelo de frontera
- Fase: P0 Estabilizar
- Rama: `fix/T-001-externalize-secrets` (crearla desde `develop` actualizado antes del primer commit) · Depende de: — · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (sesión nueva) + 👤 dueño

## Por qué
🔴 Secretos commiteados: secreto JWT en `Walam/src/main/java/org/nocountry/walam/main/auth/service/JwtService.java:25`; usuario y app password de Gmail en `Walam/src/main/resources/application.yaml:34-35` y como default en `email/config/EmailConfig.java:16,19`. Auditoría §6.6.

## Objetivo
El back lee el secreto JWT y las credenciales SMTP **solo** de variables de entorno; el árbol actual no contiene esos valores.

## Alcance
- Incluye: propiedades `jwt.secret` (← `JWT_SECRET`), `jwt.expiration-ms` (← `JWT_EXPIRATION_MS`, default 3 h), `email.username`/`email.password` (← `MAIL_USERNAME`/`MAIL_PASSWORD`, sin default), host/port con default; fallo rápido al arrancar si falta `JWT_SECRET`; `Walam/.env.example` y `docker-compose.yml` con valores **nuevos e inventados** (`openssl rand -base64 32` para el JWT; mail vacío o de prueba); `docs/SETUP.md` (tabla de variables); README §"Configurar variables" (lista de prod).
- **No incluye:** rotar los secretos reales (lo hace el 👤 en T-015), reescribir el historial de git, cambiar el algoritmo/firma del JWT, autorización de endpoints (T-002).

## Leer antes
- `auth/service/JwtService.java` (completo, 139 líneas) · `email/config/EmailConfig.java:13-45` · `application.yaml` · `Walam/.env.example` · `docs/SETUP.md` §Variables.

## Archivos previstos
- modificar: `JwtService.java`, `EmailConfig.java`, `application.yaml`, `Walam/.env.example`, `docker-compose.yml`, `docs/SETUP.md`, `README.md` · crear: `src/test/java/.../auth/service/JwtServiceTest.java`, `src/test/resources/application-test.yaml` o propiedades de test equivalentes.

## Tests
- Unitario `JwtServiceTest`: genera token para un `UserDetails` y lo valida; token con otra clave → inválido; token expirado (expiración configurable) → inválido.
- El test de contexto sigue pasando con `JWT_SECRET` definido para tests (sin valor real).

## Pasos sugeridos
1. Inyectar `@Value("${jwt.secret}")` (o `@ConfigurationProperties`) en `JwtService`; quitar la constante.
2. Quitar los defaults literales de `EmailConfig` y los valores de `application.yaml:34-35` (dejar `${MAIL_USERNAME:}`).
3. Generar valores locales nuevos para el `.example` y el compose; documentar.
4. `git grep` de los prefijos de los valores viejos (sin pegarlos en ningún archivo) → 0 resultados.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa (y el resumen muestra más tests que antes)
- [ ] `git grep -n "SECRET_KEY =" Walam/` no devuelve nada y `application.yaml` no tiene credenciales
- [ ] Sin `JWT_SECRET` el back no arranca y el log dice qué falta; con `cp Walam/.env.example Walam/.env` arranca sin editar nada
- [ ] `docker compose --profile app up -d --build --wait` + register/login del README siguen funcionando
- [ ] `.example`, compose, SETUP y README actualizados

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
