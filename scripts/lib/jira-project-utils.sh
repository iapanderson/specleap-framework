#!/usr/bin/env bash

# SpecLeap — Utilidades para gestión de proyectos Jira
# Funciones para crear/verificar proyectos Jira independientes

set -euo pipefail

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

print_success() {
    echo -e "${GREEN}✅ $1${RESET}" >&2
}

print_error() {
    echo -e "${RED}❌ Error: $1${RESET}" >&2
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${RESET}" >&2
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${RESET}" >&2
}

# ============================================================================
# GENERACIÓN DE PROJECT KEY
# ============================================================================

generate_project_key() {
    local project_name="$1"
    
    # Convertir nombre a key válida de Jira:
    # - Solo mayúsculas
    # - Sin guiones ni espacios (reemplazar con nada)
    # - Máximo 10 caracteres
    # - Mínimo 2 caracteres
    
    # Ejemplos:
    # "casa-de-peli" → "CASADEPELI" → "CASADEPEL" (10 chars)
    # "mi-app" → "MIAPP" (5 chars)
    # "e-commerce" → "ECOMMERCE" → "ECOMMERCE" (9 chars)
    
    local key=$(echo "$project_name" | tr '[:lower:]' '[:upper:]' | tr -d '-_ ' | head -c 10)
    
    # Validar longitud mínima
    if [[ ${#key} -lt 2 ]]; then
        print_error "Project key muy corto: $key (mínimo 2 caracteres)"
        return 1
    fi
    
    echo "$key"
}

# ============================================================================
# VERIFICACIÓN DE PROYECTO JIRA
# ============================================================================

jira_project_exists() {
    local project_key="$1"
    
    # Intentar obtener info del proyecto vía MCP Jira
    # Si el proyecto no existe, el comando fallará
    
    # Método 1: Usar MCP Jira (si está configurado)
    if command -v mcp-jira &> /dev/null; then
        if mcp-jira get-project "$project_key" &> /dev/null; then
            return 0  # Proyecto existe
        else
            return 1  # Proyecto no existe
        fi
    fi
    
    # Método 2: Usar Jira CLI (si está instalado)
    if command -v jira &> /dev/null; then
        if jira project view "$project_key" &> /dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    fi
    
    # Método 3: Verificación manual (sin herramientas)
    print_warning "No se puede verificar proyecto automáticamente (MCP Jira no encontrado)"
    print_info "Por favor verifica manualmente si el proyecto $project_key existe en Jira"
    
    # Preguntar al usuario
    read -p "¿El proyecto $project_key existe en Jira? [s/N]: " -n 1 -r >&2
    echo >&2
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# CREACIÓN DE PROYECTO JIRA
# ============================================================================

create_jira_project() {
    local project_key="$1"
    local project_name="$2"
    local project_description="$3"
    local lead_email="${4:-}"  # Opcional
    
    print_info "Intentando crear proyecto Jira: $project_key ($project_name)"
    
    # Método 1: Usar MCP Jira (si está configurado)
    if command -v mcp-jira &> /dev/null; then
        print_info "Usando MCP Jira para crear proyecto..."
        
        if mcp-jira create-project \
            --key "$project_key" \
            --name "$project_name" \
            --description "$project_description" \
            --type scrum \
            ${lead_email:+--lead "$lead_email"} 2>&1; then
            
            print_success "Proyecto $project_key creado exitosamente"
            return 0
        else
            print_error "Fallo al crear proyecto con MCP Jira"
            return 1
        fi
    fi
    
    # Método 2: Usar Jira CLI (si está instalado)
    if command -v jira &> /dev/null; then
        print_info "Usando Jira CLI para crear proyecto..."
        
        if jira project create \
            --key "$project_key" \
            --name "$project_name" \
            --template "Scrum software development" \
            ${lead_email:+--lead "$lead_email"} 2>&1; then
            
            print_success "Proyecto $project_key creado exitosamente"
            return 0
        else
            print_error "Fallo al crear proyecto con Jira CLI"
            return 1
        fi
    fi
    
    # Método 3: Instrucciones manuales (sin herramientas)
    print_warning "No se puede crear proyecto automáticamente (herramientas no encontradas)"
    print_info ""
    print_info "Por favor crea el proyecto manualmente en Jira:"
    print_info ""
    print_info "  1. Ve a Jira → Proyectos → Crear proyecto"
    print_info "  2. Selecciona: Scrum software development"
    print_info "  3. Clave del proyecto: $project_key"
    print_info "  4. Nombre del proyecto: $project_name"
    print_info "  5. Descripción: $project_description"
    print_info ""
    
    read -p "¿Ya creaste el proyecto $project_key en Jira? [s/N]: " -n 1 -r >&2
    echo >&2
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        print_success "Proyecto $project_key confirmado"
        return 0
    else
        print_error "Operación cancelada. Crea el proyecto en Jira y vuelve a ejecutar."
        return 1
    fi
}

# ============================================================================
# FLUJO COMPLETO: VERIFICAR O CREAR PROYECTO
# ============================================================================

ensure_jira_project_exists() {
    local project_key="$1"
    local project_name="$2"
    local project_description="$3"
    local lead_email="${4:-}"  # Opcional
    
    print_info "Verificando proyecto Jira: $project_key"
    
    if jira_project_exists "$project_key"; then
        print_success "Proyecto $project_key ya existe"
        return 0
    else
        print_warning "Proyecto $project_key no existe. Creando..."
        
        if create_jira_project "$project_key" "$project_name" "$project_description" "$lead_email"; then
            return 0
        else
            print_error "No se pudo crear el proyecto $project_key"
            return 1
        fi
    fi
}

# ============================================================================
# VALIDACIÓN DE KEY
# ============================================================================

validate_project_key() {
    local key="$1"
    
    # Reglas de Jira para project keys:
    # - Solo letras mayúsculas (A-Z)
    # - Longitud: 2-10 caracteres
    # - Debe empezar con letra
    
    if [[ ! "$key" =~ ^[A-Z][A-Z0-9]{1,9}$ ]]; then
        print_error "Project key inválida: $key"
        print_error "Debe contener solo mayúsculas, 2-10 caracteres, empezar con letra"
        return 1
    fi
    
    return 0
}
