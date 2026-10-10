# Arquitectura

## Componentes (incluidos los contenedores locales)
```mermaid
flowchart LR
  user([Navegador]) -->|HTTP 5173| client
  subgraph compose["docker compose (local)"]
    client["client<br/>React + Vite build<br/>nginx :80"]
    server["server<br/>Spring Boot :8080"]
    db[("db<br/>PostgreSQL 17 :5432<br/>volumen walam-db")]
  end
  client -.->|"hoy: API de producción (Render)<br/>objetivo: VITE_API_URL (T-004)"| server
  server -->|JDBC| db
  server -->|SMTP| gmail[(Gmail)]
  client -->|Analytics / login Google| firebase[(Firebase)]
  subgraph prod["producción (⚠️ no verificada)"]
    vercel[Vercel: front] --> render[Render: back Docker] --> pg[(PostgreSQL)]
  end
```

## Flujo de una request
```mermaid
sequenceDiagram
  participant F as Front (axios)
  participant J as JwtAuthenticationFilter
  participant S as SecurityFilterChain
  participant C as Controller
  participant Sv as Service
  participant R as Repository (JPA)
  participant D as PostgreSQL
  F->>J: Authorization: Bearer <jwt>
  J->>J: valida firma y expiración, carga User
  J->>S: SecurityContext con el usuario
  S->>C: /auth/** y (hoy) /api/** son públicos
  C->>Sv: DTO validado (@Valid)
  Sv->>R: save / find
  R->>D: SQL (Hibernate)
  Sv-->>C: ResponseEntity (hoy armado en el servicio)
  C-->>F: JSON (a veces entidades JPA → T-002)
```

## Autenticación
```mermaid
sequenceDiagram
  participant U as Usuario
  participant F as Front
  participant A as AuthController /auth
  participant AS as AuthService
  U->>F: usuario + contraseña
  F->>A: POST /auth/login
  A->>AS: AuthenticationManager.authenticate (BCrypt)
  AS-->>F: {"token": JWT HS256, 3 h}
  F->>F: localStorage.token
  F->>A: siguientes requests con Bearer
```
Registro (`POST /auth/register`): crea `User` (rol USER, password BCrypt), alias aleatorio `palabra.palabra.eco`, `Account` con número de cuenta y CVU aleatorios, saldo 0, y devuelve un JWT. Problemas conocidos: secreto hardcodeado (T-001), `/api/**` público (T-002).

## Modelo de datos
```mermaid
erDiagram
  USERS ||--|| ACCOUNT : "account_id"
  USERS ||--o| CARDS : "card_id"
  ACCOUNT ||--o{ TRANSACTION : "account_id"
  USERS {
    int id PK
    string username UK
    string alias
    string email
    string password "BCrypt"
    string no_identidad UK
    string rol "USER/ADMIN"
  }
  ACCOUNT {
    int id PK
    string number_account UK
    string cvu UK
    double balance "Double → BigDecimal (backlog)"
  }
  TRANSACTION {
    int id PK
    double amount
    datetime date
    string type "DEPOSIT/WITHDRAW"
    string origin_account
    string destiny_account
  }
  CARDS {
    int id PK
    string card_number
    int cvv
    date expiration_date
  }
```
También existen `account_card` y `user_support_ticket` sin uso desde la API. Esquema generado por Hibernate (`ddl-auto: create`), sin migraciones (T-011).

## Endpoints principales y pantalla que los usa
| Método y ruta | Auth hoy | Pantalla |
|---|---|---|
| `POST /auth/register` | pública | Register |
| `POST /auth/login` | pública | Login |
| `GET /api/v1/users` (usuario logueado) | token | Dashboard, CVU, Tarjeta, Historial, Datos |
| `PUT /api/v1/user-update` | token | UsersDataForm |
| `POST /api/v1/deposit` · `/withdraw` · `/transfer` | token | VirtualCashier, Donate, Transfer |
| `GET /api/v1/transaction/{id}` | 🔴 pública | HistoryDetails |
| `POST /api/v1/card/create` | token | Dashboard |
| `GET /api/v1/users-all`, `/user/{id}`, `/transactions` | 🔴 públicas | ninguna |
| `PATCH /api/v1/user/update-*` (8) | token | ninguna |
| `/send-email/*`, `/account/*`, `/api/v1/demo` | token | ninguna (pruebas/a medias) |
Contrato completo: `http://localhost:8080/v3/api-docs` (springdoc).

## Arquitectura objetivo
- Tests de integración contra PostgreSQL real con Testcontainers → [ADR 0001](adr/0001-testcontainers-over-h2.md).
- Migración de versiones en pasos chicos protegidos por tests → [ADR 0002](adr/0002-upgrade-path.md).
- JWT stateless con secreto por entorno, `/api/**` autenticado, DTOs de respuesta (nunca entidades), errores `ProblemDetail` → T-001, T-002.
- Esquema versionado con Flyway → T-011.
- Front con un único cliente HTTP configurado por `VITE_API_URL` → T-004.
