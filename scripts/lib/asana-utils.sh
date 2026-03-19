#!/usr/bin/env bash

# SpecLeap — Utilidades para Asana API
# Funciones helper para interactuar con Asana

# Verificar token
asana_check_auth() {
    if [[ -z "${ASANA_ACCESS_TOKEN:-}" ]]; then
        echo "❌ Error: ASANA_ACCESS_TOKEN no configurado" >&2
        return 1
    fi
}

# Obtener workspace por defecto
asana_get_default_workspace() {
    asana_check_auth || return 1
    
    local response=$(curl -s \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        "https://app.asana.com/api/1.0/users/me")
    
    echo "$response" | jq -r '.data.workspaces[0].gid'
}

# Crear proyecto
# Uso: asana_create_project "Nombre del Proyecto"
asana_create_project() {
    local project_name="$1"
    asana_check_auth || return 1
    
    if [[ -z "${ASANA_WORKSPACE_GID:-}" ]]; then
        echo "❌ Error: ASANA_WORKSPACE_GID no configurado" >&2
        return 1
    fi
    
    local payload=$(jq -n \
        --arg name "$project_name" \
        --arg workspace "$ASANA_WORKSPACE_GID" \
        '{
            data: {
                name: $name,
                workspace: $workspace,
                notes: "Proyecto generado por SpecLeap",
                color: "dark-blue",
                layout: "list"
            }
        }')
    
    local response=$(curl -s \
        -X POST \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "https://app.asana.com/api/1.0/projects")
    
    local project_gid=$(echo "$response" | jq -r '.data.gid')
    
    if [[ "$project_gid" == "null" || -z "$project_gid" ]]; then
        echo "❌ Error al crear proyecto: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return 1
    fi
    
    echo "$project_gid"
}

# Crear sección en un proyecto
# Uso: asana_create_section "PROJECT_GID" "Nombre Sección"
asana_create_section() {
    local project_gid="$1"
    local section_name="$2"
    asana_check_auth || return 1
    
    local payload=$(jq -n \
        --arg name "$section_name" \
        '{
            data: {
                name: $name
            }
        }')
    
    local response=$(curl -s \
        -X POST \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "https://app.asana.com/api/1.0/projects/$project_gid/sections")
    
    local section_gid=$(echo "$response" | jq -r '.data.gid')
    
    if [[ "$section_gid" == "null" || -z "$section_gid" ]]; then
        echo "❌ Error al crear sección: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return 1
    fi
    
    echo "$section_gid"
}

# Crear tarea
# Uso: asana_create_task "PROJECT_GID" "Nombre Tarea" "SECTION_GID" POINTS
asana_create_task() {
    local project_gid="$1"
    local task_name="$2"
    local section_gid="${3:-}"
    local points="${4:-3}"
    asana_check_auth || return 1
    
    local payload=$(jq -n \
        --arg name "$task_name" \
        --arg project "$project_gid" \
        --arg points "$points" \
        '{
            data: {
                name: $name,
                projects: [$project],
                notes: ("Story Points: " + $points)
            }
        }')
    
    local response=$(curl -s \
        -X POST \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "https://app.asana.com/api/1.0/tasks")
    
    local task_gid=$(echo "$response" | jq -r '.data.gid')
    
    if [[ "$task_gid" == "null" || -z "$task_gid" ]]; then
        echo "❌ Error al crear tarea: $(echo "$response" | jq -r '.errors[0].message')" >&2
        return 1
    fi
    
    # Si se especificó sección, mover la tarea ahí
    if [[ -n "$section_gid" ]]; then
        curl -s \
            -X POST \
            -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"data\": {\"task\": \"$task_gid\"}}" \
            "https://app.asana.com/api/1.0/sections/$section_gid/addTask" \
            > /dev/null
    fi
    
    echo "$task_gid"
}

# Listar proyectos
asana_list_projects() {
    asana_check_auth || return 1
    
    if [[ -z "${ASANA_WORKSPACE_GID:-}" ]]; then
        echo "❌ Error: ASANA_WORKSPACE_GID no configurado" >&2
        return 1
    fi
    
    curl -s \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        "https://app.asana.com/api/1.0/projects?workspace=$ASANA_WORKSPACE_GID" \
        | jq -r '.data[] | "\(.gid)\t\(.name)"'
}

# Buscar proyecto por nombre
# Uso: asana_find_project "Nombre"
asana_find_project() {
    local project_name="$1"
    asana_list_projects | grep -i "$project_name" | head -1 | cut -f1
}

# Listar secciones de un proyecto
# Uso: asana_list_sections "PROJECT_GID"
asana_list_sections() {
    local project_gid="$1"
    asana_check_auth || return 1
    
    curl -s \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        "https://app.asana.com/api/1.0/projects/$project_gid/sections" \
        | jq -r '.data[] | "\(.gid)\t\(.name)"'
}

# Listar tareas de un proyecto
# Uso: asana_list_tasks "PROJECT_GID"
asana_list_tasks() {
    local project_gid="$1"
    asana_check_auth || return 1
    
    curl -s \
        -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
        "https://app.asana.com/api/1.0/projects/$project_gid/tasks" \
        | jq -r '.data[] | "\(.gid)\t\(.name)"'
}
