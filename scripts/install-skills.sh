#!/bin/bash

# SpecLeap — Instalación de Agent Skills desde GitHub
# Las skills se clonan y copian a ~/.skills/ para uso en VSCode/Claude Code

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════╗"
echo "║    SpecLeap — Agent Skills Installer      ║"
echo "╔════════════════════════════════════════════╗"
echo -e "${NC}"
echo ""

# Directorio de destino
SKILLS_DIR="${HOME}/.skills"

echo -e "${BLUE}📁 Directorio de skills: ${SKILLS_DIR}${NC}"
echo ""

# Crear directorio si no existe
mkdir -p "${SKILLS_DIR}"

# Función para clonar e instalar una skill desde GitHub
install_skill() {
    local repo=$1
    local skill_name=$2
    local skill_path=$3
    
    echo -ne "  📦 ${skill_name}... "
    
    # Clonar repo temporal
    TMP_DIR=$(mktemp -d)
    
    if git clone "https://github.com/${repo}.git" "${TMP_DIR}" &>/dev/null; then
        # Copiar la skill específica
        if [ -f "${TMP_DIR}/${skill_path}/SKILL.md" ]; then
            cp -r "${TMP_DIR}/${skill_path}" "${SKILLS_DIR}/${skill_name}"
            echo -e "${GREEN}✅${NC}"
            rm -rf "${TMP_DIR}"
            return 0
        else
            echo -e "${RED}❌ (SKILL.md no encontrado)${NC}"
            rm -rf "${TMP_DIR}"
            return 1
        fi
    else
        echo -e "${RED}❌ (repo no accesible)${NC}"
        rm -rf "${TMP_DIR}"
        return 1
    fi
}

# Lista de skills a instalar
# Format: "repo" "skill-name" "path-in-repo"

echo -e "${BLUE}🔐 Seguridad (5 skills)${NC}"
# Nota: La mayoría de estas no existen como repos públicos
# Omitiendo por ahora

echo -e "${BLUE}🔄 Consistencia & Calidad (3 skills)${NC}"
install_skill "obra/superpowers" "verification-before-completion" "verification-before-completion"
install_skill "obra/superpowers" "systematic-debugging" "systematic-debugging"
# code-review-excellence - investigar repo

echo -e "${BLUE}🎨 Diseño & Frontend (6 skills)${NC}"
# web-design-guidelines - investigar repo
# ui-ux-pro-max - investigar repo
# tailwind-design-system - investigar repo
# shadcn-ui - investigar repo
# responsive-design - investigar repo
# accessibility-compliance - investigar repo

echo -e "${BLUE}🛠️ Backend & Development (6 skills)${NC}"
# laravel - investigar repo
# react-best-practices - investigar repo
# test-driven-development - investigar repo
# api-design-principles - investigar repo
# postgresql-best-practices - investigar repo
# error-handling-patterns - investigar repo

echo ""
echo -e "${GREEN}✅ Instalación completada${NC}"
echo ""
echo -e "${BLUE}📋 Skills instaladas en: ${SKILLS_DIR}${NC}"
echo ""
echo "Las skills estarán disponibles en:"
echo "  - VSCode (con extensión Claude)"
echo "  - Claude Code"
echo "  - Cursor"
echo "  - Cualquier editor compatible con Agent Skills"
echo ""
