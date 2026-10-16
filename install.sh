#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DESKTOP_FILE_ALICE="$SCRIPT_DIR/alice-app.desktop"
DESKTOP_FILE_GIGACHAT="$SCRIPT_DIR/gigachat-app.desktop"
DESKTOP_FILE_GEMINI="$SCRIPT_DIR/gemini-app.desktop"
ICON_FILE_ALICE="$SCRIPT_DIR/icons/alice_512.png"
ICON_FILE_GIGACHAT="$SCRIPT_DIR/icons/gigachat_512.png"
ICON_FILE_GEMINI="$SCRIPT_DIR/icons/gemini_512.png"

APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/512x512/apps"
BIN_DIR="$HOME/.bin"

# Создаём папки, если их нет
mkdir -p "$APP_DIR"
mkdir -p "$ICON_DIR"
mkdir -p "$BIN_DIR"

# Удаляем некорректный локальный index.theme, если он был создан
# (тема hicolor наследует структуру из /usr/share/icons/hicolor/index.theme;
# неполный index.theme в ~/.local/share ломает обнаружение иконок)
rm -f "$HOME/.local/share/icons/hicolor/index.theme"
rm -f "$ICON_DIR/chrome-ya.ru__gigachat-Default.png"

# Делаем скрипт запуска исполняемым
chmod +x "$SCRIPT_DIR/ai-window.sh"
cp "$SCRIPT_DIR/ai-window.sh" "$BIN_DIR/ai-window.sh"
chmod +x "$BIN_DIR/ai-window.sh"

# Копируем .desktop с подстановкой актуального пути к скрипту запуска
sed "s|^Exec=.*|Exec=$BIN_DIR/ai-window.sh alice|" "$DESKTOP_FILE_ALICE" > "$APP_DIR/alice-app.desktop"
echo "✓ alice-app.desktop → $APP_DIR/ (с путём $BIN_DIR/ai-window.sh)"

sed "s|^Exec=.*|Exec=$BIN_DIR/ai-window.sh gigachat|" "$DESKTOP_FILE_GIGACHAT" > "$APP_DIR/gigachat-app.desktop"
echo "✓ gigachat-app.desktop → $APP_DIR/ (с путём $BIN_DIR/ai-window.sh)"

sed "s|^Exec=.*|Exec=$BIN_DIR/ai-window.sh gemini|" "$DESKTOP_FILE_GEMINI" > "$APP_DIR/gemini-app.desktop"
echo "✓ gemini-app.desktop → $APP_DIR/ (с путём $BIN_DIR/ai-window.sh)"

# Копируем иконки
cp "$ICON_FILE_ALICE" "$ICON_DIR/alice_512.png"
echo "✓ alice_512.png → $ICON_DIR/"

cp "$ICON_FILE_GIGACHAT" "$ICON_DIR/gigachat_512.png"
echo "✓ gigachat_512.png → $ICON_DIR/"

cp "$ICON_FILE_GEMINI" "$ICON_DIR/gemini_512.png"
echo "✓ gemini_512.png → $ICON_DIR/"

# Создаём копии/симлинки с именами Wayland app_id для прямого сопоставления mutter/gnome-shell
cp "$ICON_FILE_ALICE" "$ICON_DIR/chrome-ya.ru__alice-Default.png"
echo "✓ chrome-ya.ru__alice-Default.png → $ICON_DIR/"

cp "$ICON_FILE_GIGACHAT" "$ICON_DIR/chrome-giga.chat__-Default.png"
echo "✓ chrome-giga.chat__-Default.png → $ICON_DIR/"

cp "$ICON_FILE_GEMINI" "$ICON_DIR/chrome-gemini.google.com__-Default.png"
echo "✓ chrome-gemini.google.com__-Default.png → $ICON_DIR/"

# Обновляем кэш иконок (флаг -t игнорирует отсутствие локального index.theme)
if command -v gtk-update-icon-cache &>/dev/null; then
  gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" &>/dev/null || true
fi

# Обновляем кэш .desktop (если update-desktop-database есть)
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$APP_DIR" &>/dev/null || true
fi

echo "Готово. Алиса, Gigachat и Gemini должны появиться в гриде приложений GNOME."

