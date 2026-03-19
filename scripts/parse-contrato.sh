#!/usr/bin/env bash

# Cargar sistema i18n
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../.specleap/i18n.sh"

# SpecLeap — Parser CONTRATO.md → JSON
# Extrae YAML frontmatter y lo convierte a JSON para procesamiento

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

print_error() {
    echo -e "${RED}$(t "scripts.error"): $1${RESET}" >&2
}

print_success() {
    echo -e "${GREEN}$(t "scripts.success") $1${RESET}" >&2
}

print_info() {
    echo -e "${CYAN}$(t "scripts.info") $1${RESET}" >&2
}

# ============================================================================
# PARSER
# ============================================================================

parse_contrato() {
    local contrato_file="$1"
    local output_file="${2:-}"
    
    if [[ ! -f "$contrato_file" ]]; then
        print_error "Archivo no encontrado: $contrato_file"
        return 1
    fi
    
    # Verificar que yq esté instalado
    if ! command -v yq &> /dev/null; then
        print_error "yq no está instalado. Instala con: brew install yq"
        return 1
    fi
    
    print_info "Parseando $contrato_file..."
    
    # Extraer solo el YAML frontmatter (entre --- ---)
    # Usa awk para capturar solo el primer bloque entre --- (líneas 2 hasta el segundo ---)
    local json_output
    if json_output=$(awk '/^---$/{if(++n==2) exit; next} n==1' "$contrato_file" | yq eval -o=json '.' - 2>/dev/null); then
        if [[ -n "$output_file" ]]; then
            echo "$json_output" > "$output_file"
            print_success "JSON exportado a: $output_file"
        else
            echo "$json_output"
        fi
        return 0
    else
        print_error "Fallo al parsear YAML frontmatter"
        return 1
    fi
}

# ============================================================================
# VALIDACIÓN
# ============================================================================

validate_contrato() {
    local contrato_file="$1"
    
    print_info "Validando estructura CONTRATO.md..."
    
    # Parsear a JSON
    local json
    if ! json=$(parse_contrato "$contrato_file"); then
        return 1
    fi
    
    # Validar campos obligatorios
    local required_fields=(
        ".project.name"
        ".project.display_name"
        ".identity.objective"
        ".identity.problem_solved"
        ".stack.backend.framework"
        ".features.core"
    )
    
    local errors=0
    
    for field in "${required_fields[@]}"; do
        local value=$(echo "$json" | jq -r "$field // empty")
        if [[ -z "$value" ]] || [[ "$value" == "null" ]]; then
            print_error "Campo obligatorio faltante: $field"
            errors=$((errors + 1))
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        print_success "CONTRATO válido"
        return 0
    else
        print_error "CONTRATO inválido: $errors campos faltantes"
        return 1
    fi
}

# ============================================================================
# EXTRACCIÓN DE CAMPOS ESPECÍFICOS
# ============================================================================

get_project_name() {
    local contrato_file="$1"
    parse_contrato "$contrato_file" | jq -r '.project.name'
}

get_core_features() {
    local contrato_file="$1"
    parse_contrato "$contrato_file" | jq -r '.features.core[]'
}

get_backend_framework() {
    local contrato_file="$1"
    parse_contrato "$contrato_file" | jq -r '.stack.backend.framework'
}

get_frontend_framework() {
    local contrato_file="$1"
    parse_contrato "$contrato_file" | jq -r '.stack.frontend.framework'
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    local command="${1:-parse}"
    local contrato_file="${2:-}"
    local output_file="${3:-}"
    
    case "$command" in
        parse)
            if [[ -z "$contrato_file" ]]; then
                echo "Uso: $0 parse <CONTRATO.md> [output.json]"
                exit 1
            fi
            parse_contrato "$contrato_file" "$output_file"
            ;;
        validate)
            if [[ -z "$contrato_file" ]]; then
                echo "Uso: $0 validate <CONTRATO.md>"
                exit 1
            fi
            validate_contrato "$contrato_file"
            ;;
        get-name)
            if [[ -z "$contrato_file" ]]; then
                echo "Uso: $0 get-name <CONTRATO.md>"
                exit 1
            fi
            get_project_name "$contrato_file"
            ;;
        get-features)
            if [[ -z "$contrato_file" ]]; then
                echo "Uso: $0 get-features <CONTRATO.md>"
                exit 1
            fi
            get_core_features "$contrato_file"
            ;;
        *)
            echo "Comandos disponibles:"
            echo "  parse      <CONTRATO.md> [output.json]  — Parsear YAML → JSON"
            echo "  validate   <CONTRATO.md>                — Validar estructura"
            echo "  get-name   <CONTRATO.md>                — Obtener nombre proyecto"
            echo "  get-features <CONTRATO.md>              — Listar features core"
            exit 1
            ;;
    esac
}

# Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
