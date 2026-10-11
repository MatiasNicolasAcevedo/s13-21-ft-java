# T-017 · Use the shared API client in the remaining screens (part 2)
- Estado: Lista · Prioridad: P0 · Esfuerzo: S · Ejecuta: 🤖 Junie Lite
- Fase: P0 Estabilizar
- Rama: `refactor/T-017-api-client-remaining-screens` (desde `develop` actualizado) · Depende de: T-004 · Spec/ADR: —
- Revisa: 🤖 Junie Lite (chat nuevo)

## Prompt de arranque para Junie Lite (usar cuando sea la primera de Listas)
```text
Leé AGENTS.md y seguí docs/agents/implementer.md para implementar T-017.
Ejecutor: Junie Lite (Free) en JetBrains Air.
Contrato: docs/tasks/T-017-api-client-remaining-screens.md. Rama exacta: refactor/T-017-api-client-remaining-screens.
Confirmá que no haya PR de tarea abierto y que T-017 sea la primera de Listas; si no, entregá el traspaso correcto y detenete.
Confirmá el merge anterior y conciliá su documentación en el primer commit de esta nueva rama.
Al cerrar o cambiar de contexto, persistí notas, commiteá y publicá todos los cambios propios y comprobá árbol limpio.
```

## Por qué
T-004 creó `Walam_Front/src/api/client.js` y migró 6 archivos; quedan 9 llamadas en 7 archivos apuntando a producción.

## Objetivo
`grep -rn onrender Walam_Front/src` no devuelve nada.

## Alcance
- Incluye: aplicar **el mismo reemplazo de T-004 (Alcance, punto 2)** en: `src/Routes/VirtualCashier/Presentation/VirtualCashierInfo.jsx:84,95` · `src/Routes/Donate/Presentation/DonateInfo.jsx:70` · `src/Routes/Transfer/Presentation/TransferInfo.jsx:30` · `src/Routes/HistoryDetails/Presentation/HistoryDetailsInfo.jsx:14` · `src/Routes/VirtualCard/Presentation/VirtualCardInfo.jsx:20` · `src/Routes/UsersDataForm/Presentation/UsersDataFormInfo.jsx:27,79` · `src/components/HistoryItem/HistoryItem.jsx:15`.
- **No incluye:** cambiar `client.js`, lógica de pantallas, mensajes de error, otros refactors.

## Leer antes
- `Walam_Front/src/api/client.js` · el diff de T-004 en un archivo migrado (p. ej. `src/Routes/Login/Presentation/LoginInfo.jsx`) como referencia · cada archivo de la lista ±10 líneas.

## Archivos previstos
- modificar: los 7 archivos de la lista (en `Walam_Front/`).

## Tests
- Sin infraestructura de tests de front (T-008). Verificación por comando y manual.

## Criterios de aceptación
- [ ] `./scripts/verify.sh --client` → `✅ lint ✅ build`
- [ ] `grep -rn onrender Walam_Front/src` → sin resultados
- [ ] Con `./scripts/dev.sh` y `demo` / `Demo1234!`: depositar 100 en "Depositar" y ver el saldo actualizado en el dashboard; las llamadas van a `localhost:8080`

## Notas de implementación
- Hecho: … · Pendiente: … · Próximo paso: …

## Resultado
- PR: #N · Qué cambió: … · Tests agregados: — · Pendientes → nuevas tareas: …
