#!/usr/bin/env bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=> Переходим в директорию скрипта${NC}"
cd "$(dirname "$0")" || { echo -e "${RED}Ошибка: Не удалось перейти в директорию скрипта${NC}" && exit 1; }

echo -e "${GREEN}=> Проверяем наличие директорий ./chans и ./chlog${NC}"

# Проверяем/создаём директорию для состояния каналов
if [ ! -d "./chans" ]; then
    echo -e "${GREEN}=> Создаём директорию ./chans${NC}"
    mkdir -p ./chans
    if [ $? -ne 0 ]; then
        echo -e "${RED}Ошибка: Не удалось создать директорию ./chans (проверьте права доступа)${NC}"
        exit 1
    fi
fi

# Проверяем/создаём директорию для логов каналов
if [ ! -d "./chlog" ]; then
    echo -e "${GREEN}=> Создаём директорию ./chlog${NC}"
    mkdir -p ./chlog
    if [ $? -ne 0 ]; then
        echo -e "${RED}Ошибка: Не удалось создать директорию ./chlog (проверьте права доступа)${NC}"
        exit 1
    fi
fi

# Проверяем/создаём директорию ./sconf
echo -e "${GREEN}=> Проверяем наличие директории ./sconf${NC}"
if [ ! -d "./sconf" ]; then
    echo -e "${GREEN}=> Создаём директорию ./sconf${NC}"
    mkdir -p ./sconf
    if [ $? -ne 0 ]; then
        echo -e "${RED}Ошибка: Не удалось создать директорию ./sconf (проверьте права доступа)${NC}"
        exit 1
    fi
fi

# Проверяем наличие и содержимое pass.txt
PASSWORD_FILE="./sconf/pass.txt"
if [ -f "$PASSWORD_FILE" ] && [ -s "$PASSWORD_FILE" ]; then
    echo -e "${GREEN}=> Найден и используется парольный файл: $PASSWORD_FILE${NC}"
    PASSWORD_ARG="--password-file $PASSWORD_FILE"
else
    echo -e "${GREEN}=> Парольный файл отсутствует или пуст — опция --password-file не будет использована${NC}"
    PASSWORD_ARG=""
fi

echo -e "${GREEN}=> Активируем виртуальное окружение${NC}"
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate || { echo -e "${RED}Ошибка: Не удалось активировать виртуальное окружение${NC}" && exit 1; }
else
    echo -e "${RED}Ошибка: Виртуальное окружение не найдено (${PWD}/.venv)${NC}"
    exit 1
fi

echo -e "${GREEN}=> Запускаем miniircd${NC}"
./miniircd --listen 0.0.0.0 --motd motd.txt --state-dir ./chans --channel-log-dir ./chlog --verbose --log-file miniircd.log $PASSWORD_ARG