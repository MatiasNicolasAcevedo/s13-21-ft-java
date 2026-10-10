#!/usr/bin/env bash
# Entorno de desarrollo: DB en contenedor + back (./mvnw spring-boot:run) + front (Vite, hot reload).
# Uso: ./scripts/dev.sh          → levanta todo; Ctrl+C corta back y front (la DB queda arriba)
#      ./scripts/dev.sh --down   → apaga la DB (los datos quedan en el volumen)
# Hace lo mismo que el paso a paso "Opción B" del README.md.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOGS="$ROOT/.dev-logs"
BACK_URL="http://localhost:8080"
FRONT_URL="http://localhost:5173"
DEMO_USER="demo"
DEMO_PASS="Demo1234!"

if [ "${1:-}" = "--down" ]; then
  cd "$ROOT" && docker compose down
  exit 0
fi

mkdir -p "$LOGS"

# 1. Configuración local: copia los .example si falta el archivo real.
[ -f "$ROOT/Walam/.env" ] || { cp "$ROOT/Walam/.env.example" "$ROOT/Walam/.env"; echo "• Creado Walam/.env desde el .example"; }
[ -f "$ROOT/Walam_Front/.env.local" ] || { cp "$ROOT/Walam_Front/.env.example" "$ROOT/Walam_Front/.env.local"; echo "• Creado Walam_Front/.env.local desde el .example"; }

# 2. DB en contenedor.
echo "• Levantando la DB (docker compose up -d --wait)…"
(cd "$ROOT" && docker compose up -d --wait db)

# 3. Back y front, cada uno en su propio grupo de procesos para poder cortar todo el árbol.
PIDS=()
cleanup() {
  echo
  echo "• Cortando back y front…"
  for pid in "${PIDS[@]}"; do kill -TERM -- "-$pid" 2>/dev/null || true; done
  sleep 2
  for pid in "${PIDS[@]}"; do kill -KILL -- "-$pid" 2>/dev/null || true; done
  echo "• Listo. La DB sigue arriba: ./scripts/dev.sh --down para apagarla."
}
trap cleanup EXIT
trap 'exit 130' INT TERM

if [ ! -d "$ROOT/Walam_Front/node_modules" ]; then
  echo "• Instalando dependencias del front (npm ci)…"
  (cd "$ROOT/Walam_Front" && npm ci --no-audit --no-fund >"$LOGS/npm-ci.log" 2>&1)
fi

echo "• Arrancando back (log: .dev-logs/server.log)…"
(cd "$ROOT/Walam" && exec setsid ./mvnw -B spring-boot:run >"$LOGS/server.log" 2>&1) &
PIDS+=($!)
echo "• Arrancando front (log: .dev-logs/client.log)…"
(cd "$ROOT/Walam_Front" && exec setsid npm run dev -- --port 5173 --strictPort >"$LOGS/client.log" 2>&1) &
PIDS+=($!)

wait_for() { # url, nombre, segundos
  local i
  for i in $(seq 1 "$3"); do
    if curl -fs -o /dev/null "$1"; then echo "  ✅ $2 responde ($1)"; return 0; fi
    sleep 1
  done
  echo "  ❌ $2 no respondió en $3 s (ver .dev-logs/)"; return 1
}
wait_for "$BACK_URL/v3/api-docs" "back" 180
wait_for "$FRONT_URL" "front" 60

# 4. Usuario demo (no hay seed y ddl-auto=create borra la base en cada arranque del back).
code=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BACK_URL/auth/register" \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"$DEMO_USER\",\"password\":\"$DEMO_PASS\",\"email\":\"demo@example.com\"}")
[ "$code" = 200 ] && echo "  ✅ usuario demo creado" || echo "  • usuario demo ya existía (HTTP $code)"

cat <<EOF

  Front:    $FRONT_URL   (⚠️ hoy llama a la API de producción: ver docs/tasks/T-004)
  Back:     $BACK_URL    (Swagger: $BACK_URL/swagger-ui/index.html)
  DB:       localhost:5432 · db/usuario walam
  Demo:     $DEMO_USER / $DEMO_PASS (solo en tu back local)

  Ctrl+C para cortar back y front.
EOF
wait
