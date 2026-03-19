#!/usr/bin/env bash

# SpecLeap — Suite de tests para el sistema de cuestionario
# Fase 2.5

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATE_SCRIPT="$SCRIPT_DIR/generate-contrato.sh"
VALIDATE_LIB="$SCRIPT_DIR/lib/validate.sh"
PARSE_SCRIPT="$SCRIPT_DIR/parse-contrato.sh"
JIRA_SCRIPT="$SCRIPT_DIR/generate-jira-structure.sh"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Contadores
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

print_test_header() {
    echo -e "\n${CYAN}${BOLD}═══ $1 ═══${RESET}\n"
}

print_test() {
    echo -e "${CYAN}→ Test: $1${RESET}"
}

print_pass() {
    echo -e "${GREEN}  ✅ PASS${RESET}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

print_fail() {
    echo -e "${RED}  ❌ FAIL: $1${RESET}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

run_test() {
    TESTS_RUN=$((TESTS_RUN + 1))
}

# ============================================================================
# TESTS DE VALIDACIÓN
# ============================================================================

test_validate_string() {
    print_test_header "Validaciones de String"
    
    source "$VALIDATE_LIB"
    
    # Test 1: String con pattern slug válido
    print_test "String slug válido"
    run_test
    if validate_string_advanced "mi-proyecto-123" "^[a-z0-9-]+$" 3 50 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería aceptar slug válido"
    fi
    
    # Test 2: String slug inválido (mayúsculas)
    print_test "String slug inválido (mayúsculas)"
    run_test
    if ! validate_string_advanced "Mi-Proyecto" "^[a-z0-9-]+$" 3 50 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar mayúsculas en slug"
    fi
    
    # Test 3: String muy corto
    print_test "String muy corto (min_length)"
    run_test
    if ! validate_string_advanced "ab" "^[a-z0-9-]+$" 3 50 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar string menor a min_length"
    fi
    
    # Test 4: String muy largo
    print_test "String muy largo (max_length)"
    run_test
    local long_string=$(printf 'a%.0s' {1..100})
    if ! validate_string_advanced "$long_string" "" 0 50 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar string mayor a max_length"
    fi
    
    # Test 5: Hexcolor válido
    print_test "Hexcolor válido"
    run_test
    if validate_string_advanced "#3B82F6" "^#[0-9A-Fa-f]{6}$" 0 999 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería aceptar hexcolor válido"
    fi
    
    # Test 6: Hexcolor inválido
    print_test "Hexcolor inválido"
    run_test
    if ! validate_string_advanced "#ZZZ" "^#[0-9A-Fa-f]{6}$" 0 999 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar hexcolor inválido"
    fi
}

test_validate_select() {
    print_test_header "Validaciones de Select"
    
    source "$VALIDATE_LIB"
    
    # Test 1: Opción válida
    print_test "Opción válida"
    run_test
    if validate_select_strict "laravel" "laravel" "nodejs" "python" > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería aceptar opción válida"
    fi
    
    # Test 2: Opción inválida
    print_test "Opción inválida"
    run_test
    if ! validate_select_strict "django" "laravel" "nodejs" "python" > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar opción inválida"
    fi
    
    # Test 3: Case-insensitive matching
    print_test "Case-insensitive matching"
    run_test
    if validate_select_strict "Laravel" "laravel" "nodejs" "python" > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería aceptar opciones case-insensitive"
    fi
}

test_validate_boolean() {
    print_test_header "Validaciones de Boolean"
    
    source "$VALIDATE_LIB"
    
    # Test valores true
    print_test "Boolean true (múltiples formatos)"
    run_test
    local all_true=true
    for val in "true" "s" "si" "yes" "y" "1"; do
        if ! validate_boolean_strict "$val" | grep -q "true"; then
            all_true=false
        fi
    done
    if $all_true; then
        print_pass
    else
        print_fail "Debería normalizar todos los valores true"
    fi
    
    # Test valores false
    print_test "Boolean false (múltiples formatos)"
    run_test
    local all_false=true
    for val in "false" "n" "no" "0"; do
        if ! validate_boolean_strict "$val" | grep -q "false"; then
            all_false=false
        fi
    done
    if $all_false; then
        print_pass
    else
        print_fail "Debería normalizar todos los valores false"
    fi
    
    # Test valor inválido
    print_test "Boolean inválido"
    run_test
    if ! validate_boolean_strict "maybe" > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar valor booleano inválido"
    fi
}

test_validate_number() {
    print_test_header "Validaciones de Number"
    
    source "$VALIDATE_LIB"
    
    # Test número válido en rango
    print_test "Número válido en rango"
    run_test
    if validate_number_range "50" 0 100 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería aceptar número en rango"
    fi
    
    # Test número menor al mínimo
    print_test "Número menor al mínimo"
    run_test
    if ! validate_number_range "5" 10 100 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar número menor al mínimo"
    fi
    
    # Test número mayor al máximo
    print_test "Número mayor al máximo"
    run_test
    if ! validate_number_range "150" 0 100 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar número mayor al máximo"
    fi
    
    # Test no es número
    print_test "No es número"
    run_test
    if ! validate_number_range "abc" 0 100 > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Debería rechazar texto como número"
    fi
}

# ============================================================================
# TESTS DE PARSER
# ============================================================================

test_parser() {
    print_test_header "Parser CONTRATO.md"
    
    # Crear CONTRATO.md de prueba
    local test_dir="/tmp/specleap-test-$$"
    mkdir -p "$test_dir"
    
    cat > "$test_dir/CONTRATO.md" <<'EOF'
---
project:
  name: test-project
  display_name: Test Project
identity:
  objective: Test objective
  problem_solved: Test problem
stack:
  backend:
    framework: laravel
features:
  core:
    - Feature 1
    - Feature 2
---

# Test Content
EOF
    
    # Test 1: Parse exitoso
    print_test "Parse CONTRATO.md válido"
    run_test
    if bash "$PARSE_SCRIPT" parse "$test_dir/CONTRATO.md" "$test_dir/output.json" > /dev/null 2>&1; then
        if [[ -f "$test_dir/output.json" ]]; then
            print_pass
        else
            print_fail "No se generó output.json"
        fi
    else
        print_fail "Fallo al parsear"
    fi
    
    # Test 2: Validación estructura
    print_test "Validar estructura CONTRATO.md"
    run_test
    if bash "$PARSE_SCRIPT" validate "$test_dir/CONTRATO.md" > /dev/null 2>&1; then
        print_pass
    else
        print_fail "Validación debería pasar"
    fi
    
    # Test 3: Extraer nombre
    print_test "Extraer project.name"
    run_test
    local extracted_name=$(bash "$PARSE_SCRIPT" get-name "$test_dir/CONTRATO.md" 2>/dev/null)
    if [[ "$extracted_name" == "test-project" ]]; then
        print_pass
    else
        print_fail "Debería extraer 'test-project', obtuvo: $extracted_name"
    fi
    
    # Cleanup
    rm -rf "$test_dir"
}

# ============================================================================
# TESTS DE GENERACIÓN JIRA
# ============================================================================

test_jira_generation() {
    print_test_header "Generación Backlog Jira"
    
    # Crear CONTRATO.md de prueba
    local test_dir="/tmp/specleap-test-jira-$$"
    mkdir -p "$test_dir"
    
    cat > "$test_dir/CONTRATO.md" <<'EOF'
---
project:
  name: test-jira
  display_name: Test Jira Project
identity:
  objective: Test Jira integration
  problem_solved: Generate Jira backlog
stack:
  backend:
    framework: laravel
features:
  core:
    - Authentication
    - Dashboard
    - Reports
---

# Test Content
EOF
    
    # Test 1: Generar backlog
    print_test "Generar backlog.json"
    run_test
    if bash "$JIRA_SCRIPT" "$test_dir/CONTRATO.md" > /dev/null 2>&1; then
        if [[ -f "$test_dir/.jira/backlog.json" ]]; then
            print_pass
        else
            print_fail "No se generó backlog.json"
        fi
    else
        print_fail "Fallo al generar backlog"
    fi
    
    # Test 2: Estructura JSON válida
    print_test "Estructura JSON válida"
    run_test
    if [[ -f "$test_dir/.jira/backlog.json" ]]; then
        if jq empty "$test_dir/.jira/backlog.json" 2>/dev/null; then
            print_pass
        else
            print_fail "JSON inválido"
        fi
    else
        print_fail "Backlog no existe"
    fi
    
    # Test 3: Épicas generadas (debería ser 3, una por feature)
    print_test "Épicas generadas (3 esperadas)"
    run_test
    if [[ -f "$test_dir/.jira/backlog.json" ]]; then
        local epic_count=$(jq '.epics | length' "$test_dir/.jira/backlog.json")
        if [[ "$epic_count" == "3" ]]; then
            print_pass
        else
            print_fail "Esperado 3 épicas, obtuvo: $epic_count"
        fi
    else
        print_fail "Backlog no existe"
    fi
    
    # Test 4: Stories por épica (debería ser 4 por épica)
    print_test "Stories por épica (4 esperadas)"
    run_test
    if [[ -f "$test_dir/.jira/backlog.json" ]]; then
        local story_count=$(jq '.epics[0].stories | length' "$test_dir/.jira/backlog.json")
        if [[ "$story_count" == "4" ]]; then
            print_pass
        else
            print_fail "Esperado 4 stories por épica, obtuvo: $story_count"
        fi
    else
        print_fail "Backlog no existe"
    fi
    
    # Cleanup
    rm -rf "$test_dir"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    echo -e "${CYAN}${BOLD}"
    echo "════════════════════════════════════════════════════════════════"
    echo "  🧪 SpecLeap — Test Suite"
    echo "════════════════════════════════════════════════════════════════"
    echo -e "${RESET}"
    
    test_validate_string
    test_validate_select
    test_validate_boolean
    test_validate_number
    test_parser
    test_jira_generation
    
    # Resumen
    echo ""
    echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${BOLD}RESUMEN${RESET}"
    echo -e "${CYAN}  Tests ejecutados: ${BOLD}$TESTS_RUN${RESET}"
    echo -e "${GREEN}  Tests pasados:    ${BOLD}$TESTS_PASSED${RESET}"
    echo -e "${RED}  Tests fallidos:   ${BOLD}$TESTS_FAILED${RESET}"
    echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════════${RESET}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}${BOLD}✅ Todos los tests pasaron!${RESET}\n"
        exit 0
    else
        echo -e "\n${RED}${BOLD}❌ Algunos tests fallaron${RESET}\n"
        exit 1
    fi
}

# Ejecutar
main "$@"
