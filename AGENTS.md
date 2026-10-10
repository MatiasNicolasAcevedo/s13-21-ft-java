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
| 🧠 | **Modelo de frontera** (Claude Code u otro potente) | seguridad, infra de tests/CI/contenedores, arquitectura, migraciones, specs y tareas, revisiones riesgosas, auditorías |
| 🤖 | **Agente gratuito** de IntelliJ IDEA (Qwen) | tareas chicas y bien especificadas, de a una, con tests; revisiones de PRs chicos |
| 👤 | **Dueño** | decide, configura GitHub, rota secretos, mergea, **cambia de agente** |

Ningún agente lanza a otro. Si el próximo paso es de otro ejecutor, terminá con un **traspaso**:
> **Próximo paso:** T-NNN · <título> · **ejecuta: 🤖 agente gratuito (IntelliJ)** | **🧠 modelo de frontera** | **👤 dueño**
> **Qué hacer:** abrí <chat nuevo del agente de IntelliJ | una sesión nueva de Claude Code | GitHub → …> y escribí: «Seguí `docs/agents/implementer.md`»

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
5. Tests en el mismo PR. Al terminar: `./scripts/verify.sh` sin regresiones, tablero/tarea/STATUS actualizados, PR listo y sugerí sesión nueva.
Detalle: [implementer](docs/agents/implementer.md) · [reviewer](docs/agents/reviewer.md) · [auditor](docs/agents/auditor.md) (solo 🧠).

## 5. Gestión de contexto
1. **Una tarea = una sesión.** Al cerrar una tarea, revisión o auditoría, sugerí una sesión nueva (mejor que compactar).
2. Sugerí compactar **solo a mitad de un trabajo largo** y si: cerraste una sub-etapa; hay logs/archivos que ya no sirven; el contexto pasa ~60 % (🧠) o ~50 % (🤖); o notás degradación (releer archivos, olvidar decisiones, repetir intentos).
3. **Antes, persistí:** "Notas de implementación" de la tarea (hecho / pendiente / próximo paso), commit y push.
4. 🧠: `/compact Conservar: tarea T-NNN, rama y PR, decisiones, archivos modificados, estado de verify y próximo paso. Descartar: logs y contenido de archivos ya procesados.` + «después escribime "seguí con T-NNN"». 🤖 (sin `/compact`): «abrí un chat nuevo y escribí: Seguí `docs/agents/implementer.md` (retomando T-NNN)».
5. No compactes justo antes de terminar ni entre tareas.
6. Higiene: salida acotada (`| tail -n 40`, logs a archivo + `grep`); grep/glob antes de abrir; leé por rangos; no abras `package-lock.json`, `target/`, `node_modules/`, `dist/`, `.verify-logs/` ni `docs/archive/`.

## 6. Configuración
**Regla permanente:** todo archivo de configuración con valores por entorno tiene su `.example` commiteado y el real en `.gitignore`.
| Ejemplo | Copiar a | Lo lee |
|---|---|---|
| `Walam/.env.example` | `Walam/.env` | spring-dotenv, desde el directorio de trabajo (`Walam/`) |
| `Walam_Front/.env.example` | `Walam_Front/.env.local` | Vite (`VITE_*`) |
Si agregás o renombrás una variable: actualizá en el **mismo PR** su `.example` (con comentario y valor local válido), `docker-compose.yml`, `docs/SETUP.md` y el README si cambia un paso. Nunca valores reales.

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
