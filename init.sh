#!/usr/bin/env bash

set -e  # завершать при ошибке
set -u  # ошибка при обращении к несуществующей переменной
set -x  # показывать команды (для отладки)

echo "=== Полное обновление системы перед установкой ==="
sudo apt update -y
sudo apt full-upgrade -y
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
    lsb-release \
    micro

echo "=== Установка Python и pip ==="
sudo apt install -y python3 python3-pip python3-venv

echo "=== Установка Git ==="
sudo apt install -y git

echo "=== Установка Fish Shell ==="
sudo apt install -y fish

echo "=== Установка Docker ==="
# Добавим официальный репозиторий Docker
# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
echo

echo "=== Самопроверка установленных пакетов ==="

check() {
    local name="$1"
    local cmd="$2"
    if command -v $cmd >/dev/null 2>&1; then
        echo "✅ $name: $($cmd --version 2>/dev/null | head -n 1)"
    else
        echo "❌ $name: не найден"
    fi
}

check "Python3" "python3"
check "Pip3" "pip3"
check "Git" "git"
check "Fish" "fish"
check "Docker" "docker"
check "Docker Compose" "docker compose"
check "Node.js" "node"
check "npm" "npm"
check "curl" "curl"
check "wget" "wget"
check "vim" "vim"
check "htop" "htop"
check "Micro" "micro"

echo
echo "=== Проверка завершена ==="
