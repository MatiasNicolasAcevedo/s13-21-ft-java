# Setup detallado

Lo que no entra en el [README](../README.md) (no lo repite). Lo marcado con † no se ejecutó en el bootstrap (2026-10-10): confirmalo al usarlo y sacá la marca.

## Variables de entorno

| Nombre | Para qué | Valor local | Obligatoria | Dónde se define en prod |
|---|---|---|---|---|
| `DB_URL` | URL JDBC de PostgreSQL | `jdbc:postgresql://localhost:5432/walam` (en compose: `db:5432`) | sí | Render → Environment |
| `DB_USERNAME` | usuario de la DB | `walam` | sí | Render → Environment |
| `DB_PASSWORD` | contraseña de la DB | `walam_local_pw` | sí | Render → Environment |
| `DB_PORT` | puerto publicado de la DB en compose (no la lee la app) | `5432` | no | — |
| `VITE_API_URL` | URL base del back para el front | `http://localhost:8080` | ⚠️ hoy ignorada (T-004) | Vercel → Environment Variables |
| JWT y mail | hoy hardcodeados en el código | — | — | se definen en [T-001](tasks/T-001-externalize-secrets.md) |

`Walam/.env` lo carga **spring-dotenv** desde el **directorio de trabajo** del proceso (no desde el classpath): correr `./mvnw` dentro de `Walam/`. Las variables de entorno del sistema tienen prioridad sobre el `.env`. En contenedores, `docker-compose.yml` las pasa directamente.

## Correr sin Docker †
Necesitás un PostgreSQL 14+ propio: creá la base y el usuario (`createdb walam`, etc.) y ajustá `DB_URL`, `DB_USERNAME` y `DB_PASSWORD` en `Walam/.env`. El resto es igual a la opción B del README.

## Puertos
| Servicio | Puerto | Cómo cambiarlo |
|---|---|---|
| PostgreSQL | 5432 | `DB_PORT=5433 docker compose up -d --wait` + `DB_URL` con `:5433` |
| Back | 8080 | † `cd Walam && ./mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=8081` (y `VITE_API_URL`) |
| Front (Vite) | 5173 | † `npm run dev -- --port 5174` |
| Front (compose) | 5173 → 80 (nginx) | editar `ports` del servicio `client` |

## IDE
- **IntelliJ IDEA:** abrí la **raíz** del repo; importá `Walam/pom.xml` como proyecto Maven (o "Add as Maven project"). SDK: Temurin 17. Activá *annotation processing* (Lombok/MapStruct). Run config: `WalamApplication` con *Working directory* = `$MODULE_WORKING_DIR$` (`Walam/`) para que lea `Walam/.env`.
- **VS Code:** extensiones "Extension Pack for Java", "Spring Boot Extension Pack", "ESLint", "Tailwind CSS IntelliSense".

## Debugging
- † Back: `cd Walam && ./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"` y "Attach to remote JVM" en el puerto 5005.
- SQL: poner `spring.jpa.show-sql: true` solo localmente (no commitear).
- Front: React DevTools + pestaña Network (fijate a qué host van las llamadas).

## Resetear datos
Hoy cada arranque del back recrea el esquema (`ddl-auto: create`). Para borrar también el volumen: `docker compose down -v && docker compose up -d --wait`. Usuario demo: `./scripts/dev.sh` lo crea; a mano, ver el paso 7 del README.

## Agente gratuito de IntelliJ (🤖)
- **Qué es:** el agente de IA gratuito integrado en IntelliJ IDEA, con un modelo Qwen. Supuestos: ~64K tokens de contexto efectivo, **sin** `gh` ni MCP de GitHub (solo `git` en la terminal del IDE), **sin** `/compact`. ⚠️ No verificado: cuál es exactamente el producto/plan gratuito; las docs de JetBrains confirman que sus agentes leen **`AGENTS.md`** (Junie, configurable) y que el chat usa **reglas de proyecto** en `.aiassistant/rules/`.
- **Archivos de instrucciones:** `AGENTS.md` (fuente única), `.junie/guidelines.md` y `.aiassistant/rules/agents.md` (punteros de una línea). En *Settings → Tools → AI Assistant → Rules* marcá la regla `agents` como **Always**. Si tu agente no lee ninguno, la frase de arranque lo cubre.
- **Chat nuevo:** panel de AI → botón **New chat** (= "compactar").
- **Modo:** usá el modo **agente** (que edita archivos y corre comandos), no solo chat.
- **Terminal:** cuando pida correr un comando, aprobalo (o habilitá "allow" para comandos de solo lectura y `./scripts/verify.sh`).
- **Frase de arranque:** «Leé `AGENTS.md` y seguí `docs/agents/implementer.md`».
- **Git y PR:** crea la rama, commitea y hace `git push -u origin <rama>`; como no tiene `gh`, te deja el link `https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/compare/develop...<rama>?expand=1` con título y cuerpo: **vos abrís el PR** (draft) desde ese link.

## Modelo de frontera (🧠)
Claude Code (CLI, web o IDE) con acceso a GitHub (`gh` o MCP). Lee `CLAUDE.md` → `AGENTS.md`. Permisos del proyecto en `.claude/settings.json` (allowlist de comandos seguros; deniega push forzado, push a `develop`/`main` y leer `.env` reales). Frase de arranque: «Seguí `docs/agents/implementer.md`» (o `reviewer.md` / `auditor.md`).
