# Comando: adoptar

**Sintaxis:** `adoptar [ruta-proyecto]`

**Objetivo:** Adoptar proyecto legacy/existente en SpecLeap, generando CONTRATO retroactivo + deuda técnica.

**Motor:** Usa `scripts/analyze-project.sh` y `scripts/estimate-effort.sh` (CLI).

---

## Flujo

### 1. Validar Ruta del Proyecto

```bash
# Verificar que existe
if [ ! -d "[ruta-proyecto]" ]; then
  echo "ERROR: Ruta no encontrada"
  exit 1
fi

# Verificar que NO tiene CONTRATO.md ya
if [ -f "[ruta-proyecto]/CONTRATO.md" ]; then
  echo "ERROR: Proyecto ya adoptado (tiene CONTRATO.md)"
  exit 1
fi
```

**Si válido:**
```markdown
✅ Proyecto encontrado: [ruta-proyecto]

Iniciando análisis automático...
```

---

### 2. Análisis Automático (Usar CLI)

```bash
cd specleap
./scripts/analyze-project.sh "[ruta-proyecto]"
```

Este script analiza:
- ✅ Stack tecnológico (composer.json, package.json, etc.)
- ✅ Calidad código (PHPStan, ESLint)
- ✅ Dependencias obsoletas
- ✅ Estructura del proyecto
- ✅ Base de datos (migrations)
- ✅ Tests (cobertura)
- ✅ Git (commits, contribuidores)
- ✅ Documentación existente
- ✅ Seguridad (vulnerabilidades conocidas)

**Output:** `/tmp/specleap-analysis-[proyecto].json`

**Mostrar resumen:**
```markdown
📊 **Análisis Completo**

**Stack Detectado:**
- Backend: Laravel 10.x (PHP 8.2)
- Frontend: React 18 + Vite
- Database: MySQL 8.0
- Cache: Redis 7.x

**Calidad Código:**
- PHPStan: 127 issues (nivel 8)
- ESLint: 43 warnings
- Tests: 156 tests, 68% coverage

**Deuda Técnica Identificada:**
- 🔴 Crítica: 12 issues
- 🟡 Alta: 34 issues
- 🟢 Media: 81 issues

**Estimación:** ~240 horas de refactoring

Ver detalle: /tmp/specleap-analysis-[proyecto].json
```

---

### 3. Estimar Esfuerzo (Usar CLI)

```bash
./scripts/estimate-effort.sh /tmp/specleap-analysis-[proyecto].json
```

**Output:**
```markdown
⏱️ **Estimación de Esfuerzo**

**Refactoring Crítico:** 80 horas (2 semanas)
**Refactoring Alto:** 120 horas (3 semanas)
**Refactoring Medio:** 40 horas (1 semana)

**Total:** 240 horas (~6 semanas con 1 dev full-time)

**Prioridad sugerida:**
1. Seguridad (vulnerabilidades)
2. Tests críticos faltantes
3. Dependencias obsoletas
4. Code smells
```

---

### 4. Generar CONTRATO-LEGACY.md

Usar template + datos del análisis:

```bash
cat proyectos/_template/CONTRATO-LEGACY.md | \
  sed "s/{{PROJECT_NAME}}/[nombre-proyecto]/g" | \
  sed "s/{{BACKEND_FRAMEWORK}}/Laravel 10.x/g" > \
  /tmp/CONTRATO-LEGACY-[proyecto].md
```

**Completar con datos del análisis:**
- Módulos existentes (detectados)
- Stack actual (desde análisis)
- Arquitectura actual (detectada)
- Funcionalidades existentes (inferidas de código)

**Mostrar preview:**
```markdown
📋 **CONTRATO-LEGACY.md Generado**

[Mostrar primeras 50 líneas]

...

¿Aprobar? (s/n)
```

---

### 5. Generar ANEXOS.md (Deuda Técnica)

```bash
# Usar datos del análisis para generar ANEXOS
cat > /tmp/ANEXOS-[proyecto].md <<EOF
# ANEXOS — Deuda Técnica

## Resumen

**Deuda técnica identificada:** 127 issues
**Esfuerzo estimado:** 240 horas

---

## Deuda Crítica (🔴 12 issues)

### 1. Vulnerabilidad de Seguridad: SQL Injection en ProductController
**Archivo:** app/Http/Controllers/ProductController.php:45
**Descripción:** Query SQL sin prepared statements
**Impacto:** Alto — Datos sensibles expuestos
**Esfuerzo:** 2 horas
**Prioridad:** Inmediata

[... resto de issues críticos]

---

## Deuda Alta (🟡 34 issues)

[Lista completa]

---

## Deuda Media (🟢 81 issues)

[Lista completa]
EOF
```

**Mostrar preview:**
```markdown
📋 **ANEXOS.md Generado (Deuda Técnica)**

**12 issues críticos identificados**
**34 issues alta prioridad**
**81 issues media prioridad**

Ver detalle completo en: /tmp/ANEXOS-[proyecto].md

¿Aprobar? (s/n)
```

---

### 6. Crear Estructura SpecLeap

Si el usuario aprueba:

```bash
# Crear proyecto en SpecLeap
PROJECT_NAME="[slug-proyecto]"
mkdir -p proyectos/$PROJECT_NAME

# Copiar CONTRATO y ANEXOS
cp /tmp/CONTRATO-LEGACY-$PROJECT_NAME.md proyectos/$PROJECT_NAME/CONTRATO.md
cp /tmp/ANEXOS-$PROJECT_NAME.md proyectos/$PROJECT_NAME/ANEXOS.md

# Crear context/
mkdir -p proyectos/$PROJECT_NAME/context
cp proyectos/_template/context/* proyectos/$PROJECT_NAME/context/

# Crear specs/ y memory-bank/
mkdir -p proyectos/$PROJECT_NAME/specs
mkdir -p proyectos/$PROJECT_NAME/memory-bank

# Copiar .coderabbit.yaml
cp proyectos/_template/.coderabbit.yaml proyectos/$PROJECT_NAME/

echo "✅ Proyecto adoptado en proyectos/$PROJECT_NAME"
```

---

### 7. Generar Tickets Asana (Deuda Técnica)

```markdown
¿Crear tickets en Asana para la deuda técnica? (s/n)
```

Si el usuario acepta:

```bash
# Generar backlog Asana desde ANEXOS.md
./scripts/generate-asana-structure.sh proyectos/$PROJECT_NAME/ANEXOS.md

# Crear tickets
./scripts/create-asana-tickets.sh proyectos/$PROJECT_NAME/.asana/backlog.json
```

**Secciones generadas:**
- EPIC: Deuda Técnica Crítica (12 tareas)
- EPIC: Deuda Técnica Alta (34 tareas)
- EPIC: Refactoring (features identificadas)

---

### 8. Confirmar Adopción

```markdown
✅ **Proyecto [nombre] adoptado exitosamente**

**Ubicación:** proyectos/[proyecto-slug]/

**Archivos creados:**
- CONTRATO.md (contrato retroactivo)
- ANEXOS.md (deuda técnica)
- context/ (arquitectura, tech-stack, conventions, decisions)
- specs/ (vacío, listo para nuevas features)
- .coderabbit.yaml (config code review)

**Asana:**
- 3 secciones creadas
- 46 tareas de deuda técnica
- 127 tasks identificadas

**Próximos pasos:**

1. **Revisar CONTRATO.md:**
   ```bash
   code proyectos/[proyecto-slug]/CONTRATO.md
   ```

2. **Priorizar deuda técnica:**
   - Revisar tickets en Asana
   - Ordenar por criticidad
   - Asignar a sprints

3. **Empezar refactoring:**
   ```
   refinar SCRUM-XX
   implementar @plan.md
   ```

4. **Nuevas features:**
   - Crear user tareas normales
   - Seguir flujo estándar SpecLeap

**Análisis completo:** /tmp/specleap-analysis-[proyecto].json
```

---

## Scripts CLI Usados

| Script | Propósito |
|--------|-----------|
| `scripts/analyze-project.sh` | Análisis completo del proyecto |
| `scripts/estimate-effort.sh` | Estimación de esfuerzo de refactoring |
| `scripts/generate-asana-structure.sh` | Generar backlog desde ANEXOS.md |
| `scripts/create-asana-tickets.sh` | Crear tickets en Asana |

---

## Requisitos

- ✅ Proyecto con código existente
- ✅ Composer/npm instalados (para análisis)
- ✅ PHPStan/ESLint (instalados automáticamente)
- ✅ Asana configurado (opcional, para tickets)

---

## Notas

- **No modifica el proyecto original** — Solo lo analiza
- **CONTRATO-LEGACY** es retroactivo (documenta lo existente)
- **ANEXOS** es la hoja de ruta de refactoring
- **Deuda técnica** se trata como secciones en Asana

---

## Próximo Comando

- `refinar SCRUM-XX` — Empezar a trabajar en deuda técnica
