#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="./setup.log"

# Сохраняем stdout/stderr
exec 3>&1 4>&2

# Вывод обычных сообщений на экран + лог через tee
exec > >(tee -a "$LOG_FILE") 2>&1

# Трассировка команд bash в отдельный fd
BASH_XTRACEFD=5
exec 5>>"$LOG_FILE"
set -x

#info messages
BLUE="\033[1m\033[34m"
RESET="\033[0m"

info() {
   echo ""
   echo -e "${BLUE}=== $1 ===${RESET}"
   echo ""
}

#success messages
GREEN="\033[1;32m"
RESET="\033[0m"

success() {
   echo ""
   echo -e "${GREEN}=== $1 ===${RESET}"
   echo ""
}

#error messages
RED="\033[1;31m"
RESET="\033[0m"

error() {
   echo ""
   echo -e "${RED}=== $1 ===${RESET}"
   echo ""
}

info "=== Полное обновление системы перед установкой ==="
sudo apt update -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt clean

info "=== Установка основных утилит ==="
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

info "=== Установка Python и pip ==="
sudo apt install -y python3 python3-pip python3-venv

info "=== Установка Git ==="
sudo apt install -y git

info "=== Установка Fish Shell ==="
sudo apt install -y fish

info "=== Установка Docker ==="
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

info "=== Добавление пользователя в группу docker ==="
sudo usermod -aG docker "$USER"

echo "=== Установка Node.js (LTS) и npm ==="
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

info "=== Очистка ==="
sudo apt autoremove -y && sudo apt clean

echo
success "✅ Установка завершена!"
info "ℹ️  Выйдите и зайдите снова, чтобы изменения (docker group) вступили в силу."
echo

info "=== Самопроверка установленных пакетов ==="

check() {
    local name="$1"
    local cmd="$2"
    if command -v $cmd >/dev/null 2>&1; then
        success "✅ $name: $($cmd --version 2>/dev/null | head -n 1)"
    else
        error "❌ $name: не найден"
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
success "=== Проверка завершена ==="
