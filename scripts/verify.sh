#!/usr/bin/env bash
# Gate rápido del proyecto: build (con clean) + lint + tests de cada parte.
# Uso: ./scripts/verify.sh [--server | --client]
# Sale con código != 0 si algo falla. Detalle en .verify-logs/ (ignorado por git).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOGS="$ROOT/.verify-logs"
mkdir -p "$LOGS"

RUN_SERVER=1
RUN_CLIENT=1
case "${1:-}" in
  --server) RUN_CLIENT=0 ;;
  --client) RUN_SERVER=0 ;;
  "") ;;
  *) echo "Uso: $0 [--server | --client]" >&2; exit 2 ;;
esac

FAIL=0
SUMMARY=()

ensure_db() {
  if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
    echo "⚠️  Docker no disponible: se asume una DB ya corriendo según Walam/.env" >&2
    return 0
  fi
  (cd "$ROOT" && docker compose up -d --wait db) >"$LOGS/db.log" 2>&1 \
    || { echo "❌ No se pudo levantar la DB (ver .verify-logs/db.log)" >&2; return 1; }
}

verify_server() {
  local log="$LOGS/server.log" jdk status tests
  echo "▶ server: levantando DB y corriendo ./mvnw -B clean verify (log: .verify-logs/server.log)"
  jdk="$(java -version 2>&1 | awk -F'"' '/version/ {print $2; exit}')"
  if ! ensure_db; then
    SUMMARY+=("server: ❌ db"); FAIL=1; return
  fi
  # Usa Walam/.env si existe; si no, exporta los valores de Walam/.env.example.
  (
    cd "$ROOT/Walam" || exit 1
    if [ ! -f .env ]; then set -a; . ./.env.example; set +a; fi
    ./mvnw -B clean verify
  ) >"$log" 2>&1
  status=$?
  tests="$(grep -E '^\[(INFO|ERROR|WARNING)\] Tests run:' "$log" | tail -1 | sed -E 's/.*Tests run: ([0-9]+), Failures: ([0-9]+), Errors: ([0-9]+), Skipped: ([0-9]+).*/\1 tests, \2 fallan, \3 errores, \4 omitidos/')"
  if [ $status -eq 0 ]; then
    SUMMARY+=("server: ✅ build ✅ tests (${tests:-0 tests}) [JDK $jdk]")
  else
    FAIL=1
    if grep -q 'COMPILATION ERROR\|release version\|invalid target release' "$log"; then
      SUMMARY+=("server: ❌ build [JDK $jdk] → $(grep -m1 -E 'ERROR.*(release|\.java)' "$log" | cut -c1-160)")
      echo "  Pista: el proyecto pide Java 17+ (pom.xml). Probá 'sdk env install' en la raíz." >&2
    elif grep -q 'URL must start with .jdbc.\|Connection refused\|password authentication failed' "$log"; then
      SUMMARY+=("server: ❌ tests: no conecta a la DB → revisá Walam/.env y 'docker compose ps'")
    else
      SUMMARY+=("server: ❌ tests (${tests:-ver log}) → $(grep -m1 -E '<<< (FAILURE|ERROR)' "$log" | cut -c1-160)")
    fi
  fi
}

verify_client() {
  local dir="$ROOT/Walam_Front" parts=() ok=1
  echo "▶ client: npm ci (si hace falta) + lint + build (+ test si existe) (logs: .verify-logs/client-*.log)"
  if [ ! -d "$dir/node_modules" ] || [ "$dir/package-lock.json" -nt "$dir/node_modules/.package-lock.json" ]; then
    (cd "$dir" && npm ci --no-audit --no-fund) >"$LOGS/client-install.log" 2>&1 \
      || { SUMMARY+=("client: ❌ npm ci (ver .verify-logs/client-install.log)"); FAIL=1; return; }
  fi
  if (cd "$dir" && npm run lint) >"$LOGS/client-lint.log" 2>&1; then
    parts+=("✅ lint")
  else
    parts+=("❌ lint ($(grep -m1 -oE '[0-9]+ problems? \([0-9]+ errors?' "$LOGS/client-lint.log" || echo 'ver log')))"); ok=0
  fi
  if (cd "$dir" && npm run build) >"$LOGS/client-build.log" 2>&1; then
    parts+=("✅ build")
  else
    parts+=("❌ build ($(grep -m1 -iE 'error' "$LOGS/client-build.log" | cut -c1-120))"); ok=0
  fi
  if grep -q '"test"' "$dir/package.json"; then
    if (cd "$dir" && npm test -- --run) >"$LOGS/client-test.log" 2>&1; then parts+=("✅ tests"); else parts+=("❌ tests (ver log)"); ok=0; fi
  else
    parts+=("⚠️ sin tests")
  fi
  [ $ok -eq 1 ] || FAIL=1
  SUMMARY+=("client: ${parts[*]} [Node $(node -v 2>/dev/null || echo '?')]")
}

[ $RUN_SERVER -eq 1 ] && verify_server
[ $RUN_CLIENT -eq 1 ] && verify_client

echo
out=""
for s in "${SUMMARY[@]}"; do out="${out:+$out · }$s"; done
echo "Resumen: $out"
exit $FAIL
