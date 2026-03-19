#!/bin/bash

# estimate-effort.sh
# Estima el esfuerzo requerido para resolver issues de deuda técnica
# Uso: bash estimate-effort.sh /tmp/specleap-analysis.json

set -e

ANALYSIS_FILE="$1"

if [ -z "$ANALYSIS_FILE" ]; then
  echo "Error: Debes proporcionar el archivo de análisis JSON"
  echo "Uso: bash estimate-effort.sh /tmp/specleap-analysis.json"
  exit 1
fi

if [ ! -f "$ANALYSIS_FILE" ]; then
  echo "Error: Archivo '$ANALYSIS_FILE' no encontrado"
  exit 1
fi

echo "📊 Estimando esfuerzo de deuda técnica..."
echo ""

# Extraer métricas clave del JSON
php_files=$(grep '"php_files"' "$ANALYSIS_FILE" | grep -o '[0-9]*')
js_files=$(grep '"js_files"' "$ANALYSIS_FILE" | grep -o '[0-9]*')
total_lines=$(grep '"total_lines"' "$ANALYSIS_FILE" | grep -o '[0-9]*')
controllers=$(grep '"controllers"' "$ANALYSIS_FILE" | grep -o '[0-9]*')
models=$(grep '"models"' "$ANALYSIS_FILE" | grep -o '[0-9]*')
components=$(grep '"components"' "$ANALYSIS_FILE" | grep -o '[0-9]*')

php_coverage=$(grep '"php":' "$ANALYSIS_FILE" | grep -o '[0-9]*%' | head -1 | sed 's/%//')
js_coverage=$(grep '"js":' "$ANALYSIS_FILE" | grep -o '[0-9]*%' | head -1 | sed 's/%//')

phpstan_errors=$(grep -A 2 '"phpstan":' "$ANALYSIS_FILE" | grep '"errors"' | grep -o '[0-9]*')
eslint_errors=$(grep -A 2 '"eslint":' "$ANALYSIS_FILE" | grep '"errors"' | grep -o '[0-9]*')

# Valores por defecto si no se encontraron
php_files=${php_files:-0}
js_files=${js_files:-0}
total_lines=${total_lines:-0}
controllers=${controllers:-0}
models=${models:-0}
components=${components:-0}
php_coverage=${php_coverage:-0}
js_coverage=${js_coverage:-0}
phpstan_errors=${phpstan_errors:-0}
eslint_errors=${eslint_errors:-0}

# ==============================================================================
# ESTIMACIÓN POR TIPO DE ISSUE
# ==============================================================================

# TD-001: Tests (cobertura insuficiente)
estimate_tests() {
  local effort=0
  
  # PHP tests
  if [ "$php_coverage" -lt 90 ] && [ "$php_files" -gt 0 ]; then
    local missing_coverage=$((90 - php_coverage))
    local files_to_test=$((php_files * missing_coverage / 100))
    
    # Estimación: 30 min por archivo simple, 1h por controller, 2h por servicio
    local controller_effort=$((controllers * 60))  # 1h por controller
    local model_effort=$((models * 30))  # 30 min por model
    local other_effort=$(((files_to_test - controllers - models) * 30))  # 30 min otros
    
    effort=$((controller_effort + model_effort + other_effort))
  fi
  
  # JS tests
  if [ "$js_coverage" -lt 90 ] && [ "$js_files" -gt 0 ]; then
    local missing_coverage=$((90 - js_coverage))
    local files_to_test=$((js_files * missing_coverage / 100))
    
    # Estimación: 45 min por componente, 30 min por utility
    local component_effort=$((components * 45))  # 45 min por componente
    local other_effort=$(((files_to_test - components) * 30))  # 30 min otros
    
    effort=$((effort + component_effort + other_effort))
  fi
  
  # Convertir minutos a horas (redondear hacia arriba)
  effort=$(((effort + 59) / 60))
  
  # Mínimo 8 horas, máximo 80 horas
  if [ "$effort" -lt 8 ]; then
    effort=8
  elif [ "$effort" -gt 80 ]; then
    effort=80
  fi
  
  echo "$effort"
}

# TD-002: PHPStan errors
estimate_phpstan() {
  local effort=0
  
  if [ "$phpstan_errors" -gt 0 ]; then
    # Estimación: 10 min por error simple, 30 min por error complejo
    # Asumimos 70% simples, 30% complejos
    local simple_errors=$((phpstan_errors * 70 / 100))
    local complex_errors=$((phpstan_errors * 30 / 100))
    
    effort=$(((simple_errors * 10 + complex_errors * 30 + 59) / 60))
    
    # Mínimo 2 horas, máximo 40 horas
    if [ "$effort" -lt 2 ]; then
      effort=2
    elif [ "$effort" -gt 40 ]; then
      effort=40
    fi
  fi
  
  echo "$effort"
}

# TD-003: N+1 queries
estimate_n_plus_one() {
  local effort=0
  
  # Estimación basada en número de controllers
  # Asumimos que ~30% de controllers tienen N+1
  local affected_controllers=$((controllers * 30 / 100))
  
  if [ "$affected_controllers" -gt 0 ]; then
    # Estimación: 1-2 horas por controller
    effort=$((affected_controllers * 90 / 60))  # 1.5h promedio
    
    # Mínimo 3 horas, máximo 20 horas
    if [ "$effort" -lt 3 ]; then
      effort=3
    elif [ "$effort" -gt 20 ]; then
      effort=20
    fi
  fi
  
  echo "$effort"
}

# TD-004: Código duplicado
estimate_duplication() {
  local effort=0
  
  # Estimación basada en tamaño del proyecto
  if [ "$total_lines" -gt 50000 ]; then
    effort=12
  elif [ "$total_lines" -gt 20000 ]; then
    effort=8
  elif [ "$total_lines" -gt 10000 ]; then
    effort=4
  else
    effort=2
  fi
  
  echo "$effort"
}

# TD-005: Rate limiting
estimate_rate_limiting() {
  # Esfuerzo fijo: configuración middleware + testing
  echo "3"
}

# TD-006: Dependencias obsoletas
estimate_outdated_deps() {
  local composer_outdated=$(grep -A 2 '"outdated_dependencies":' "$ANALYSIS_FILE" | grep '"composer"' | grep -o '[0-9]*')
  local npm_outdated=$(grep -A 2 '"outdated_dependencies":' "$ANALYSIS_FILE" | grep '"npm"' | grep -o '[0-9]*')
  
  composer_outdated=${composer_outdated:-0}
  npm_outdated=${npm_outdated:-0}
  
  local total_outdated=$((composer_outdated + npm_outdated))
  local effort=0
  
  if [ "$total_outdated" -gt 0 ]; then
    # Estimación: 20 min por paquete (testing + resolución conflictos)
    effort=$(((total_outdated * 20 + 59) / 60))
    
    # Mínimo 2 horas, máximo 20 horas
    if [ "$effort" -lt 2 ]; then
      effort=2
    elif [ "$effort" -gt 20 ]; then
      effort=20
    fi
  fi
  
  echo "$effort"
}

# TD-007: Complejidad ciclomática
estimate_complexity() {
  # Estimación basada en número de controllers
  # Asumimos que ~20% tienen complejidad alta
  local affected_controllers=$((controllers * 20 / 100))
  
  local effort=0
  if [ "$affected_controllers" -gt 0 ]; then
    # Estimación: 2 horas por controller (refactor + tests)
    effort=$((affected_controllers * 2))
    
    # Mínimo 2 horas, máximo 15 horas
    if [ "$effort" -lt 2 ]; then
      effort=2
    elif [ "$effort" -gt 15 ]; then
      effort=15
    fi
  fi
  
  echo "$effort"
}

# TD-008: Documentación API
estimate_api_docs() {
  # Buscar routes/api.php para contar endpoints
  # (Este script asume que el análisis ya corrió en el directorio del proyecto)
  
  local effort=0
  
  # Estimación fija basada en tamaño del proyecto
  if [ "$total_lines" -gt 30000 ]; then
    effort=12  # Proyecto grande, muchos endpoints
  elif [ "$total_lines" -gt 10000 ]; then
    effort=8   # Proyecto mediano
  else
    effort=4   # Proyecto pequeño
  fi
  
  echo "$effort"
}

# ==============================================================================
# CÁLCULO TOTAL
# ==============================================================================

effort_tests=$(estimate_tests)
effort_phpstan=$(estimate_phpstan)
effort_n_plus_one=$(estimate_n_plus_one)
effort_duplication=$(estimate_duplication)
effort_rate_limiting=$(estimate_rate_limiting)
effort_outdated=$(estimate_outdated_deps)
effort_complexity=$(estimate_complexity)
effort_api_docs=$(estimate_api_docs)

total_effort=$((effort_tests + effort_phpstan + effort_n_plus_one + effort_duplication + effort_rate_limiting + effort_outdated + effort_complexity + effort_api_docs))

# ==============================================================================
# OUTPUT
# ==============================================================================

echo "📊 Estimación de esfuerzo por issue:"
echo ""
echo "  TD-001 (Tests):              $effort_tests horas"
echo "  TD-002 (PHPStan):            $effort_phpstan horas"
echo "  TD-003 (N+1 queries):        $effort_n_plus_one horas"
echo "  TD-004 (Duplicación):        $effort_duplication horas"
echo "  TD-005 (Rate limiting):      $effort_rate_limiting horas"
echo "  TD-006 (Deps obsoletas):     $effort_outdated horas"
echo "  TD-007 (Complejidad):        $effort_complexity horas"
echo "  TD-008 (API docs):           $effort_api_docs horas"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  TOTAL ESTIMADO:              $total_effort horas"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Convertir a semanas (40 horas/semana)
weeks=$(echo "scale=1; $total_effort / 40" | bc)
echo "  Equivalente a:               ~$weeks semanas de trabajo"
echo ""

# Guardar en archivo temporal para que la IA lo lea
cat > /tmp/specleap-effort-estimate.txt <<EOF
Total effort: $total_effort hours
Equivalent: ~$weeks weeks

Breakdown:
- TD-001 Tests: $effort_tests hours
- TD-002 PHPStan: $effort_phpstan hours
- TD-003 N+1: $effort_n_plus_one hours
- TD-004 Duplication: $effort_duplication hours
- TD-005 Rate limiting: $effort_rate_limiting hours
- TD-006 Outdated deps: $effort_outdated hours
- TD-007 Complexity: $effort_complexity hours
- TD-008 API docs: $effort_api_docs hours
EOF

echo "✅ Estimación guardada en /tmp/specleap-effort-estimate.txt"
