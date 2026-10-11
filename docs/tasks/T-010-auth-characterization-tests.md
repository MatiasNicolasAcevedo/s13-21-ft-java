# T-010 · Add characterization tests for registration and login
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 Junie Lite
- Fase: P0 Estabilizar
- Rama: `test/T-010-auth-characterization-tests` (desde `develop` actualizado) · Depende de: T-006 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (toca seguridad)

## Prompt de arranque para Junie Lite (usar cuando sea la primera de Listas)
```text
Leé AGENTS.md y seguí docs/agents/implementer.md para implementar T-010.
Ejecutor: Junie Lite (Free) en JetBrains Air.
Contrato: docs/tasks/T-010-auth-characterization-tests.md. Rama exacta: test/T-010-auth-characterization-tests.
Confirmá que no haya PR de tarea abierto y que T-010 sea la primera de Listas; si no, entregá el traspaso correcto y detenete.
Confirmá el merge anterior y conciliá su documentación en el primer commit de esta nueva rama.
Al cerrar o cambiar de contexto, persistí notas, commiteá y publicá todos los cambios propios y comprobá árbol limpio.
```

## Por qué
Flujos críticos 1–3 de la auditoría (§6.7): registro (usuario + cuenta + CVU + alias) y login (`Walam/src/main/java/org/nocountry/walam/main/auth/service/AuthService.java:43-100`). T-006 deja solo el camino feliz.

## Objetivo
Tests que fijan el comportamiento actual del registro y del login.

## Alcance
- Incluye: agregar casos a `AuthFlowIntegrationTest` (o un archivo hermano `AuthRegistrationIntegrationTest.java` con el mismo estilo):
  1. registro devuelve un token no vacío y `GET /api/v1/users` con ese token devuelve el `username`
  2. el alias cumple `^[a-z]+\.[a-z]+\.eco$`
  3. la cuenta creada tiene `balance` 0.0, `numberAccount` y `cvu` no vacíos, y dos registros tienen números distintos
  4. registrar el mismo `username` dos veces → el **status actual** (fijarlo; si es 403/500, comentario `// Comportamiento actual` + línea en Backlog "devolver 409")
  5. login con password incorrecta y con usuario inexistente → mismo status y mismo cuerpo
- **No incluye:** cambiar código de producción, validaciones nuevas.

## Leer antes
- `AuthFlowIntegrationTest.java` (referencia de T-006) · `AuthService.java:43-100` · `auth/request/RegisterRequest.java` · `docs/TESTING.md` §4.

## Archivos previstos
- modificar o crear: 1 archivo de test en `src/test/java/org/nocountry/walam/main/auth/`.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa y la cobertura no baja
- [ ] Borrar temporalmente `user.setAlias(alias)` en `AuthService` hace fallar un test (revertir; anotarlo en el PR)

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
