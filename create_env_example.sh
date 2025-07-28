#!/bin/bash

# Создает .env.example на основе существующего .env файла.
# Формат строки в .env файле:
# PARAMETER="some secret value" # example: "value"
# Скрипт распарсит комментарий и выполнит подстановку

# Проверяем, существует ли .env файл
if [ ! -f ".env" ]; then
    echo "❌ Файл .env не найден!"
    echo "Создайте файл .env с настройками окружения перед запуском этого скрипта."
    exit 1
fi

# Создаем .env.example на основе .env
cp .env .env.example

# Обрабатываем каждую строку
while IFS= read -r line; do
    # Если это строка с переменной (содержит =)
    if [[ "$line" =~ ^[[:space:]]*[A-Z_][A-Z0-9_]*[[:space:]]*=[[:space:]]* ]]; then
        # Извлекаем имя переменной
        var_name=$(echo "$line" | sed 's/^[[:space:]]*\([A-Z_][A-Z0-9_]*\)[[:space:]]*=.*/\1/')
        
        # Ищем пример в комментарии используя sed (сохраняем кавычки)
        example=$(echo "$line" | sed -n 's/.*# example: *\([^[:space:]]*\)/\1/p')
        
        # Если пример не найден, используем your_value
        if [ -z "$example" ]; then
            example="your_value"
        fi
        
        # Заменяем значение на пример
        echo "${var_name}=${example}" >> .env.example.tmp
    else
        # Копируем комментарии и пустые строки как есть
        echo "$line" >> .env.example.tmp
    fi
done < .env.example

# Заменяем оригинальный файл
mv .env.example.tmp .env.example

echo "✅ Файл .env.example создан успешно!"
echo "📝 Примеры извлечены из комментариев" 