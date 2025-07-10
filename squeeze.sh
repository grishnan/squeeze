#!/bin/bash

show_help() {
	echo "Использование: $0 <аргумент1> <аргумент2>"
    echo
    echo "Пример:"
    echo "$0 mkv mp4"
    echo
    echo "Аргументы:"
    echo "аргумент1 - из какого формата сконвертировать"
    echo "аргумент2 - в какой формат сконвертировать"
    echo
    echo "Дополнительная информация:"
    echo "Скрипт предназначен для массовой конвертации видеофайлов"
    echo "из одного формата в другой. Исходные файлы будут удалены"
}

if [ $# -lt 2 ]
then
	show_help
	exit 1
fi

if ! command -v ffmpeg &> /dev/null
then
	echo "Установите ffmpeg"
	exit 2
fi

inpext="$1" # входное расширение имён файлов
outext="$2" # выходное расширение имён файлов

convert() {
	filename="$1"
	ffmpeg -nostdin -i "$filename" -f "$outext" "${filename%.*}.$outext"
}

find . -maxdepth 1 -type f -print0 | while IFS= read -r -d '' filename
do
	# если расширение имени файла совпадает с входным расширением
	if [[ $(awk -F'.' '{print $NF}' <<< "$filename") = "$inpext" ]]
	then
		convert "$filename"
		rm -f "$filename"
	fi
done
