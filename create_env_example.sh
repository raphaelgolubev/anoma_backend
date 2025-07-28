#!/bin/bash

# Проверяем, существует ли .env файл
if [ ! -f ".env" ]; then
    echo "❌ Файл .env не найден!"
    echo "Создайте файл .env с настройками окружения перед запуском этого скрипта."
    exit 1
fi

# Создаем .env.example на основе .env
cp .env .env.example

# Заменяем реальные значения на placeholder'ы
sed -i '' 's/=.*/=your_value/g' .env.example

# Добавляем комментарии для лучшего понимания
echo "# Пример файла .env" > .env.example.tmp
echo "# Скопируйте этот файл в .env и заполните реальными значениями" >> .env.example.tmp
echo "" >> .env.example.tmp
cat .env.example >> .env.example.tmp
mv .env.example.tmp .env.example

echo "✅ Файл .env.example создан успешно!"
echo "📝 Теперь вы можете отредактировать .env.example, добавив описания для каждой переменной" 