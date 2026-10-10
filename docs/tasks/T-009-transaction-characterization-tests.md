# T-009 · Add characterization tests for deposit, withdraw and transfer
- Estado: Bloqueada · Prioridad: P0 · Esfuerzo: M · Ejecuta: 🤖 agente gratuito
- Fase: P0 Estabilizar
- Rama: `test/T-009-transaction-characterization-tests` (desde `develop` actualizado) · Depende de: T-006 · Spec/ADR: —
- Revisa: 🧠 modelo de frontera (esfuerzo M)

## Por qué
Flujos críticos 4–6 de la auditoría (§6.7) sin tests: `TransactionServiceImpl.deposit`, `withdraw`, `transferToAccount` (`Walam/src/main/java/org/nocountry/walam/main/service/impl/TransactionServiceImpl.java:57-128`). Hay que fijar el comportamiento antes de migrar versiones o cambiar a `BigDecimal`.

## Objetivo
Un test de integración por HTTP que documenta el comportamiento **actual** de depósito, extracción y transferencia (aunque sea raro).

## Alcance
- Incluye: `src/test/java/org/nocountry/walam/main/controller/TransactionFlowIntegrationTest.java` **copiando el estilo de `AuthFlowIntegrationTest`** (creado en T-006): registrar 2 usuarios por `/auth/register`, usar sus tokens y verificar:
  1. depósito de 100 → 200 `Deposit Success`; `GET /api/v1/users` muestra `account.balance` 100.0
  2. depósito de 0 y de −5 → 400 con `errors`
  3. extracción de 30 → 200; saldo 70.0 · extracción mayor al saldo → 400 `Not enough balance`
  4. transferencia de 20 del usuario A a la cuenta (`account.numberAccount`) de B → 200 `Transferencia exitosa`; saldos 50.0 y 20.0
  5. transferencia a la propia cuenta → 400 · a una cuenta inexistente → 400 `Bad Request` · sin saldo → 400
- **No incluye:** cambiar código de producción (si un comportamiento parece un bug, el test lo fija tal cual con un comentario `// Comportamiento actual: …` y agregás una línea en Backlog), tests de `/transactions`.

## Leer antes
- `docs/TESTING.md` §3–4 · `AuthFlowIntegrationTest.java` (referencia) · `TransactionController.java:29-55` · `TransactionServiceImpl.java:57-128` · `controller/TransactionRequest.java` (campos del JSON).

## Archivos previstos
- crear: `TransactionFlowIntegrationTest.java` (1 archivo, ~150 líneas).

## Criterios de aceptación
- [ ] `./scripts/verify.sh --server` pasa y la cobertura de línea sube (anotar antes/después del reporte JaCoCo)
- [ ] `cd Walam && ./mvnw -B test -Dtest=TransactionFlowIntegrationTest` → verde
- [ ] Cambiar temporalmente `>=` por `>` en `TransactionServiceImpl.java:84` hace fallar al menos un test (revertir; anotarlo en el PR)

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: … · Pendientes → nuevas tareas: …
