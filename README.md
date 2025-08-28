# 🚀 Ubuntu Setup Script

Этот скрипт устанавливает базовый набор инструментов разработчика на "чистую" Ubuntu:

- 🐍 Python 3 + pip
- 🐙 Git
- 🐟 Fish Shell
- 🐳 Docker + Docker Compose
- 🟢 Node.js (LTS) + npm
- 🛠️ Полезные утилиты: curl, wget, unzip, vim, htop, build-essential и др.

---

## ⚡ Установка

Выполните команду :

```bash
curl -fsSL https://raw.githubusercontent.com/0-programmer/host_init/main/init.sh | sudo bash 2>&1 | sudo tee setup.log
