#!/bin/bash

for file in *; do
    file_with_path="$(wslpath -w "./$file")"
    zone_identifier="$file_with_path:Zone.Identifier"
    
    if [ -e "$zone_identifier" ]; then
        rm -- "$zone_identifier"
        echo "Removido identificador de zona para: $file_with_path"
    else
        echo "Nenhum identificador de zona encontrado para: $file_with_path"
    fi
done

