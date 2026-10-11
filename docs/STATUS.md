# Estado del proyecto
_Actualizado: 2026-10-11 · por: 🧠 Codex · sesión: documentación de agentes (T-018)_

## En una línea
Bootstrap terminado: el proyecto compila, corre en contenedores y tiene harness para agentes, pero tiene **fallas de seguridad críticas** (T-001, T-002) y casi nada de tests.

## Salud
| Check | Estado | Nota |
|---|---|---|
| verify.sh | ❌ | reejecutado 2026-10-11: server ✅ (1 test, JDK 21) · client build ✅, lint ❌ (64 problemas: 62 errores, 2 warnings) → T-003; Node local 24 (repo pide 22) |
| CI en develop | sin CI | → T-007 (bloqueada por T-003, T-006) |
| Levantar en local (README) | ⚠️ verificado 2026-10-10 | contenedores ✅ · desarrollo ✅ (el front llama a producción → T-004) |
| Cobertura back / front | 11 % línea, 0 % rama / sin tests (sin umbral) | → T-006, T-008 |
| E2E smoke | no existe | → T-014 |
| Dependencias vulnerables | npm: 3 críticas, 25 altas · Java: Boot 3.2 sin soporte | → T-005, Backlog P1 |
| Seguridad | 🔴 secretos commiteados; `/api/**` público con hashes | → T-001, T-002, T-015 |
| Última auditoría | 2026-10-10 | [inicial](audits/2026-10-10-initial.md) |

## Fase actual
P0 Estabilizar · 0/17 tareas de producto (T-001…T-017; T-000 cerrada) · T-018: ajuste documental solicitado antes de T-001 · ver [ROADMAP](ROADMAP.md)

## Foco
- PR abierto (máx. 1): [#2 · T-018 · documentación de agentes](https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/pull/2)

| Momento | Paso | Ejecutor / modelo | Acción |
|---|---|---|---|
| **👉 Ahora** | **Revisar PR #2 · T-018** | **🧠 Frontera** (p. ej. GPT 6.1 Sol u Opus 5.5) | Sesión nueva con `reviewer.md`; luego 👤 mergea si está aprobado |
| **▶ Después del merge de #2** | **T-001 · Externalizar secretos** | **🧠 Frontera** | Sesión nueva con `implementer.md`; registrar el merge de T-018 en el primer commit |
| Luego | T-002 · Autorización y datos sensibles | 🧠 Frontera | Después del merge de T-001 |
| **🤖 Primer cambio a Lite** | **T-003 · Corregir lint del front** | **🤖 Junie Lite (Free, Air)** | Después del merge de T-002; el traspaso debe traer un prompt completo para copiar |
| Luego | T-004 → T-017 → T-005 | 🤖 Junie Lite (Free, Air) | Una tarea y una sesión a la vez |

**Prompt para el paso inmediato (frontera, sesión nueva):**
```text
Leé AGENTS.md y seguí docs/agents/reviewer.md para revisar el PR #2.
PR: https://github.com/MatiasNicolasAcevedo/s13-21-ft-java/pull/2
Tarea: T-018. Contrato: docs/tasks/T-018-agent-workflow.md.
Rama: docs/T-018-agent-workflow. Ejecutor: modelo de frontera.
Revisá la documentación y entregá veredicto y traspaso sin dejar cambios locales.
```

**Prompt para continuar después del merge de #2 (frontera, sesión nueva):**
```text
Leé AGENTS.md y seguí docs/agents/implementer.md.
Tomá T-001 (docs/tasks/T-001-externalize-secrets.md) con un modelo de frontera.
Confirmá primero que el PR #2 de T-018 está mergeado y que no hay otro PR de tarea abierto.
Actualizá develop, creá fix/T-001-externalize-secrets y registrá el cierre documental de T-018 en el primer commit de esa rama.
```

- **En paralelo, ya:** T-015 pasos 1–2 (👤, revocar la app password de Gmail y restringir la key de Firebase)

## Contexto y continuidad
**Podés compactar y continuar la misma tarea** después de cerrar una sub-etapa si el contexto es alto o hay degradación, con notas completas, commit, push y árbol limpio. Usá la función disponible en tu herramienta; para reanudar, el prompt de [implementer §7](agents/implementer.md#7-contexto-largo). **Para el paso siguiente de la tabla abrí una sesión nueva.** El revisor deja el traspaso sin editar documentación local; el implementador siguiente registra el merge al iniciar su rama.

## Decisiones pendientes del dueño
- ¿Renombrar `develop` → `main`? (T-016 paso 0; los docs usan `develop`)
- Licencia del repo (MIT sugerida) y crédito al equipo de No Country
- ¿Siguen vivos Render/Vercel y quién controla Gmail/Firebase? (T-015)
- ¿Mantener login con Google (Firebase) y 2FA, o quitarlos? (Backlog P2)

## Últimas sesiones
- 2026-10-11 · 🧠 Codex · T-018 · protocolos y traspasos actualizados en PR #2; implementación completada, pendiente revisión/merge
- 2026-10-10 · 🧠 sub-agente revisor · revisó PR #1 (T-000) · APROBADO, sin bloqueantes · mergeado con squash; tag `audit/2026-10-10` **no existe en origin** (verificado 2026-10-11)
- 2026-10-10 · 🧠 Claude Code · auditó y montó el harness (T-000) · verify ❌ (lint front) · PR #1
