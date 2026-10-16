# Яндекс Алиса, Сбер GigaChat и Google Gemini для Linux (GNOME / Wayland)

<img width="256" height="256" alt="alice_512" src="https://github.com/user-attachments/assets/39f9c777-e156-4883-b5e8-adb223dd5000" />
&nbsp;
<img width="256" height="256" alt="gigachat_512" src="https://github.com/user-attachments/assets/30b18225-0259-40f8-a462-dce7ce2e0b26" />


> Автономные веб-клиенты для ИИ-помощников **Яндекс Алиса**, **Сбер GigaChat** и **Google Gemini** без фоновых демонов и с нативной интеграцией в GNOME и Wayland.

---

## 📌 Зачем это может быть нужно?

У большинства нейросетей нет официальных отдельных десктопных приложений для Linux: пользователям предлагается либо держать открытые вкладки в основном браузере, либо ставить фоновые агенты.

Данный проект решает эту задачу через запуск веб-версий ([ya.ru/alice](https://ya.ru/alice), [giga.chat](https://giga.chat/) и [gemini.google.com](https://gemini.google.com/)) в режиме изолированных веб-приложений (`--app`):

* **Алиса** и **GigaChat** запускаются через установленный **Яндекс Браузер**.
* **Gemini** запускается через **Google Chrome** или **Chromium** (для полной совместимости с аккаунтом Google).

Преимущества:

* 🪟 **Отдельные окна приложений** — без адресной строки, вкладок, панелей расширений и другого визуального шума браузера.
* 🛡️ **Изолированные профили** (`~/.config/alice-app`, `~/.config/gigachat-app`, `~/.config/gemini-app`) — история, кэш и авторизации живут независимо друг от друга и не смешиваются с вашим основным браузером.
* 🚀 **Без фоновых агентов и демонов** — приложения не висят в трее и не расходуют память после закрытия окна.
* 🐧 **Нативная интеграция с GNOME и Wayland**:
  * Корректно отображаются оригинальные иконки в доке (**Dash to Dock**, **Ubuntu Dock**, **Dash**).
  * Решена проблема Wayland с сопоставлением окон (окна не теряют ярлыки и не заменяются на дефолтную шестерёнку `application-x-executable`).
  * Приложения можно закрепить в «Избранное» (Pin to Dash) и переключаться через `Alt+Tab` как между обычными программами.

---

## ⚙️ Системные требования

* **ОС:** Linux (протестировано на ALT Linux, Fedora, Ubuntu и др.)
* **Окружение рабочего стола:** GNOME 40+ под управлением **Wayland** *(под X11 из коробки не работает — см. раздел ниже)*
* **Браузеры:**
  * [Яндекс Браузер](https://browser.yandex.ru/linux/) (`yandex-browser` / `yandex-browser-stable`) — для Алисы и GigaChat
  * [Google Chrome](https://www.google.com/chrome/) или [Chromium](https://www.chromium.org/) — для Gemini

---

## 🚀 Установка

1. Склонируйте репозиторий (или скачайте архив):

   ```bash
   git clone https://github.com/ijin82/ai-wayland-app.git
   cd ai-wayland-app
   ```

2. Запустите скрипт установки:

   ```bash
   ./install.sh
   ```

Скрипт автоматически:

* Скопирует общий скрипт запуска `ai-window.sh` в `~/.bin/` и сделает его исполняемым;
* Пропишет актуальные абсолютные пути в ярлыки `.desktop`;
* Скопирует ярлыки в `~/.local/share/applications/`;
* Установит иконки (`alice_512.png`, `gigachat_512.png`, `gemini_512.png`), а также создаст псевдонимы для Wayland `app_id` в `~/.local/share/icons/hicolor/512x512/apps/`;
* Корректно обновит кэш иконок и базы приложений рабочего стола.

После этого ярлыки **«Алиса»**, **«Gigachat»** и **«Gemini»** появятся в списке приложений GNOME и поиске.

---

## 🖥️ Использование

* **Запуск из меню:** Откройте обзор приложений GNOME (`Super` / `Win`) и найдите **«Алиса»**, **«Gigachat»** или **«Gemini»**.
* **Закрепление в доке:** Правый клик по иконке в доке → **«Добавить в избранное»**.

При первом запуске авторизуйтесь в вашем аккаунте (Яндекс ID / Сбер ID / Google) — сессия сохранится в изолированном каталоге соответствующего профиля.

---

## 🛠️ Настройка

Параметры запуска настраиваются в файле `~/.bin/ai-window.sh`:

### 1. Полноэкранный режим (Kiosk / Smart Display)

Если вы хотите использовать приложение на отдельном мониторе или в полноэкранном режиме, раскомментируйте или добавьте флаг:

```bash
FS_FLAG="--start-fullscreen"
```

### 2. Расположение профилей

По умолчанию данные сессий хранятся в:

* Алиса: `~/.config/alice-app`
* GigaChat: `~/.config/gigachat-app`
* Gemini: `~/.config/gemini-app`

При необходимости директории можно изменить в скрипте.

---

## 🧩 Технические подробности (Wayland & GNOME)

В сессиях Wayland композитор Mutter сопоставляет окна с ярлыками рабочего стола через свойство `app_id`. Chromium при запуске с флагом `--app=<URL>` генерирует идентификатор на основе хоста и пути URL:

* Для `https://ya.ru/alice` $\rightarrow$ `chrome-ya.ru__alice-Default`
* Для `https://giga.chat/` $\rightarrow$ `chrome-giga.chat__-Default`
* Для `https://gemini.google.com/` $\rightarrow$ `chrome-gemini.google.com__-Default`

Традиционный флаг `--class` в среде Wayland игнорируется. Чтобы док GNOME и переключатель `Alt+Tab` корректно группировали окна и отображали оригинальные иконки вместо дефолтной шестерёнки:

* В `alice-app.desktop` задан `StartupWMClass=chrome-ya.ru__alice-Default`;
* В `gigachat-app.desktop` задан `StartupWMClass=chrome-giga.chat__-Default`;
* В `gemini-app.desktop` задан `StartupWMClass=chrome-gemini.google.com__-Default`;
* В `install.sh` создаются псевдонимы иконок с соответствующими идентификаторами `app_id`.

---

## ⚠️ Почему это не будет работать в X11 (Xorg) и как адаптировать?

Текущая конфигурация «из коробки» **рассчитана исключительно на сессию Wayland**. Если запустить её в X11, окно не сможет связаться с ярлыком: в доке появится шестерёнка либо окно объединится в одну группу с основным окном соответствующего браузера.

### В чём разница

* В **Wayland** сопоставление выполняется по `app_id` (генерируется Chromium по URL).
* В **X11 (Xorg)** оконный менеджер сопоставляет окна по свойству `WM_CLASS`, которое состоит из двух значений `(instance, class)`:
  * По умолчанию Chromium в X11 генерирует `WM_CLASS` без префикса `chrome-` и суффикса `-Default`.
  * Из-за этого значение `StartupWMClass=chrome-...` в X11 не совпадает, и среда считает окно частью основного браузера или неизвестным приложением.

### Что теоретически нужно исправить для X11

1. **В файлах `.desktop`:**
   Изменить `StartupWMClass` на класс окна X11 (например, `AliceApp`, `GigaChatApp`, `GeminiApp`).

2. **В файле `ai-window.sh`:**
   Задать желаемый класс в `APP_CLASS` (под X11 Chromium реагирует на флаг `--class="<APP_CLASS>"`).

3. **Обновить кэш ярлыков:**

   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

*(Узнать точный класс любого открытого окна в X11 можно командой `xprop WM_CLASS`, кликнув затем по окну приложения).*

---

## 🗑️ Удаление

Чтобы удалить ярлыки и иконки из системы:

```bash
rm -f ~/.bin/ai-window.sh
rm -f ~/.local/share/applications/alice-app.desktop ~/.local/share/applications/gigachat-app.desktop ~/.local/share/applications/gemini-app.desktop
rm -f ~/.local/share/icons/hicolor/512x512/apps/alice_512.png ~/.local/share/icons/hicolor/512x512/apps/gigachat_512.png ~/.local/share/icons/hicolor/512x512/apps/gemini_512.png
rm -f ~/.local/share/icons/hicolor/512x512/apps/chrome-ya.ru__alice-Default.png ~/.local/share/icons/hicolor/512x512/apps/chrome-giga.chat__-Default.png ~/.local/share/icons/hicolor/512x512/apps/chrome-gemini.google.com__-Default.png
gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor 2>/dev/null || true
update-desktop-database ~/.local/share/applications 2>/dev/null || true
```

‼️ Если хотите также удалить сохранённые профили и кэш:

```bash
rm -rf ~/.config/alice-app ~/.config/gigachat-app ~/.config/gemini-app
```
