#!/usr/bin/env bash

set -e  # завершать при ошибке
set -u  # ошибка при обращении к несуществующей переменной

echo "=== Полное обновление системы перед установкой ==="
sudo apt update -y
sudo apt full-upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean

echo "=== Установка основных утилит ==="
sudo apt install -y \
    curl \
    wget \
    unzip \
    vim \
    htop \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release

echo "=== Установка Python и pip ==="
sudo apt install -y python3 python3-pip python3-venv

echo "=== Установка Git ==="
sudo apt install -y git

echo "=== Установка Fish Shell ==="
sudo apt install -y fish

echo "=== Установка Docker ==="
# Добавим официальный репозиторий Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Добавление пользователя в группу docker ==="
sudo usermod -aG docker "$USER"

echo "=== Установка Node.js (LTS) и npm ==="
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "=== Очистка ==="
sudo apt autoremove -y && sudo apt clean

echo
echo "✅ Установка завершена!"
echo "ℹ️  Выйдите и зайдите снова, чтобы изменения (docker group) вступили в силу."
echo "ℹ️  Версия Node.js: $(node -v 2>/dev/null || echo 'не установлена')"
echo "ℹ️  Версия npm: $(npm -v 2>/dev/null || echo 'не установлена')"
