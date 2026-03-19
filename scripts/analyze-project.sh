#!/bin/bash

# Cargar sistema i18n
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../.specleap/i18n.sh"

# analyze-project.sh
# Analiza un proyecto legacy para adopción en SpecLeap
# Uso: bash analyze-project.sh /ruta/al/proyecto

set -e

PROJECT_PATH="$1"
OUTPUT_FILE="/tmp/specleap-analysis.json"

if [ -z "$PROJECT_PATH" ]; then
  echo "$(t "errors.no_path")"
  echo "$(t "errors.usage"): bash analyze-project.sh /ruta/al/proyecto"
  exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
  echo "$(t 'errors.invalid_path'): $PROJECT_PATH"
  exit 1
fi

echo "$(t "analyze.scanning"): $PROJECT_PATH"
echo ""

cd "$PROJECT_PATH" || exit 1

# ==============================================================================
# VARIABLES GLOBALES
# ==============================================================================

PROJECT_NAME=$(basename "$PROJECT_PATH")
DETECTION_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ==============================================================================
# FUNCIÓN: Detectar Stack Backend
# ==============================================================================

detect_backend() {
  local framework="Unknown"
  local version="Unknown"
  local language="Unknown"
  local lang_version="Unknown"

  echo "📦 Detectando stack backend..."

  # Laravel
  if [ -f "composer.json" ]; then
    if grep -q "laravel/framework" composer.json; then
      framework="Laravel"
      version=$(grep '"laravel/framework"' composer.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
      language="PHP"
      
      if command -v php &> /dev/null; then
        lang_version=$(php -v | head -n 1 | awk '{print $2}')
      fi
    fi
  fi

  # Symfony
  if [ -f "composer.json" ]; then
    if grep -q "symfony/framework-bundle" composer.json; then
      framework="Symfony"
      version=$(grep '"symfony/framework-bundle"' composer.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
      language="PHP"
      
      if command -v php &> /dev/null; then
        lang_version=$(php -v | head -n 1 | awk '{print $2}')
      fi
    fi
  fi

  # Node.js/Express
  if [ -f "package.json" ] && [ ! -f "composer.json" ]; then
    if grep -q '"express"' package.json; then
      framework="Express"
      version=$(grep '"express"' package.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
      language="JavaScript"
      
      if command -v node &> /dev/null; then
        lang_version=$(node -v | sed 's/v//')
      fi
    fi
  fi

  # Django
  if [ -f "requirements.txt" ]; then
    if grep -q "Django" requirements.txt; then
      framework="Django"
      version=$(grep "Django" requirements.txt | sed 's/.*==\([0-9.]*\).*/\1/')
      language="Python"
      
      if command -v python3 &> /dev/null; then
        lang_version=$(python3 --version | awk '{print $2}')
      fi
    fi
  fi

  echo "  Framework: $framework $version"
  echo "  Language: $language $lang_version"
  echo ""

  # Guardar en variables globales
  BACKEND_FRAMEWORK="$framework"
  BACKEND_VERSION="$version"
  BACKEND_LANGUAGE="$language"
  BACKEND_LANG_VERSION="$lang_version"
}

# ==============================================================================
# FUNCIÓN: Detectar Stack Frontend
# ==============================================================================

detect_frontend() {
  local framework="Unknown"
  local version="Unknown"
  local build_tool="Unknown"
  local ui_library="Unknown"

  echo "🎨 Detectando stack frontend..."

  if [ -f "package.json" ]; then
    # React
    if grep -q '"react"' package.json; then
      framework="React"
      version=$(grep '"react"' package.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
    fi

    # Vue
    if grep -q '"vue"' package.json; then
      framework="Vue"
      version=$(grep '"vue"' package.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
    fi

    # Angular
    if grep -q '"@angular/core"' package.json; then
      framework="Angular"
      version=$(grep '"@angular/core"' package.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
    fi

    # Svelte
    if grep -q '"svelte"' package.json; then
      framework="Svelte"
      version=$(grep '"svelte"' package.json | sed 's/.*"[^0-9]*\([0-9.]*\)".*/\1/')
    fi

    # Build tools
    if grep -q '"vite"' package.json; then
      build_tool="Vite"
    elif grep -q '"webpack"' package.json; then
      build_tool="Webpack"
    elif grep -q '"parcel"' package.json; then
      build_tool="Parcel"
    fi

    # UI Libraries
    if grep -q '"tailwindcss"' package.json; then
      ui_library="Tailwind CSS"
    elif grep -q '"@mui/material"' package.json; then
      ui_library="Material-UI"
    elif grep -q '"bootstrap"' package.json; then
      ui_library="Bootstrap"
    fi
  fi

  echo "  Framework: $framework $version"
  echo "  Build Tool: $build_tool"
  echo "  UI Library: $ui_library"
  echo ""

  FRONTEND_FRAMEWORK="$framework"
  FRONTEND_VERSION="$version"
  FRONTEND_BUILD_TOOL="$build_tool"
  FRONTEND_UI_LIBRARY="$ui_library"
}

# ==============================================================================
# FUNCIÓN: Detectar Base de Datos
# ==============================================================================

detect_database() {
  local db_type="Unknown"
  local db_version="Unknown"
  local tables_count=0

  echo "🗄️  Detectando base de datos..."

  # Laravel migrations
  if [ -d "database/migrations" ]; then
    tables_count=$(grep -r "Schema::create" database/migrations/ 2>/dev/null | wc -l | tr -d ' ')
    
    # Detectar tipo por driver en .env.example o config
    if [ -f ".env.example" ]; then
      if grep -q "DB_CONNECTION=mysql" .env.example; then
        db_type="MySQL"
      elif grep -q "DB_CONNECTION=pgsql" .env.example; then
        db_type="PostgreSQL"
      elif grep -q "DB_CONNECTION=sqlite" .env.example; then
        db_type="SQLite"
      fi
    fi
  fi

  # Django migrations
  if [ -d "migrations" ] || find . -type d -name "migrations" -not -path "./node_modules/*" | grep -q .; then
    tables_count=$(find . -type f -name "*.py" -path "*/migrations/*" -not -path "./node_modules/*" | wc -l | tr -d ' ')
    db_type="PostgreSQL"  # Asumido para Django
  fi

  echo "  Type: $db_type"
  echo "  Tables: $tables_count"
  echo ""

  DATABASE_TYPE="$db_type"
  DATABASE_VERSION="$db_version"
  DATABASE_TABLES_COUNT="$tables_count"
}

# ==============================================================================
# FUNCIÓN: Detectar Servicios Externos
# ==============================================================================

detect_services() {
  echo "🌐 Detectando servicios externos..."

  local services=()

  # Buscar en archivos de configuración y código
  if grep -rq "stripe" . --include="*.php" --include="*.js" --include="*.env*" 2>/dev/null; then
    services+=("Stripe")
  fi

  if grep -rq "sendgrid" . --include="*.php" --include="*.js" --include="*.env*" 2>/dev/null; then
    services+=("SendGrid")
  fi

  if grep -rq "mailgun" . --include="*.php" --include="*.js" --include="*.env*" 2>/dev/null; then
    services+=("Mailgun")
  fi

  if grep -rq "aws" . --include="*.php" --include="*.js" --include="*.env*" 2>/dev/null; then
    services+=("AWS S3")
  fi

  if grep -rq "firebase" . --include="*.php" --include="*.js" --include="*.json" 2>/dev/null; then
    services+=("Firebase")
  fi

  if grep -rq "pusher" . --include="*.php" --include="*.js" --include="*.env*" 2>/dev/null; then
    services+=("Pusher")
  fi

  if [ ${#services[@]} -gt 0 ]; then
    SERVICES=$(printf '"%s",' "${services[@]}" | sed 's/,$//')
    echo "  Services: ${services[*]}"
  else
    SERVICES=""
    echo "  Services: None detected"
  fi

  echo ""
}

# ==============================================================================
# FUNCIÓN: Analizar Estructura del Proyecto
# ==============================================================================

analyze_structure() {
  echo "📂 Analizando estructura..."

  local total_files=0
  local php_files=0
  local js_files=0
  local blade_files=0
  local controllers=0
  local models=0
  local migrations=0
  local components=0

  total_files=$(find . -type f -not -path "./node_modules/*" -not -path "./vendor/*" -not -path "./.git/*" | wc -l | tr -d ' ')
  
  php_files=$(find . -type f -name "*.php" -not -path "./vendor/*" | wc -l | tr -d ' ')
  js_files=$(find . -type f \( -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -not -path "./node_modules/*" | wc -l | tr -d ' ')
  blade_files=$(find . -type f -name "*.blade.php" 2>/dev/null | wc -l | tr -d ' ')

  # Laravel específico
  if [ -d "app/Http/Controllers" ]; then
    controllers=$(find app/Http/Controllers -type f -name "*Controller.php" 2>/dev/null | wc -l | tr -d ' ')
  fi

  if [ -d "app/Models" ]; then
    models=$(find app/Models -type f -name "*.php" 2>/dev/null | wc -l | tr -d ' ')
  fi

  if [ -d "database/migrations" ]; then
    migrations=$(find database/migrations -type f -name "*.php" 2>/dev/null | wc -l | tr -d ' ')
  fi

  # React/Vue components
  if [ -d "resources/js/components" ]; then
    components=$(find resources/js/components -type f \( -name "*.jsx" -o -name "*.tsx" -o -name "*.vue" \) 2>/dev/null | wc -l | tr -d ' ')
  elif [ -d "src/components" ]; then
    components=$(find src/components -type f \( -name "*.jsx" -o -name "*.tsx" -o -name "*.vue" \) 2>/dev/null | wc -l | tr -d ' ')
  fi

  # Contar líneas de código (si cloc está instalado)
  local total_lines=0
  if command -v cloc &> /dev/null; then
    total_lines=$(cloc . --json --quiet 2>/dev/null | grep -o '"code":[0-9]*' | head -1 | grep -o '[0-9]*')
  else
    # Estimación simple
    total_lines=$(find . -type f \( -name "*.php" -o -name "*.js" -o -name "*.jsx" -o -name "*.ts" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./vendor/*" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
  fi

  echo "  Total files: $total_files"
  echo "  PHP files: $php_files"
  echo "  JS files: $js_files"
  echo "  Total lines: $total_lines"
  echo "  Controllers: $controllers"
  echo "  Models: $models"
  echo "  Migrations: $migrations"
  echo "  Components: $components"
  echo ""

  STRUCTURE_TOTAL_FILES="$total_files"
  STRUCTURE_PHP_FILES="$php_files"
  STRUCTURE_JS_FILES="$js_files"
  STRUCTURE_BLADE_FILES="$blade_files"
  STRUCTURE_TOTAL_LINES="$total_lines"
  STRUCTURE_CONTROLLERS="$controllers"
  STRUCTURE_MODELS="$models"
  STRUCTURE_MIGRATIONS="$migrations"
  STRUCTURE_COMPONENTS="$components"
}

# ==============================================================================
# FUNCIÓN: Análisis Estático de Calidad (PHPStan)
# ==============================================================================

analyze_quality_phpstan() {
  echo "🔍 Análisis estático PHP (PHPStan)..."

  local phpstan_errors=0
  local phpstan_warnings=0

  if [ "$BACKEND_LANGUAGE" = "PHP" ]; then
    # Verificar si PHPStan está instalado
    if [ -f "vendor/bin/phpstan" ] || command -v phpstan &> /dev/null; then
      echo "  Ejecutando PHPStan nivel 8..."
      
      # Ejecutar PHPStan
      if vendor/bin/phpstan analyse --level=8 --error-format=json --no-progress > /tmp/phpstan-report.json 2>/dev/null; then
        phpstan_errors=0
      else
        # Contar errores del JSON
        phpstan_errors=$(grep -o '"message"' /tmp/phpstan-report.json 2>/dev/null | wc -l | tr -d ' ')
      fi

      echo "  Errors: $phpstan_errors"
    else
      echo "  ⚠️  PHPStan no instalado (recomendado instalarlo)"
      phpstan_errors=-1
    fi
  else
    echo "  Skipped (no es proyecto PHP)"
  fi

  echo ""

  QUALITY_PHPSTAN_ERRORS="$phpstan_errors"
  QUALITY_PHPSTAN_WARNINGS="$phpstan_warnings"
}

# ==============================================================================
# FUNCIÓN: Análisis Estático de Calidad (ESLint)
# ==============================================================================

analyze_quality_eslint() {
  echo "🔍 Análisis estático JavaScript (ESLint)..."

  local eslint_errors=0
  local eslint_warnings=0

  if [ "$FRONTEND_FRAMEWORK" != "Unknown" ]; then
    # Verificar si ESLint está instalado
    if [ -f "node_modules/.bin/eslint" ] || command -v eslint &> /dev/null; then
      echo "  Ejecutando ESLint..."
      
      # Ejecutar ESLint
      if npx eslint . --format=json > /tmp/eslint-report.json 2>/dev/null; then
        eslint_errors=0
        eslint_warnings=0
      else
        # Contar errores y warnings
        eslint_errors=$(grep -o '"severity":2' /tmp/eslint-report.json 2>/dev/null | wc -l | tr -d ' ')
        eslint_warnings=$(grep -o '"severity":1' /tmp/eslint-report.json 2>/dev/null | wc -l | tr -d ' ')
      fi

      echo "  Errors: $eslint_errors"
      echo "  Warnings: $eslint_warnings"
    else
      echo "  ⚠️  ESLint no instalado (recomendado instalarlo)"
      eslint_errors=-1
      eslint_warnings=-1
    fi
  else
    echo "  Skipped (no es proyecto frontend)"
  fi

  echo ""

  QUALITY_ESLINT_ERRORS="$eslint_errors"
  QUALITY_ESLINT_WARNINGS="$eslint_warnings"
}

# ==============================================================================
# FUNCIÓN: Analizar Cobertura de Tests
# ==============================================================================

analyze_test_coverage() {
  echo "🧪 Analizando cobertura de tests..."

  local php_coverage="0%"
  local js_coverage="0%"

  # PHP (PHPUnit)
  if [ -f "phpunit.xml" ] && [ -f "vendor/bin/phpunit" ]; then
    echo "  Ejecutando PHPUnit con cobertura..."
    
    # Ejecutar tests con cobertura (si Xdebug está disponible)
    if php -m | grep -q xdebug; then
      coverage_output=$(vendor/bin/phpunit --coverage-text --colors=never 2>/dev/null | grep "Lines:" | awk '{print $2}')
      if [ -n "$coverage_output" ]; then
        php_coverage="$coverage_output"
      fi
    else
      echo "  ⚠️  Xdebug no disponible, no se puede medir cobertura"
    fi

    echo "  PHP Coverage: $php_coverage"
  else
    echo "  ⚠️  PHPUnit no configurado"
  fi

  # JavaScript (Jest)
  if [ -f "jest.config.js" ] || [ -f "jest.config.json" ]; then
    echo "  Ejecutando Jest con cobertura..."
    
    coverage_output=$(npm test -- --coverage --silent 2>/dev/null | grep "All files" | awk '{print $10}')
    if [ -n "$coverage_output" ]; then
      js_coverage="$coverage_output"
    fi

    echo "  JS Coverage: $js_coverage"
  else
    echo "  ⚠️  Jest no configurado"
  fi

  echo ""

  TEST_COVERAGE_PHP="$php_coverage"
  TEST_COVERAGE_JS="$js_coverage"
}

# ==============================================================================
# FUNCIÓN: Detectar Dependencias Obsoletas
# ==============================================================================

detect_outdated_dependencies() {
  echo "📦 Detectando dependencias obsoletas..."

  local composer_outdated=0
  local npm_outdated=0

  # Composer
  if [ -f "composer.json" ] && command -v composer &> /dev/null; then
    echo "  Verificando composer..."
    composer_outdated=$(composer outdated --direct 2>/dev/null | grep -c "^" || echo "0")
    echo "  Composer outdated: $composer_outdated packages"
  fi

  # npm
  if [ -f "package.json" ] && command -v npm &> /dev/null; then
    echo "  Verificando npm..."
    npm_outdated=$(npm outdated 2>/dev/null | grep -c "^" || echo "0")
    echo "  npm outdated: $npm_outdated packages"
  fi

  echo ""

  OUTDATED_COMPOSER="$composer_outdated"
  OUTDATED_NPM="$npm_outdated"
}

# ==============================================================================
# FUNCIÓN: Detectar Deuda Técnica
# ==============================================================================

detect_technical_debt() {
  echo "⚠️  Detectando deuda técnica..."

  # Array para almacenar issues
  TECH_DEBT_ISSUES=()

  # TD-001: Tests insuficientes
  php_cov_num=$(echo "$TEST_COVERAGE_PHP" | sed 's/%//')
  js_cov_num=$(echo "$TEST_COVERAGE_JS" | sed 's/%//')
  
  if [ "$php_cov_num" != "0" ] && [ "$php_cov_num" -lt 90 ] 2>/dev/null; then
    echo "  🔴 TD-001: Cobertura de tests insuficiente (PHP: $TEST_COVERAGE_PHP, JS: $TEST_COVERAGE_JS)"
    TECH_DEBT_ISSUES+=("TD-001")
  fi

  # TD-002: Errores PHPStan
  if [ "$QUALITY_PHPSTAN_ERRORS" -gt 0 ] 2>/dev/null; then
    echo "  🟡 TD-002: Errores PHPStan detectados ($QUALITY_PHPSTAN_ERRORS errores)"
    TECH_DEBT_ISSUES+=("TD-002")
  fi

  # TD-003: N+1 queries (buscar patrones)
  if grep -rq "foreach.*->get()" app/Http/Controllers/ 2>/dev/null; then
    echo "  🔴 TD-003: Posibles N+1 queries detectadas"
    TECH_DEBT_ISSUES+=("TD-003")
  fi

  # TD-004: Código duplicado
  # (Requeriría phpcpd o similar - placeholder)
  echo "  🟡 TD-004: Verificar código duplicado (requiere análisis manual)"
  TECH_DEBT_ISSUES+=("TD-004")

  # TD-005: Rate limiting
  if [ -f "routes/api.php" ]; then
    if ! grep -q "throttle" routes/api.php 2>/dev/null; then
      echo "  🔴 TD-005: API sin rate limiting"
      TECH_DEBT_ISSUES+=("TD-005")
    fi
  fi

  # TD-006: Dependencias obsoletas
  if [ "$OUTDATED_COMPOSER" -gt 0 ] || [ "$OUTDATED_NPM" -gt 0 ]; then
    echo "  🟡 TD-006: Dependencias obsoletas ($OUTDATED_COMPOSER composer, $OUTDATED_NPM npm)"
    TECH_DEBT_ISSUES+=("TD-006")
  fi

  # TD-007: Complejidad ciclomática
  # (Requeriría phpmetrics o similar - placeholder)
  echo "  🟢 TD-007: Verificar complejidad ciclomática (requiere análisis manual)"
  TECH_DEBT_ISSUES+=("TD-007")

  # TD-008: Documentación API
  if [ -f "routes/api.php" ] && [ ! -f "storage/api-docs/api-docs.json" ]; then
    echo "  🟡 TD-008: API sin documentación OpenAPI"
    TECH_DEBT_ISSUES+=("TD-008")
  fi

  echo "  Total issues: ${#TECH_DEBT_ISSUES[@]}"
  echo ""
}

# ==============================================================================
# FUNCIÓN: Detectar Monorepo
# ==============================================================================

detect_monorepo() {
  echo "📦 Detectando monorepo..."

  local is_monorepo=false
  local packages=()

  if [ -d "packages" ]; then
    package_count=$(find packages -maxdepth 1 -type d | tail -n +2 | wc -l | tr -d ' ')
    
    if [ "$package_count" -gt 0 ]; then
      is_monorepo=true
      echo "  ✅ Monorepo detectado ($package_count packages)"
      
      # Listar packages
      while IFS= read -r pkg; do
        pkg_name=$(basename "$pkg")
        packages+=("$pkg_name")
      done < <(find packages -maxdepth 1 -type d | tail -n +2)
    fi
  fi

  if [ "$is_monorepo" = false ]; then
    echo "  No es monorepo"
  fi

  echo ""

  MONOREPO="$is_monorepo"
  MONOREPO_PACKAGES=$(printf '"%s",' "${packages[@]}" | sed 's/,$//')
}

# ==============================================================================
# FUNCIÓN: Generar JSON de Salida
# ==============================================================================

generate_json_output() {
  echo "📄 Generando reporte JSON..."

  # Escapar comillas en strings
  PROJECT_PATH_ESC=$(echo "$PROJECT_PATH" | sed 's/"/\\"/g')

  cat > "$OUTPUT_FILE" <<EOF
{
  "project_name": "$PROJECT_NAME",
  "project_path": "$PROJECT_PATH_ESC",
  "detection_date": "$DETECTION_DATE",
  
  "stack": {
    "backend": {
      "framework": "$BACKEND_FRAMEWORK",
      "version": "$BACKEND_VERSION",
      "language": "$BACKEND_LANGUAGE",
      "language_version": "$BACKEND_LANG_VERSION"
    },
    "frontend": {
      "framework": "$FRONTEND_FRAMEWORK",
      "version": "$FRONTEND_VERSION",
      "build_tool": "$FRONTEND_BUILD_TOOL",
      "ui_library": "$FRONTEND_UI_LIBRARY"
    },
    "database": {
      "type": "$DATABASE_TYPE",
      "version": "$DATABASE_VERSION",
      "tables_count": $DATABASE_TABLES_COUNT
    },
    "services": [$SERVICES]
  },
  
  "structure": {
    "total_files": $STRUCTURE_TOTAL_FILES,
    "php_files": $STRUCTURE_PHP_FILES,
    "js_files": $STRUCTURE_JS_FILES,
    "blade_files": $STRUCTURE_BLADE_FILES,
    "total_lines": $STRUCTURE_TOTAL_LINES,
    "controllers": $STRUCTURE_CONTROLLERS,
    "models": $STRUCTURE_MODELS,
    "migrations": $STRUCTURE_MIGRATIONS,
    "components": $STRUCTURE_COMPONENTS
  },
  
  "quality": {
    "phpstan": {
      "errors": $QUALITY_PHPSTAN_ERRORS,
      "warnings": $QUALITY_PHPSTAN_WARNINGS
    },
    "eslint": {
      "errors": $QUALITY_ESLINT_ERRORS,
      "warnings": $QUALITY_ESLINT_WARNINGS
    },
    "test_coverage": {
      "php": "$TEST_COVERAGE_PHP",
      "js": "$TEST_COVERAGE_JS"
    },
    "outdated_dependencies": {
      "composer": $OUTDATED_COMPOSER,
      "npm": $OUTDATED_NPM
    }
  },
  
  "technical_debt": [
$(generate_tech_debt_json)
  ],
  
  "monorepo": $MONOREPO,
  "packages": [$MONOREPO_PACKAGES]
}
EOF

  echo "  ✅ Reporte guardado en: $OUTPUT_FILE"
  echo ""
}

# ==============================================================================
# FUNCIÓN: Generar JSON de Deuda Técnica
# ==============================================================================

generate_tech_debt_json() {
  local json_items=()

  # TD-001: Tests
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-001 " ]]; then
    json_items+=('    {
      "id": "TD-001",
      "type": "tests",
      "severity": "high",
      "title": "Insufficient test coverage",
      "description": "PHP coverage: '"$TEST_COVERAGE_PHP"', JS coverage: '"$TEST_COVERAGE_JS"'. Target: 90%+",
      "affected_files": ["all"],
      "estimated_effort_hours": 40
    }')
  fi

  # TD-002: PHPStan
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-002 " ]]; then
    json_items+=('    {
      "id": "TD-002",
      "type": "code_quality",
      "severity": "medium",
      "title": "PHPStan errors and warnings",
      "description": "'"$QUALITY_PHPSTAN_ERRORS"' errors at level 8",
      "affected_files": [],
      "estimated_effort_hours": 8
    }')
  fi

  # TD-003: N+1
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-003 " ]]; then
    json_items+=('    {
      "id": "TD-003",
      "type": "performance",
      "severity": "high",
      "title": "N+1 query problems",
      "description": "Detected potential N+1 queries in controllers",
      "affected_files": [],
      "estimated_effort_hours": 6
    }')
  fi

  # TD-004: Code duplication
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-004 " ]]; then
    json_items+=('    {
      "id": "TD-004",
      "type": "code_duplication",
      "severity": "medium",
      "title": "Duplicated code",
      "description": "Requires manual analysis with phpcpd",
      "affected_files": [],
      "estimated_effort_hours": 4
    }')
  fi

  # TD-005: Rate limiting
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-005 " ]]; then
    json_items+=('    {
      "id": "TD-005",
      "type": "security",
      "severity": "high",
      "title": "Missing rate limiting",
      "description": "API endpoints lack rate limiting configuration",
      "affected_files": ["routes/api.php"],
      "estimated_effort_hours": 3
    }')
  fi

  # TD-006: Outdated deps
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-006 " ]]; then
    json_items+=('    {
      "id": "TD-006",
      "type": "dependencies",
      "severity": "medium",
      "title": "Outdated dependencies",
      "description": "'"$OUTDATED_COMPOSER"' composer packages and '"$OUTDATED_NPM"' npm packages outdated",
      "affected_files": ["composer.json", "package.json"],
      "estimated_effort_hours": 5
    }')
  fi

  # TD-007: Complexity
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-007 " ]]; then
    json_items+=('    {
      "id": "TD-007",
      "type": "code_complexity",
      "severity": "low",
      "title": "High cyclomatic complexity",
      "description": "Requires analysis with phpmetrics",
      "affected_files": [],
      "estimated_effort_hours": 3
    }')
  fi

  # TD-008: API docs
  if [[ " ${TECH_DEBT_ISSUES[@]} " =~ " TD-008 " ]]; then
    json_items+=('    {
      "id": "TD-008",
      "type": "documentation",
      "severity": "medium",
      "title": "Missing API documentation",
      "description": "No OpenAPI/Swagger specs for API endpoints",
      "affected_files": ["routes/api.php"],
      "estimated_effort_hours": 8
    }')
  fi

  # Join con comas
  printf '%s' "$(IFS=,; echo "${json_items[*]}")"
}

# ==============================================================================
# EJECUCIÓN PRINCIPAL
# ==============================================================================

main() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  SpecLeap — Análisis de Proyecto Legacy"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  detect_backend
  detect_frontend
  detect_database
  detect_services
  analyze_structure
  analyze_quality_phpstan
  analyze_quality_eslint
  analyze_test_coverage
  detect_outdated_dependencies
  detect_technical_debt
  detect_monorepo
  generate_json_output

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ✅ Análisis completado"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📄 Reporte JSON: $OUTPUT_FILE"
  echo ""
}

main
