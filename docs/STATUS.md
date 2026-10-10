# Estado del proyecto
_Actualizado: 2026-10-10 · por: 🧠 Claude Code · sesión: auditoría (T-000)_

## En una línea
Bootstrap terminado: el proyecto compila, corre en contenedores y tiene harness para agentes, pero tiene **fallas de seguridad críticas** (T-001, T-002) y casi nada de tests.

## Salud
| Check | Estado | Nota |
|---|---|---|
| verify.sh | ❌ | server ✅ (1 test) · client ❌ lint (64 problemas) → T-003 |
| CI en develop | sin CI | → T-007 (bloqueada por T-003, T-006) |
| Levantar en local (README) | ⚠️ verificado 2026-10-10 | contenedores ✅ · desarrollo ✅ (el front llama a producción → T-004) |
| Cobertura back / front | 11 % línea, 0 % rama / sin tests (sin umbral) | → T-006, T-008 |
| E2E smoke | no existe | → T-014 |
| Dependencias vulnerables | npm: 3 críticas, 25 altas · Java: Boot 3.2 sin soporte | → T-005, Backlog P1 |
| Seguridad | 🔴 secretos commiteados; `/api/**` público con hashes | → T-001, T-002, T-015 |
| Última auditoría | 2026-10-10 | [inicial](audits/2026-10-10-initial.md) |

## Fase actual
P0 Estabilizar · 0/17 tareas (T-001…T-017; T-000 cerrada) · ver [ROADMAP](ROADMAP.md)

## Foco
- PR abierto (máx. 1): ninguno (PR #1 de T-000 mergeado)
- **Próximo paso:** T-001 · Move hardcoded secrets to environment configuration · **ejecuta: 🧠 modelo de frontera**
- **Qué hacer:** abrí una **sesión nueva de Claude Code** y escribí: «Seguí `docs/agents/implementer.md`»
- **Después:** T-002 (🧠) → T-003 (🤖) → T-004 (🤖) _(cambio de agente: de 🧠 a 🤖 en T-003)_
- **En paralelo, ya:** T-015 pasos 1–2 (👤, revocar la app password de Gmail y restringir la key de Firebase)

## Decisiones pendientes del dueño
- ¿Renombrar `develop` → `main`? (T-016 paso 0; los docs usan `develop`)
- Licencia del repo (MIT sugerida) y crédito al equipo de No Country
- ¿Siguen vivos Render/Vercel y quién controla Gmail/Firebase? (T-015)
- ¿Mantener login con Google (Firebase) y 2FA, o quitarlos? (Backlog P2)

## Últimas sesiones
- 2026-10-10 · 🧠 sub-agente revisor · revisó PR #1 (T-000) · APROBADO, sin bloqueantes · mergeado con squash; tag `audit/2026-10-10`
- 2026-10-10 · 🧠 Claude Code · auditó y montó el harness (T-000) · verify ❌ (lint front) · PR #1
