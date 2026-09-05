#!/usr/bin/env bash
#
# Sobe o app no emulador Android.
#
# O que ele faz:
#   1. liga o AVD se nenhum emulador estiver rodando
#   2. espera o boot terminar de verdade (sys.boot_completed = 1)
#   3. resolve dependências e roda o codegen se houver anotações no projeto
#   4. `flutter run` no emulador
#
# Uso:
#   ./scripts/run_android.sh              # roda em modo debug com hot reload
#   ./scripts/run_android.sh --release    # qualquer flag extra vai direto pro flutter run
#   AVD_NAME=Pixel_7 ./scripts/run_android.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

ANDROID_SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
ADB="$ANDROID_SDK/platform-tools/adb"
EMULATOR="$ANDROID_SDK/emulator/emulator"
AVD_NAME="${AVD_NAME:-Pixel_6}"
BOOT_TIMEOUT="${BOOT_TIMEOUT:-180}"

info()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
fail()  { printf '\033[1;31merro:\033[0m %s\n' "$1" >&2; exit 1; }

[ -x "$ADB" ]      || fail "adb não encontrado em $ADB. Ajuste ANDROID_HOME."
[ -x "$EMULATOR" ] || fail "emulator não encontrado em $EMULATOR. Ajuste ANDROID_HOME."

# Um emulador já conectado conta; um device físico não, porque queremos o emulador.
running_emulator() {
  "$ADB" devices | awk '/^emulator-/ && $2 == "device" { print $1; exit }'
}

DEVICE="$(running_emulator || true)"

if [ -z "$DEVICE" ]; then
  if ! "$EMULATOR" -list-avds | grep -qx "$AVD_NAME"; then
    fail "AVD '$AVD_NAME' não existe. Disponíveis:
$("$EMULATOR" -list-avds | sed 's/^/  - /')"
  fi

  info "Ligando emulador '$AVD_NAME'..."
  "$EMULATOR" -avd "$AVD_NAME" -netdelay none -netspeed full >/dev/null 2>&1 &

  info "Esperando o device aparecer..."
  "$ADB" wait-for-device

  info "Esperando o boot terminar (timeout ${BOOT_TIMEOUT}s)..."
  elapsed=0
  until [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
    sleep 2
    elapsed=$((elapsed + 2))
    [ "$elapsed" -lt "$BOOT_TIMEOUT" ] || fail "emulador não terminou o boot em ${BOOT_TIMEOUT}s."
  done

  DEVICE="$(running_emulator)"
fi

info "Emulador pronto: $DEVICE"

info "Resolvendo dependências..."
flutter pub get

# Só paga o custo do build_runner se existir algo pra gerar.
if grep -rlq --include='*.dart' -E '@freezed|@riverpod|@JsonSerializable|DriftDatabase|part .*\.g\.dart' lib 2>/dev/null; then
  info "Rodando codegen..."
  dart run build_runner build --delete-conflicting-outputs
else
  info "Nada pra gerar, pulando codegen."
fi

info "Subindo o app..."
exec flutter run -d "$DEVICE" "$@"
