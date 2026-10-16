#!/usr/bin/env bash

if [ "$1" = "alice" ]; then
    # alice
    BROWSER_BIN=$(command -v yandex-browser-stable || command -v yandex-browser)
    if [[ -z "$BROWSER_BIN" ]]; then
        echo "Ошибка: Яндекс.Браузер не найден в системе!" >&2
        exit 1
    fi
    URL="https://ya.ru/alice"
    APP_CLASS="chrome-ya.ru__alice-Default"
    PROFILE_DIR="$HOME/.config/alice-app"

elif [ "$1" = "gigachat" ]; then
    # gigachat
    BROWSER_BIN=$(command -v yandex-browser-stable || command -v yandex-browser)
    if [[ -z "$BROWSER_BIN" ]]; then
        echo "Ошибка: Яндекс.Браузер не найден в системе!" >&2
        exit 1
    fi
    URL="https://giga.chat/"
    APP_CLASS="chrome-giga.chat__-Default"
    PROFILE_DIR="$HOME/.config/gigachat-app"

elif [ "$1" = "gemini" ]; then
    # gemini
    BROWSER_BIN=$(command -v google-chrome-stable || command -v google-chrome || command -v chromium || command -v chromium-browser)
    if [[ -z "$BROWSER_BIN" ]]; then
        echo "Ошибка: Google Chrome или Chromium не найден в системе!" >&2
        exit 1
    fi
    URL="https://gemini.google.com/"
    APP_CLASS="chrome-gemini.google.com__-Default"
    PROFILE_DIR="$HOME/.config/gemini-app"

else
    echo "Usage: $0 {alice|gigachat|gemini}" >&2
    exit 1
fi

# Чтобы запускать в полноэкранном режиме, раскомментируйте:
# FS_FLAG="--start-fullscreen"

exec "$BROWSER_BIN" \
  --app="$URL" \
  --class="$APP_CLASS" \
  --user-data-dir="$PROFILE_DIR" \
  --no-first-run \
  --no-default-browser-check \
  ${FS_FLAG:+"$FS_FLAG"} \
  "$@"
