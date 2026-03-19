#!/bin/bash
# SpecLeap i18n Helper
# Carga traducciones según el idioma configurado

# Detectar directorio raíz de SpecLeap
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECLEAP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Detectar idioma configurado
if [ -f "$SPECLEAP_ROOT/.specleap/config.json" ]; then
    SPECLEAP_LANG=$(grep -o '"language": "[^"]*"' "$SPECLEAP_ROOT/.specleap/config.json" | cut -d'"' -f4)
else
    SPECLEAP_LANG="${SPECLEAP_LANG:-es}"
fi

# Archivo de traducciones
I18N_FILE="$SPECLEAP_ROOT/.specleap/i18n/${SPECLEAP_LANG}.json"

# Función para obtener traducción
# Uso: t "questionnaire.title"
#      t "errors.no_path"
t() {
    local key=$1
    
    if [ ! -f "$I18N_FILE" ]; then
        echo "$key"
        return
    fi
    
    # Dividir la clave en partes (ej: "questionnaire.title" → ["questionnaire", "title"])
    IFS='.' read -ra PARTS <<< "$key"
    
    # Usar jq si está disponible (más robusto)
    if command -v jq &> /dev/null; then
        local jq_query=".${PARTS[0]}"
        for (( i=1; i<${#PARTS[@]}; i++ )); do
            jq_query="${jq_query}.${PARTS[$i]}"
        done
        local value=$(jq -r "$jq_query" "$I18N_FILE" 2>/dev/null)
        
        if [ "$value" != "null" ] && [ -n "$value" ]; then
            echo "$value"
        else
            echo "$key"
        fi
    else
        # Fallback: grep simple (menos robusto, pero funciona sin jq)
        local search_key="${PARTS[-1]}"
        local value=$(grep "\"$search_key\":" "$I18N_FILE" | head -1 | sed 's/.*: "\(.*\)".*/\1/')
        
        if [ -n "$value" ]; then
            echo "$value"
        else
            echo "$key"
        fi
    fi
}

# Exportar variables y funciones
export SPECLEAP_LANG
export SPECLEAP_ROOT
export I18N_FILE
export -f t 2>/dev/null || true
