# Estrategia de testing

Base medida el 2026-10-10: back **1 test**, cobertura de **línea 11.1 %**, **rama 0 %**; front sin tests; sin E2E. Detalle: [auditoría §6.7](audits/2026-10-10-initial.md).

## 1. Pirámide y herramientas
| Capa | Herramientas | Para qué |
|---|---|---|
| Back · unitarios | JUnit 5 (Jupiter), AssertJ, Mockito con mesura | reglas de servicios/dominio (saldo, transferencias, generación de cuenta/CVU) |
| Back · controllers | `@WebMvcTest` + `spring-security-test` | validación, códigos HTTP, formato de error, quién puede llamar qué |
| Back · repositorios | `@DataJpaTest` + Testcontainers | solo queries propias (`findByNumberAccount`, `existsByCvu`, …) |
| Back · integración | `@SpringBootTest` + **Testcontainers PostgreSQL** | flujos completos contra la misma DB que producción (sin H2: [ADR 0001](adr/0001-testcontainers-over-h2.md)) |
| Back · cobertura | **JaCoCo** con umbral en `verify` | trinquete (§5) |
| Front · componentes | **Vitest** + **React Testing Library** (+ `user-event`) | comportamiento visible; consultas por rol/label |
| Front · API | **MSW** | mocks de red basados en el contrato OpenAPI del back |
| Front · cobertura | v8 (Vitest) | trinquete |
| E2E | **Playwright** (desktop + mobile, trazas y screenshots en fallos) | pocos smoke de flujos críticos |

La infraestructura se crea en: back [T-006](tasks/T-006-backend-test-infra.md) · front [T-008](tasks/T-008-frontend-test-infra.md) · E2E [T-014](tasks/T-014-e2e-infra.md). Hasta T-006, los tests de back usan la DB del compose (la levanta `verify.sh`).

## 2. Qué testear y qué no
- **Sí:** reglas de negocio, validaciones, permisos (con y sin token, dueño vs. otro usuario), contratos de API (status + cuerpo), estados de UI (cargando/error/vacío), bugs corregidos.
- **No:** getters/setters, código generado (Lombok/MapStruct), el framework en sí, estilos.

## 3. Convenciones
- Back: `Walam/src/test/java/` espejando el paquete; `<Clase>Test` (unitario) y `<Clase>IT` o `<Flujo>IntegrationTest` (integración). Nombres `metodo_condicion_resultado` o `@DisplayName` en español.
- Front: `*.test.jsx` junto al componente (`src/Routes/Login/Presentation/LoginInfo.test.jsx`).
- **Arrange / Act / Assert** separados por una línea en blanco. Datos con builders (`User.builder()`, `Account.builder()` ya existen por Lombok).
- **Archivo de referencia por tipo** (copiá su estilo): contexto `WalamApplicationTests.java` (hoy el único). T-006 agrega el de integración y el de `@WebMvcTest`; T-008 el de componente; T-014 el E2E. Al crearlos, actualizá esta lista.
- **Un solo test:** back `cd Walam && ./mvnw -B test -Dtest=Clase#metodo` (con la DB arriba) · front (después de T-008) `cd Walam_Front && npx vitest run ruta/al/archivo.test.jsx`.

## 4. Reglas para todas las tareas
1. Los tests van **en el mismo PR** que el cambio.
2. **Bugfix = primero un test que falla** y que pasa con el fix.
3. **Caracterización antes de refactorizar o migrar** (fijar el comportamiento actual, aunque sea raro, y anotarlo).
4. **Prohibido** borrar, deshabilitar (`@Disabled`, `.skip`), debilitar asserts o bajar umbrales.
5. Tests deterministas: sin depender del orden, la hora (`Clock` inyectable), la red ni datos compartidos entre tests.

## 5. Cobertura como trinquete
Medir la base, fijar el umbral en ese valor **redondeado hacia abajo** y **no bajarlo nunca**; cada auditoría lo sube. Umbral inicial del back al crear JaCoCo (T-006): **línea 10 %**. Meta orientativa: ≥ 70–80 % en servicios/dominio y lógica de front.

## 6. Opcional
Mutation testing puntual en auditorías: PIT (`org.pitest:pitest-maven`) en `service/impl` y Stryker en el front.
