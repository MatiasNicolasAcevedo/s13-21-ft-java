# 0002 · Camino de actualización de versiones

- Estado: Propuesto (lo confirma el 👤 al mergear T-000) · Fecha: 2026-10-10 · Decide: 🧠

## Contexto
Spring Boot 3.2.2 (sin soporte OSS desde 2024-12), Java 17, Vite 5, ESLint 8, React 18, con 1 test y sin CI. Versiones vigentes verificadas el 2026-10-10: Boot 3.5.16 / 4.1.1, Java 25 LTS, Node 24 LTS, React 19.3, Vite 8, Vitest 5, Playwright 1.64.

## Decisión
1. **Primero la red (P0):** T-006, T-008, T-009, T-010, T-014 y CI (T-007).
2. **Back:** Boot 3.2 → **3.5.x** (OpenRewrite `org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_5`) → Java 21 → **Boot 4.x** en una tarea 🧠 propia (Jakarta EE 11, Jackson 3, Security 7) → Java 25.
3. **Front:** Node 24 → Vite 8 + plugin React → React 19 → ESLint flat config → React Router 7 → Tailwind 4; un paso por PR, con Vitest en verde.
4. Cada salto mayor: su propia tarea 🧠, con caracterización previa.

## Alternativas
- Saltar directo a Boot 4: demasiados cambios a la vez sin tests.
- Reescribir el front en TypeScript ya: posible después (P2), no bloquea.

## Consecuencias
P1 no empieza hasta cumplir el criterio de salida de P0 ([ROADMAP](../ROADMAP.md)). Dependabot agrupa minor/patch; los mayores pasan por tarea 🧠.
