#!/bin/bash
# SpecLeap Installer
# Language selection + initial setup

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Detect terminal width
COLS=$(tput cols 2>/dev/null || echo 80)
LINE=$(printf '%*s\n' "$COLS" '' | tr ' ' '=')

# Clear screen and show banner (only if TTY)
if [ -t 0 ]; then
    clear
fi
echo -e "${CYAN}${LINE}${NC}"
echo -e "${CYAN}"
cat << "EOF"
   _____ ____  ___________    __    _________    ____ 
  / ___// __ \/ ____/ ____/   / /   / ____/   |  / __ \
  \__ \/ /_/ / __/ / /       / /   / __/ / /| | / /_/ /
 ___/ / ____/ /___/ /___    / /___/ /___/ ___ |/ ____/ 
/____/_/   /_____/\____/   /_____/_____/_/  |_/_/      
                                                        
EOF
echo -e "${NC}${CYAN}${LINE}${NC}"
echo ""
echo -e "${GREEN}  Spec-Driven Development Framework${NC}"
echo -e "${YELLOW}  v1.0.0${NC}"
echo ""
echo -e "${CYAN}${LINE}${NC}"
echo ""

# Language selection
echo -e "${BLUE}Please select your language / Por favor selecciona tu idioma:${NC}"
echo ""
echo "  1) English"
echo "  2) Español"
echo ""
read -p "$(echo -e ${YELLOW}Choose an option [1-2]:${NC} )" lang_choice

# Set language
case $lang_choice in
    1)
        SPECLEAP_LANG="en"
        WELCOME_MSG="Welcome to SpecLeap!"
        SETUP_MSG="Starting installation..."
        CREATING_CONFIG="Creating configuration file..."
        INSTALLING_DEPS="Installing dependencies..."
        SETUP_COMPLETE="✅ Installation complete!"
        NEXT_STEPS="Next steps:"
        STEP_1="1. Read SETUP.md for detailed configuration"
        STEP_2="2. Run: npm install (if using landing/web components)"
        STEP_3="3. Configure your project in proyectos/"
        STEP_4="4. Run: ./scripts/generate-contrato.sh to start"
        ENJOY="Enjoy SpecLeap!"
        ;;
    2)
        SPECLEAP_LANG="es"
        WELCOME_MSG="¡Bienvenido a SpecLeap!"
        SETUP_MSG="Iniciando instalación..."
        CREATING_CONFIG="Creando archivo de configuración..."
        INSTALLING_DEPS="Instalando dependencias..."
        SETUP_COMPLETE="✅ Instalación completa!"
        NEXT_STEPS="Próximos pasos:"
        STEP_1="1. Lee SETUP.md para configuración detallada"
        STEP_2="2. Ejecuta: npm install (si usas landing/componentes web)"
        STEP_3="3. Configura tu proyecto en proyectos/"
        STEP_4="4. Ejecuta: ./scripts/generate-contrato.sh para empezar"
        ENJOY="¡Disfruta SpecLeap!"
        ;;
    *)
        echo -e "${RED}Invalid option. Defaulting to English.${NC}"
        SPECLEAP_LANG="en"
        WELCOME_MSG="Welcome to SpecLeap!"
        SETUP_MSG="Starting installation..."
        CREATING_CONFIG="Creating configuration file..."
        INSTALLING_DEPS="Installing dependencies..."
        SETUP_COMPLETE="✅ Installation complete!"
        NEXT_STEPS="Next steps:"
        STEP_1="1. Read SETUP.md for detailed configuration"
        STEP_2="2. Run: npm install (if using landing/web components)"
        STEP_3="3. Configure your project in proyectos/"
        STEP_4="4. Run: ./scripts/generate-contrato.sh to start"
        ENJOY="Enjoy SpecLeap!"
        ;;
esac

echo ""
echo -e "${GREEN}${WELCOME_MSG}${NC}"
echo -e "${YELLOW}${SETUP_MSG}${NC}"
echo ""

# Create config directory
mkdir -p .specleap

# Create proyectos directory (for user projects - NOT tracked in git)
mkdir -p proyectos

# Create config file
echo -e "${CYAN}${CREATING_CONFIG}${NC}"
cat > .specleap/config.json <<EOF
{
  "version": "1.0.0",
  "language": "${SPECLEAP_LANG}",
  "installed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "project_name": "",
  "jira_enabled": false,
  "asana_enabled": false
}
EOF

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    cat > .env <<EOF
# SpecLeap Configuration
SPECLEAP_LANG=${SPECLEAP_LANG}
SPECLEAP_PROJECT_NAME=""

# Asana (optional)
ASANA_ACCESS_TOKEN=""
ASANA_WORKSPACE_ID=""

# Jira (optional)
JIRA_HOST=""
JIRA_EMAIL=""
JIRA_API_TOKEN=""
EOF
fi

# Make scripts executable
chmod +x scripts/*.sh 2>/dev/null || true

echo ""
echo -e "${GREEN}${SETUP_COMPLETE}${NC}"
echo ""
echo -e "${CYAN}${LINE}${NC}"
echo ""
echo -e "${YELLOW}${NEXT_STEPS}${NC}"
echo ""
echo -e "  ${STEP_1}"
echo -e "  ${STEP_2}"
echo -e "  ${STEP_3}"
echo -e "  ${STEP_4}"
echo ""
echo -e "${CYAN}${LINE}${NC}"
echo ""
echo -e "${GREEN}${ENJOY}${NC}"
echo ""
