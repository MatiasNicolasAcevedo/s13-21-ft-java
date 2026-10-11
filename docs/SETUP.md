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

## Junie Lite (Free) en JetBrains Air 🤖
- **Qué es:** el nivel gratuito de Junie que usamos mediante el [plugin JetBrains Air](https://plugins.jetbrains.com/plugin/33314-air) en IntelliJ IDEA. La documentación activa lo llama **Junie Lite (Free)** o **Lite**; el nombre del modelo interno puede cambiar y no define nuestras tareas. Fuente: [documentación oficial de Junie Lite](https://junie.jetbrains.com/docs/junie-lite.html), consultada el 2026-10-11.
- **Configuración del dueño:** al preparar este repo, Lite era la opción gratuita habilitada en su instalación inicial de Air. Esto describe esa instalación, no una limitación permanente de Air. Elegí Junie Lite en el selector y comprobá qué herramientas tiene tu sesión; no asumimos 64K de contexto ni ausencia de `gh`/MCP.
- **Archivos de instrucciones:** `AGENTS.md` (fuente única), `.junie/guidelines.md` y `.aiassistant/rules/agents.md` (punteros). `.aiassistant/rules/agents.md` es compatibilidad con AI Assistant, un producto distinto; no hace falta configurar sus reglas para iniciar Lite en Air. La frase de arranque pide leer AGENTS explícitamente.
- **Sesiones:** abrí una sesión nueva en Air para una tarea/revisión nueva o un cambio de ejecutor. Para retomar la misma tarea, usá el prompt completo de [implementer §7](agents/implementer.md#7-contexto-largo), con notas persistidas, commit y push. Una sesión nueva no equivale a compactar ni hereda por sí sola el chat anterior. Si Air ofrece compactación, comprobá la acción disponible antes de usarla.
- **Modo y permisos:** usá el agente que edita archivos y ejecuta comandos. Cada aprobación explícita de un comando se persiste como indica la sección siguiente.
- **Arranque y traspasos:** cada traspaso a Lite debe contener un prompt listo para copiar, con tarea, contrato, rama, PR y acción. Ver [implementer §11](agents/implementer.md#11-respuesta-final-y-traspaso) y [reviewer §7](agents/reviewer.md#7-respuesta-final-y-traspaso).
- **Git y PR:** crea la rama, commitea y hace push. Si tiene `gh` o MCP, abre el draft; si no, deja el link de comparación, título y cuerpo completos para que el dueño lo abra. No toma otra tarea mientras haya PR abierto.

## Modelo de frontera 🧠
Es la categoría para trabajo de seguridad, arquitectura, infraestructura, migraciones y revisiones de riesgo. Ejemplos elegidos por el dueño: **GPT 6.1 Sol** u **Opus 5.5**, según disponibilidad en su entorno. El modelo y la herramienta son elecciones separadas: se puede trabajar con Codex, Claude Code o un agente configurado en Air. La etiqueta 🧠 no obliga a usar Claude Code ni certifica un catálogo de modelos.

En todos los casos, pedí leer `AGENTS.md` y seguir `docs/agents/implementer.md`, `reviewer.md` o `auditor.md`. Para Claude Code existe `CLAUDE.md` → `AGENTS.md` y `.claude/settings.json`; otros agentes usan sus propios controles de permisos. No asumas que una allowlist se comparte entre herramientas.

La compactación sigue [AGENTS §5](../AGENTS.md#5-gestión-de-contexto): dentro de la misma tarea, después de persistir notas, commit y push. `/compact` es un ejemplo para Claude Code; usá la acción disponible en tu herramienta o el prompt de reanudación en una sesión nueva. Al terminar una tarea, revisión o auditoría, abrí una sesión nueva para el siguiente paso.

## Permisos y allowlist personal de Junie
Archivo del dueño: **`C:\Users\matia\.junie\allowlist.json`** (fuera del repo). Por pedido explícito, cada comando que un agente consulte y el dueño apruebe debe quedar registrado allí para Junie, con el mismo alcance aprobado.

1. Leé el archivo actual y validá el JSON. En la instalación inspeccionada el 2026-10-11 usa `defaultBehavior`, `allowReadonlyCommands` y `rules.executables.rules`; las entradas existentes tienen `prefix` o `pattern` y `action`. Esto describe el archivo local: no inventes un esquema ni el significado de un patrón para otra versión.
2. Si una regla existente ya cubre el comando, informá que está cubierto y evitá duplicarla. En caso contrario, usá la función de la interfaz que permita guardar ese comando o una coincidencia exacta documentada para la versión instalada. No conviertas una aprobación puntual en un prefijo genérico como `git`, `docker` o un comodín.
3. Si editás el archivo, preservá opciones y reglas, guardá una copia temporal de respaldo fuera del repo, validá antes de reemplazar y revisá que el diff solo agregue la regla autorizada. Es JSON estricto: sin comentarios. Una validación fallida conserva el original.
4. Si el esquema/interfaz no permite representar el comando con precisión o escribir requiere un permiso adicional, dejá la instrucción para el dueño y reportá la persistencia pendiente. No edites otros archivos de permisos para sortear el bloqueo.
5. No copies esta configuración personal al repo, no registres secretos en reglas y no modifiques reglas previas sin pedido. Una aprobación automática del entorno no es una aprobación explícita del dueño; tampoco un “sí” a un comando autoriza todos sus variantes o argumentos.

La allowlist controla Junie; las restricciones del entorno del agente actual siguen vigentes. Documentación de referencia: [Action Allowlist del plugin Junie](https://junie.jetbrains.com/docs/junie-ide-plugin.html) y [formato JSON de la allowlist](https://youtrack.jetbrains.com/projects/JUNIE/issues/JUNIE-3948/Change-Junie-allowlist-file-format-from-JSON-to-something-that-allows-comments). Si Air muestra controles distintos, usá los que correspondan a la versión instalada y verificá qué archivo actualizan.
