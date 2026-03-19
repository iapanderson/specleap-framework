#!/usr/bin/env bash

# SpecLeap — Funciones de validación avanzadas
# Fase 2.2

# ============================================================================
# VALIDACIONES POR TIPO
# ============================================================================

validate_string_advanced() {
    local value="$1"
    local pattern="${2:-}"
    local min_length="${3:-0}"
    local max_length="${4:-999999}"
    
    local length=${#value}
    
    # Validar longitud mínima
    if [[ $length -lt $min_length ]]; then
        echo "ERROR:Debe tener al menos $min_length caracteres (actualmente: $length)"
        return 1
    fi
    
    # Validar longitud máxima
    if [[ $length -gt $max_length ]]; then
        echo "ERROR:Debe tener máximo $max_length caracteres (actualmente: $length)"
        return 1
    fi
    
    # Validar patrón regex
    if [[ -n "$pattern" ]] && ! [[ "$value" =~ $pattern ]]; then
        case "$pattern" in
            '^[a-z0-9-]+$')
                echo "ERROR:Solo se permiten letras minúsculas, números y guiones (sin espacios ni mayúsculas)"
                ;;
            '^#[0-9A-Fa-f]{6}$')
                echo "ERROR:Debe ser un código hexadecimal válido (ejemplo: #3B82F6)"
                ;;
            *)
                echo "ERROR:Formato inválido"
                ;;
        esac
        return 1
    fi
    
    return 0
}

validate_select_strict() {
    local value="$1"
    shift
    local options=("$@")
    
    # Normalizar a minúsculas para comparación
    local value_lower="${value,,}"
    
    for opt in "${options[@]}"; do
        if [[ "${opt,,}" == "$value_lower" ]]; then
            # Devolver el valor normalizado (minúsculas)
            echo "$opt"
            return 0
        fi
    done
    
    echo "ERROR:Opción inválida. Opciones válidas: ${options[*]}"
    return 1
}

validate_multiselect() {
    local value="$1"
    shift
    local valid_options=("$@")
    
    # Si está vacío, es válido (si no es required)
    if [[ -z "$value" ]]; then
        return 0
    fi
    
    # Separar por comas
    IFS=',' read -ra selected <<< "$value"
    
    for item in "${selected[@]}"; do
        # Trim espacios
        item="$(echo "$item" | xargs)"
        item_lower="${item,,}"
        
        local found=false
        for opt in "${valid_options[@]}"; do
            if [[ "${opt,,}" == "$item_lower" ]]; then
                found=true
                break
            fi
        done
        
        if [[ "$found" == false ]]; then
            echo "ERROR:Opción inválida '$item'. Opciones válidas: ${valid_options[*]}"
            return 1
        fi
    done
    
    return 0
}

validate_boolean_strict() {
    local value="$1"
    
    case "${value,,}" in
        true|s|si|yes|y|1)
            echo "true"
            return 0
            ;;
        false|n|no|0)
            echo "false"
            return 0
            ;;
        *)
            echo "ERROR:Respuesta inválida. Usa: s/n, true/false, yes/no, 1/0"
            return 1
            ;;
    esac
}

validate_number_range() {
    local value="$1"
    local min="${2:-0}"
    local max="${3:-999999999}"
    
    # Validar que sea número
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "ERROR:Debe ser un número entero"
        return 1
    fi
    
    # Validar rango
    if [[ $value -lt $min ]]; then
        echo "ERROR:Debe ser al menos $min"
        return 1
    fi
    
    if [[ $value -gt $max ]]; then
        echo "ERROR:Debe ser máximo $max"
        return 1
    fi
    
    return 0
}

validate_array_items() {
    local value="$1"
    local min_items="${2:-0}"
    local max_items="${3:-999}"
    local separator="${4:-,}"
    
    # Contar items
    if [[ -z "$value" ]]; then
        local count=0
    else
        IFS="$separator" read -ra items <<< "$value"
        local count=${#items[@]}
    fi
    
    if [[ $count -lt $min_items ]]; then
        echo "ERROR:Debes proporcionar al menos $min_items elemento(s)"
        return 1
    fi
    
    if [[ $count -gt $max_items ]]; then
        echo "ERROR:Puedes proporcionar máximo $max_items elemento(s)"
        return 1
    fi
    
    return 0
}

# ============================================================================
# CONDICIONES Y DEPENDENCIAS
# ============================================================================

should_skip_question() {
    local skip_if_json="$1"
    local answers_file="$2"
    
    # Si no hay skip_if, no skipear
    if [[ "$skip_if_json" == "null" ]] || [[ -z "$skip_if_json" ]]; then
        return 1
    fi
    
    # Extraer campo y valor esperado
    local skip_field=$(echo "$skip_if_json" | jq -r 'keys[0]')
    local skip_value=$(echo "$skip_if_json" | jq -r '.[]')
    
    # Obtener valor actual del campo
    local current_value=$(jq -r ".\"$skip_field\" // \"\"" "$answers_file")
    
    # Si el valor actual coincide con el valor de skip, saltamos
    if [[ "$current_value" == "$skip_value" ]]; then
        return 0  # Sí, skipear
    fi
    
    return 1  # No skipear
}

get_auto_suggest() {
    local auto_suggest_json="$1"
    local dependent_field="$2"
    local answers_file="$3"
    
    # Si no hay auto_suggest, devolver vacío
    if [[ "$auto_suggest_json" == "null" ]] || [[ -z "$auto_suggest_json" ]]; then
        echo ""
        return
    fi
    
    # Obtener valor del campo del que depende
    local dep_value=$(jq -r ".\"$dependent_field\" // \"\"" "$answers_file")
    
    # Obtener sugerencia basada en ese valor
    local suggestion=$(echo "$auto_suggest_json" | jq -r ".\"$dep_value\" // \"\"")
    
    echo "$suggestion"
}

# ============================================================================
# VALIDADOR PRINCIPAL
# ============================================================================

validate_answer() {
    local value="$1"
    local question_json="$2"
    local answers_file="$3"
    
    local q_type=$(echo "$question_json" | jq -r '.type')
    local q_required=$(echo "$question_json" | jq -r '.required')
    local q_validation=$(echo "$question_json" | jq -r '.validation // {}')
    local q_options=$(echo "$question_json" | jq -r '.options // [] | join(" ")')
    
    # Si es vacío y no es requerido, OK
    if [[ -z "$value" ]] && [[ "$q_required" == "false" ]]; then
        echo "OK"
        return 0
    fi
    
    # Si es vacío y es requerido, ERROR
    if [[ -z "$value" ]] && [[ "$q_required" == "true" ]]; then
        echo "ERROR:Esta pregunta es obligatoria"
        return 1
    fi
    
    # Validar según tipo
    case "$q_type" in
        string)
            local pattern=$(echo "$q_validation" | jq -r '.pattern // ""')
            local min_length=$(echo "$q_validation" | jq -r '.min_length // 0')
            local max_length=$(echo "$q_validation" | jq -r '.max_length // 999999')
            
            if ! validate_string_advanced "$value" "$pattern" "$min_length" "$max_length"; then
                return 1
            fi
            echo "OK"
            ;;
            
        text)
            local max_length=$(echo "$q_validation" | jq -r '.max_length // 999999')
            
            if ! validate_string_advanced "$value" "" "0" "$max_length"; then
                return 1
            fi
            echo "OK"
            ;;
            
        select)
            local opts_array=($(echo "$q_options"))
            local result
            if ! result=$(validate_select_strict "$value" "${opts_array[@]}"); then
                echo "$result"
                return 1
            fi
            echo "OK:$result"
            ;;
            
        multiselect)
            local opts_array=($(echo "$q_options"))
            if ! validate_multiselect "$value" "${opts_array[@]}"; then
                return 1
            fi
            echo "OK"
            ;;
            
        boolean)
            local result
            if ! result=$(validate_boolean_strict "$value"); then
                echo "$result"
                return 1
            fi
            echo "OK:$result"
            ;;
            
        number)
            local min=$(echo "$q_validation" | jq -r '.min // 0')
            local max=$(echo "$q_validation" | jq -r '.max // 999999999')
            
            if ! validate_number_range "$value" "$min" "$max"; then
                return 1
            fi
            echo "OK"
            ;;
            
        array)
            local min_items=$(echo "$q_validation" | jq -r '.min_items // 0')
            local max_items=$(echo "$q_validation" | jq -r '.max_items // 999')
            local separator=$(echo "$q_validation" | jq -r '.separator // ","')
            
            if ! validate_array_items "$value" "$min_items" "$max_items" "$separator"; then
                return 1
            fi
            echo "OK"
            ;;
            
        *)
            echo "OK"
            ;;
    esac
    
    return 0
}
