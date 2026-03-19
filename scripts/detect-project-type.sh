#!/bin/bash
# detect-project-type.sh
# Analiza las respuestas del cuestionario base y determina qué preguntas condicionales cargar

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHSPEC_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RESPONSES_FILE="${1:-}"

if [[ -z "$RESPONSES_FILE" || ! -f "$RESPONSES_FILE" ]]; then
    echo "❌ Error: Archivo de respuestas no encontrado"
    echo "Uso: $0 <responses.yaml>"
    exit 1
fi

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Analizando tipo de proyecto...${NC}"
echo ""

# ===== EXTRAER RESPUESTAS CLAVE =====
BACKEND=$(grep "^backend_framework:" "$RESPONSES_FILE" | cut -d: -f2 | xargs)
FRONTEND=$(grep "^frontend_framework:" "$RESPONSES_FILE" | cut -d: -f2 | xargs)
NEEDS_AUTH=$(grep "^needs_auth:" "$RESPONSES_FILE" | cut -d: -f2 | xargs)
NEEDS_ADMIN=$(grep "^needs_admin_panel:" "$RESPONSES_FILE" | cut -d: -f2 | xargs)
FILE_UPLOADS=$(grep "^file_uploads:" "$RESPONSES_FILE" | cut -d: -f2 | xargs)
HOSTING=$(grep "^hosting:" "$RESPONSES_FILE" | cut -d: -f2 | xargs)

# Extraer funcionalidades (multilínea)
CORE_FEATURES=$(sed -n '/^core_features:/,/^[a-z_]*:/p' "$RESPONSES_FILE" | sed '1d;$d' | sed 's/^[[:space:]]*-//' | xargs)

# ===== DETECTAR PATRONES =====
DETECTED_TYPES=()

# E-commerce
if echo "$CORE_FEATURES" | grep -qiE "(pago|compra|carrito|stripe|paypal|producto|inventario|pedido)"; then
    DETECTED_TYPES+=("ecommerce")
    echo -e "${GREEN}✓${NC} Detectado: E-commerce"
fi

# SaaS
if echo "$CORE_FEATURES" | grep -qiE "(suscripción|plan|billing|mensualidad|trial|premium)"; then
    DETECTED_TYPES+=("saas")
    echo -e "${GREEN}✓${NC} Detectado: SaaS"
fi

# API
if [[ "$FRONTEND" == "none" ]] || echo "$CORE_FEATURES" | grep -qiE "(api|endpoint|rest|graphql|webhook)"; then
    DETECTED_TYPES+=("api")
    echo -e "${GREEN}✓${NC} Detectado: API/Backend"
fi

# CMS/Blog
if echo "$CORE_FEATURES" | grep -qiE "(blog|post|artículo|contenido|cms|publicar|editor)"; then
    DETECTED_TYPES+=("cms")
    echo -e "${GREEN}✓${NC} Detectado: CMS/Blog"
fi

# Tiempo Real
if echo "$CORE_FEATURES" | grep -qiE "(chat|mensaje|notificación|tiempo real|websocket|live)"; then
    DETECTED_TYPES+=("realtime")
    echo -e "${GREEN}✓${NC} Detectado: Funcionalidad en tiempo real"
fi

# Autenticación compleja
if [[ "$NEEDS_AUTH" != "none" ]]; then
    DETECTED_TYPES+=("auth")
    echo -e "${GREEN}✓${NC} Detectado: Autenticación de usuarios"
fi

# Admin Panel
if [[ "$NEEDS_ADMIN" != "none" ]]; then
    DETECTED_TYPES+=("admin")
    echo -e "${GREEN}✓${NC} Detectado: Panel de administración"
fi

# Storage
if [[ "$FILE_UPLOADS" == "cloud" ]]; then
    DETECTED_TYPES+=("storage")
    echo -e "${GREEN}✓${NC} Detectado: Almacenamiento en la nube"
fi

# AWS
if [[ "$HOSTING" == "aws" ]]; then
    DETECTED_TYPES+=("aws")
    echo -e "${GREEN}✓${NC} Detectado: Despliegue en AWS"
fi

# OAuth
if [[ "$NEEDS_AUTH" == "oauth" ]] || [[ "$NEEDS_AUTH" == "both" ]]; then
    DETECTED_TYPES+=("oauth")
    echo -e "${GREEN}✓${NC} Detectado: OAuth"
fi

# Stack-specific
case "$BACKEND" in
    laravel)
        DETECTED_TYPES+=("php")
        echo -e "${GREEN}✓${NC} Detectado: Stack PHP/Laravel"
        ;;
    nodejs)
        DETECTED_TYPES+=("nodejs")
        echo -e "${GREEN}✓${NC} Detectado: Stack Node.js"
        ;;
    python)
        DETECTED_TYPES+=("python")
        echo -e "${GREEN}✓${NC} Detectado: Stack Python"
        ;;
esac

case "$FRONTEND" in
    react)
        DETECTED_TYPES+=("react")
        echo -e "${GREEN}✓${NC} Detectado: Frontend React"
        ;;
    vue)
        DETECTED_TYPES+=("vue")
        echo -e "${GREEN}✓${NC} Detectado: Frontend Vue.js"
        ;;
esac

# ===== GUARDAR RESULTADO =====
OUTPUT_FILE="${RESPONSES_FILE%.yaml}.types.txt"
printf "%s\n" "${DETECTED_TYPES[@]}" > "$OUTPUT_FILE"

echo ""
echo -e "${BLUE}📋 Tipos detectados guardados en:${NC} $OUTPUT_FILE"
echo ""
echo -e "${YELLOW}Preguntas condicionales que se cargarán:${NC}"
for type in "${DETECTED_TYPES[@]}"; do
    echo "  - questions-${type}.yaml"
done
echo ""

# ===== RETORNAR TIPOS (para captura en scripts) =====
echo "${DETECTED_TYPES[*]}"
