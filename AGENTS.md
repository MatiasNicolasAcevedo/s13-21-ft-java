# AGENTS.md · Cómo trabajar en este repo

## 1. Qué es y quién hace qué
EcoPay (código: Walam): billetera virtual de un hackathon de No Country, retomada para portfolio. Monorepo:

| Carpeta | Qué es | Instrucciones propias |
|---|---|---|
| `Walam/` | back Spring Boot (API REST + JWT + PostgreSQL) | [Walam/AGENTS.md](Walam/AGENTS.md) |
| `Walam_Front/` | front React + Vite | [Walam_Front/AGENTS.md](Walam_Front/AGENTS.md) |
| `docs/` | estado, tablero, tareas, protocolos, auditorías | ver §7 |
| `scripts/` | `verify.sh` (gate), `dev.sh` (entorno local) | — |

| Ícono | Ejecutor | Hace |
|---|---|---|
| 🧠 | **Modelo de frontera** (p. ej. GPT 6.1 Sol u Opus 5.5, según disponibilidad) | seguridad, infra de tests/CI/contenedores, arquitectura, migraciones, specs y tareas, revisiones riesgosas, auditorías |
| 🤖 | **Junie Lite (Free)** en IntelliJ IDEA mediante [JetBrains Air](https://plugins.jetbrains.com/plugin/33314-air) | tareas chicas y bien especificadas, de a una, con tests; revisiones de PRs chicos |
| 👤 | **Dueño** | decide, configura GitHub, rota secretos, mergea, **cambia de agente** |

Los íconos identifican la capacidad requerida, no una marca de herramienta. 🧠 puede trabajar en Codex, Claude Code o Air con el modelo elegido por el dueño; 🤖 significa siempre Junie Lite (Free). No fijes el flujo al modelo interno de Lite ni asumas un tamaño de contexto o herramientas disponibles: ver [SETUP](docs/SETUP.md#junie-lite-free-en-jetbrains-air-).

Ningún agente lanza a otro, salvo revisión con sub-agente pedida explícitamente por el dueño para ese PR. Si el próximo paso es de otro ejecutor, terminá con un **traspaso**:
> **Próximo paso:** T-NNN · <título> · **ejecuta: 🤖 Junie Lite (Free, JetBrains Air)** | **🧠 modelo de frontera** | **👤 dueño**
> **Qué hacer:** abrí <sesión nueva de Junie Lite en Air | una sesión nueva con un modelo de frontera | GitHub → …> y escribí: «Seguí `docs/agents/implementer.md`»

**Todo traspaso a Lite incluye un bloque de texto completo para copiar**, con tarea, archivo, rama, PR si existe, protocolo y acción concreta. Usá el formato de [implementer §11](docs/agents/implementer.md#11-respuesta-final-y-traspaso) o [reviewer §7](docs/agents/reviewer.md#7-respuesta-final-y-traspaso); reemplazá todos los placeholders. No basta con indicar qué archivo leer.

## 2. Stack (versiones reales)
Back: Java 17 (compila y testea también con 21), Spring Boot 3.2.2, Spring Security + jjwt 0.12.5, Data JPA/Hibernate (`ddl-auto: create`), PostgreSQL 17 (local), Lombok, MapStruct 1.5.5, springdoc 2.3.0, Maven Wrapper 3.9.5. Front: React 18.2, Vite 5, JavaScript (sin TS), React Router 6, Tailwind 3, axios, Formik + Yup, ESLint 8. Node 22 (`.nvmrc`).

## 3. Comandos verificados
| Para | Comando (desde la raíz salvo indicación) |
|---|---|
| Setup completo | ver [README → Levantar el proyecto en local](README.md#levantar-el-proyecto-en-local) |
| Solo la DB | `docker compose up -d --wait` |
| Todo en contenedores | `docker compose --profile app up -d --build --wait` · apagar: `docker compose --profile app down -v` |
| Desarrollo | `./scripts/dev.sh` (`Ctrl+C` corta; `--down` apaga la DB) |
| **Gate** | `./scripts/verify.sh` (o `--server` / `--client`); logs en `.verify-logs/` |
| Un test de back | `cd Walam && ./mvnw -B test -Dtest=WalamApplicationTests#contextLoads` (necesita la DB) |
| Un test de front | todavía no hay infraestructura (T-008); después: `cd Walam_Front && npx vitest run <archivo>` |
| E2E | todavía no existe (T-014) |

## 4. Protocolo de sesión
1. Leé `docs/STATUS.md` y `docs/BACKLOG.md`; mirá los PR abiertos (`gh pr list` o `git ls-remote --heads origin`).
2. **Una tarea por sesión y una a la vez:** si hay un PR de tarea abierto, no empieces otra.
3. Tomá **siempre la primera** de "Listas". Si no te corresponde (🧠 o 👤), avisá con el traspaso y terminá.
4. **Antes del primer commit**, creá la rama con el nombre exacto de la tarea; PR draft enseguida.
5. Tests en el mismo PR. Al terminar: `./scripts/verify.sh` sin regresiones, tablero/tarea/STATUS actualizados, PR listo y sugerí sesión nueva. Una tarea terminada de implementar queda **En revisión** hasta el merge.
6. **Documentación posterior al merge:** al iniciar la siguiente tarea, quien implementa confirma el merge anterior y actualiza tarea/tablero/STATUS en el primer commit de la nueva rama. El revisor entrega veredicto y traspaso en su respuesta o en GitHub; **no edita documentación local para registrar un merge o la siguiente tarea**.
7. **Sin cambios olvidados:** registrá `git status --short` al inicio; antes de cerrar, traspasar o compactar, revisá diff y archivos nuevos, commiteá los cambios propios (incluida documentación), hacé push y confirmá árbol limpio y rama sincronizada. No uses `git add .` a ciegas ni borres cambios ajenos. Si hay cambios previos, identificá su dueño y reportalos; si commit/push está bloqueado, informá archivos y causa y dejá el cierre como pendiente.
Detalle: [implementer](docs/agents/implementer.md) · [reviewer](docs/agents/reviewer.md) · [auditor](docs/agents/auditor.md) (solo 🧠).

## 5. Gestión de contexto
1. **Una tarea = una sesión.** Al cerrar una tarea, revisión o auditoría, sugerí una sesión nueva (mejor que compactar).
2. **Cuándo:** solo mientras sigue abierta la misma tarea larga, al cerrar una sub-etapa segura y si el contexto se acerca a ~60 % (🧠) o ~50 % (🤖), o notás degradación (releer, repetir intentos, olvidar decisiones). Son umbrales orientativos si la herramienta muestra el uso; no inventes porcentajes. Tener logs viejos por sí solo no exige compactar.
3. **Antes de continuar:** completá "Notas de implementación" con tarea, rama, PR, commit, hecho, decisiones, comandos/resultados de verificación, limitaciones, pendientes y siguiente acción; commit, push y comprobación de árbol limpio. Si no podés persistirlo, explicitá el bloqueo antes del cambio de contexto.
4. **Cómo:** si la herramienta ofrece compactación, usá su acción documentada. `/compact` es un ejemplo para Claude Code; no asumas ese comando en Codex o Air. Conservá tarea, rama/PR, decisiones, verificación y siguiente acción. Descartá logs y contenido ya procesado. Si no ofrece compactación, abrí una sesión nueva con un prompt de reanudación completo (Lite: [implementer §7](docs/agents/implementer.md#7-contexto-largo)). Abrir una sesión nueva **no conserva** la conversación anterior por sí solo.
5. **Después:** continuá la misma tarea; releé AGENTS, el protocolo y las notas, verificá rama/PR/commit y retomá el pendiente. No tomes la siguiente de la cola. Al cerrar una tarea/revisión/auditoría, o cambiar de ejecutor, abrí sesión nueva; no compactes justo antes de terminar ni para encadenar tareas.
6. Higiene: salida acotada (`| tail -n 40`, logs a archivo + `grep`); grep/glob antes de abrir; leé por rangos; no abras `package-lock.json`, `target/`, `node_modules/`, `dist/`, `.verify-logs/` ni `docs/archive/`.

## 6. Configuración
**Regla permanente:** todo archivo de configuración con valores por entorno tiene su `.example` commiteado y el real en `.gitignore`.
| Ejemplo | Copiar a | Lo lee |
|---|---|---|
| `Walam/.env.example` | `Walam/.env` | spring-dotenv, desde el directorio de trabajo (`Walam/`) |
| `Walam_Front/.env.example` | `Walam_Front/.env.local` | Vite (`VITE_*`) |
Si agregás o renombrás una variable: actualizá en el **mismo PR** su `.example` (con comentario y valor local válido), `docker-compose.yml`, `docs/SETUP.md` y el README si cambia un paso. Nunca valores reales.

### Permisos de comandos y allowlist personal
Por pedido del dueño, **cada comando que el agente consulte y el dueño apruebe explícitamente** se registra en `C:\Users\matia\.junie\allowlist.json`. La aprobación del comando autoriza persistir ese mismo alcance para Junie; no autoriza comandos más amplios. Ver [SETUP](docs/SETUP.md#permisos-y-allowlist-personal-de-junie).
- Leé el JSON existente y respetá su esquema; verificá si la regla ya cubre el comando, evitá duplicados y agregá una coincidencia exacta o la forma más acotada que admita la versión instalada.
- Conservá todas las reglas y opciones existentes; validá el JSON y revisá el diff antes de guardar. No agregues comentarios JSON ni permisos globales, prefijos amplios o comodines a partir de una aprobación puntual.
- Si la interfaz permite guardar el permiso aprobado, usala; si el esquema no permite representarlo con precisión, entregá la instrucción para la interfaz. Si escribir está bloqueado, informalo y dejá explícito qué comando falta persistir. No cambies otros archivos de permisos para sortearlo.
- La allowlist es personal, fuera del repo: no se commitea ni reemplaza los permisos de Codex/Claude u otro entorno. Las aprobaciones automáticas de una herramienta no equivalen a una aprobación explícita del dueño.

## 7. Mapa de documentación
| Archivo | Qué contiene | Cuándo leerlo |
|---|---|---|
| `docs/STATUS.md` | dónde estamos y próximo paso | siempre, al empezar |
| `docs/BACKLOG.md` | tablero y cola | siempre, al empezar |
| `docs/tasks/T-NNN-*.md` | contrato de cada tarea | la tuya |
| `docs/agents/*.md` | protocolos de sesión | el de tu sesión |
| `CONTRIBUTING.md` | ramas, commits, PR, revisión | al crear rama/PR |
| `docs/TESTING.md` | estrategia y convenciones de tests | al escribir tests |
| `docs/ARCHITECTURE.md` | componentes, datos, endpoints | si la tarea lo pide |
| `docs/SETUP.md` | variables, puertos, IDE, agentes | al configurar |
| `docs/ROADMAP.md` | fases y criterios de salida | al planificar |
| `docs/adr/` | decisiones | si la tarea las enlaza |
| `docs/audits/`, `docs/archive/` | historial | **no se leen** salvo que la tarea lo indique |

## 8. Convenciones actuales (no las ideales)
- Back: paquetes por capa en `org.nocountry.walam.main` (`controller/`, `service/` + `service/impl/`, `model/{entity,dto,repository,mapper}`, `auth/`, `config/`). Referencia: `controller/TransactionController.java` + `service/impl/TransactionServiceImpl.java`. Lombok (`@RequiredArgsConstructor`, `@Builder`). 4 espacios.
- Front: `src/Routes/<Pantalla>/{Component,Presentation}/` (contenedor + vistas `*Layout.jsx`/`*Info.jsx`), componentes reutilizables en `src/components/<Nombre>/<Nombre>.jsx`, Tailwind en `className`. Referencia: `src/Routes/Login/`. 2 espacios, sin `;` (estilo standard).
- Tests: back `src/test/java/...` espejando el paquete, sufijo `Tests`/`Test` (referencia: `WalamApplicationTests.java`; los de unidad/slice llegan con T-006). Front: ver `docs/TESTING.md` (llegan con T-008).

## 9. Git (detalle en [CONTRIBUTING.md](CONTRIBUTING.md))
- Rama por defecto: **`develop`**. Nunca commitees a `develop`.
- Rama por tarea: `<tipo>/T-NNN-slug` desde `develop` actualizado, **antes del primer commit**.
- Conventional Commits con footer `Refs: T-NNN`; PR con el template; squash merge lo hace el 👤.

## 10. Límites (no se tocan sin una tarea que lo pida)
Versiones mayores · esquema de DB/migraciones · seguridad y autenticación · deploy, CI y Dockerfiles · secretos y `.env` reales · configuración de producción · borrar, saltear o debilitar tests o umbrales · commitear a `develop` · mergear sin revisión. Trabajo extra descubierto → línea en `docs/BACKLOG.md`, no "de paso".

## 11. Gotchas del entorno
- `Walam/.env` se lee **desde el directorio de trabajo**: corré `./mvnw` dentro de `Walam/`.
- El test de contexto necesita la DB arriba (`docker compose up -d --wait`); `verify.sh` la levanta solo.
- `ddl-auto: create`: cada arranque del back **borra los datos**; el usuario demo se recrea con `./scripts/dev.sh`.
- Errores HTTP del back salen como `403` (por `/error` bloqueado) hasta T-002.
- El front llama a producción (URL hardcodeada) hasta T-004.
- Hay secretos commiteados en el historial: **no los copies** a ningún lado (T-001/T-015).
- Docker Hub puede responder 429: `docker login` o reintentar.
