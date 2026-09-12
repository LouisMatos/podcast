#!/usr/bin/env bash
#
# Sobe o app num device físico Android conectado via USB.
#
# Diferente de run_android.sh (que só liga/usa emulador AVD), este script
# é pra medir performance real: cold start, jank de scroll, refresh — nada
# disso serve em emulador.
#
# O que ele faz:
#   1. localiza device físico conectado (adb devices, exclui emulator-*)
#   2. resolve dependências e roda o codegen se houver anotações no projeto
#   3. `flutter run` no device, modo --profile por padrão (debug não mede
#      jank real, release não conecta DevTools)
#
# Uso:
#   ./scripts/run_device.sh                       # --profile no primeiro device físico
#   ./scripts/run_device.sh --release             # qualquer flag extra vai direto pro flutter run
#   DEVICE_SERIAL=42002b900177452d ./scripts/run_device.sh
#
# Comandos úteis pra medição (rodar em outro terminal enquanto o app roda):
#   adb -s <serial> shell dumpsys gfxinfo <package_id> reset   # zera contador de frames
#   adb -s <serial> shell dumpsys gfxinfo <package_id>         # jank/frame stats
#   adb -s <serial> shell am force-stop <package_id>           # pra medir cold start
#   adb -s <serial> shell dumpsys meminfo <package_id>         # PSS de memória
# package_id: ver applicationId em android/app/build.gradle.kts
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

ANDROID_SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
ADB="$ANDROID_SDK/platform-tools/adb"

info()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
fail()  { printf '\033[1;31merro:\033[0m %s\n' "$1" >&2; exit 1; }

[ -x "$ADB" ] || fail "adb não encontrado em $ADB. Ajuste ANDROID_HOME."

# Device físico = linha "device" cujo id não começa com emulator-.
physical_devices() {
  "$ADB" devices | awk '$2 == "device" && $1 !~ /^emulator-/ { print $1 }'
}

if [ -n "${DEVICE_SERIAL:-}" ]; then
  DEVICE="$DEVICE_SERIAL"
  "$ADB" devices | awk -v d="$DEVICE" '$1 == d && $2 == "device" { found=1 } END { exit !found }' \
    || fail "device '$DEVICE_SERIAL' não está conectado/autorizado. 'adb devices' pra conferir."
else
  DEVICES="$(physical_devices)"
  COUNT="$(printf '%s\n' "$DEVICES" | grep -c . || true)"
  case "$COUNT" in
    0) fail "nenhum device físico conectado via USB. Conecte o aparelho, autorize a depuração USB e rode de novo." ;;
    1) DEVICE="$DEVICES" ;;
    *) fail "mais de um device físico conectado. Escolha com DEVICE_SERIAL=<serial>:
$(printf '%s\n' "$DEVICES" | sed 's/^/  - /')" ;;
  esac
fi

info "Device físico: $DEVICE"

info "Resolvendo dependências..."
flutter pub get

# Só paga o custo do build_runner se existir algo pra gerar.
if grep -rlq --include='*.dart' -E '@freezed|@riverpod|@JsonSerializable|DriftDatabase|part .*\.g\.dart' lib 2>/dev/null; then
  info "Rodando codegen..."
  dart run build_runner build --delete-conflicting-outputs
else
  info "Nada pra gerar, pulando codegen."
fi

# Default --profile: debug não mede jank real, release não conecta DevTools.
ARGS=("$@")
if [ "${#ARGS[@]}" -eq 0 ]; then
  ARGS=(--profile)
fi

info "Subindo o app (${ARGS[*]})..."
exec flutter run -d "$DEVICE" "${ARGS[@]}"
