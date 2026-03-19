# Proyectos Jira Independientes

**Actualizado:** 2026-02-27

---

## Resumen

SpecLeap ahora crea **proyectos Jira independientes** para cada proyecto, en lugar de agrupar todos en un único proyecto "SCRUM".

---

## Arquitectura

### Antes (v1.0)

```
Todos los proyectos SpecLeap → Proyecto Jira "SCRUM"

casa-de-peli     → SCRUM-1, SCRUM-2, SCRUM-3...
otro-proyecto    → SCRUM-40, SCRUM-41, SCRUM-42...
```

**Problema:**
- ❌ Imposible separar equipos
- ❌ Confusión en tableros
- ❌ Permisos compartidos
- ❌ Dificulta gestión multi-proyecto

### Después (v2.0)

```
Cada proyecto SpecLeap → Proyecto Jira independiente

casa-de-peli     → Proyecto CASADEPEL → CASADEPEL-1, CASADEPEL-2...
otro-proyecto    → Proyecto OTROPROY  → OTROPROY-1, OTROPROY-2...
```

**Ventajas:**
- ✅ Equipos independientes
- ✅ Boards/backlogs separados
- ✅ Permisos granulares
- ✅ Gestión profesional

---

## Generación de Project Key

La **project key** se genera automáticamente desde `project.name`:

### Reglas:

1. Convertir a mayúsculas
2. Eliminar guiones, espacios, guiones bajos
3. Truncar a máximo 10 caracteres
4. Mínimo 2 caracteres

### Ejemplos:

| `project.name` | Project Key Generada | Válida |
|----------------|----------------------|--------|
| `casa-de-peli` | `CASADEPEL` | ✅ (10 chars) |
| `mi-app` | `MIAPP` | ✅ (5 chars) |
| `e-commerce` | `ECOMMERCE` | ✅ (9 chars) |
| `api-backend-v2` | `APIBACKEND` | ✅ (10 chars) |
| `x` | `X` | ❌ (muy corto) |

---

## Flujo de Creación

### 1. Usuario completa cuestionario

```bash
./scripts/generate-contrato.sh
```

- Pregunta 1: Nombre del proyecto → `casa-de-peli`
- Se genera `project.name: "casa-de-peli"`

### 2. Se genera project key

```bash
generate_project_key "casa-de-peli"
# → "CASADEPEL"
```

### 3. Se verifica si proyecto Jira existe

```bash
ensure_jira_project_exists "CASADEPEL" "Casa De Peli" "Descripción..."
```

**Métodos de verificación (en orden):**

1. **MCP Jira** (si está instalado)
   ```bash
   mcp-jira get-project CASADEPEL
   ```

2. **Jira CLI** (si está instalado)
   ```bash
   jira project view CASADEPEL
   ```

3. **Manual** (pregunta al usuario)
   ```
   ¿El proyecto CASADEPEL existe en Jira? [s/N]:
   ```

### 4. Si NO existe, se crea automáticamente

**Métodos de creación (en orden):**

1. **MCP Jira**
   ```bash
   mcp-jira create-project --key CASADEPEL --name "Casa De Peli" --type scrum
   ```

2. **Jira CLI**
   ```bash
   jira project create --key CASADEPEL --template "Scrum software development"
   ```

3. **Manual** (instrucciones al usuario)
   ```
   Por favor crea el proyecto manualmente en Jira:
   1. Ve a Jira → Proyectos → Crear proyecto
   2. Selecciona: Scrum software development
   3. Clave del proyecto: CASADEPEL
   4. Nombre: Casa De Peli
   ```

### 5. Se crean épicas + stories en ese proyecto

```
CASADEPEL-1  (Épica: Búsqueda avanzada)
  CASADEPEL-2  Como desarrollador quiero configurar estructura base
  CASADEPEL-3  Como usuario quiero buscar viviendas
  ...
```

---

## Configuración en CONTRATO.md

El CONTRATO.md incluye metadata Jira:

```yaml
jira:
  project_key: "CASADEPEL"      # Auto-generada o personalizada
  epic_count: 8                 # Épicas creadas
  story_count: 32               # Stories creadas
  synced_at: "2026-02-27T09:15:00Z"  # Última sincronización
```

### Personalizar Project Key

Si quieres una key personalizada (en lugar de auto-generada), edita CONTRATO.md:

```yaml
jira:
  project_key: "CASA"  # Personalizada (2-10 caracteres, solo mayúsculas)
```

El script usará esta key en lugar de generarla automáticamente.

---

## Permisos Requeridos

### Para crear proyectos automáticamente:

**Opción A — Jira Cloud:**
- Permisos: "Administer Projects" (Admin)

**Opción B — Jira Server/Data Center:**
- Permisos: "Create Projects" (Admin)

### Si NO tienes permisos:

El script detectará que no puede crear el proyecto y te dará instrucciones manuales:

1. Copia la key generada (ej: `CASADEPEL`)
2. Ve a Jira → Proyectos → Crear proyecto
3. Tipo: **Scrum software development**
4. Key: `CASADEPEL`
5. Nombre: `Casa De Peli`
6. Vuelve a ejecutar el script

---

## Comandos Útiles

### Verificar si proyecto existe

```bash
# Con MCP Jira
mcp-jira get-project CASADEPEL

# Con Jira CLI
jira project view CASADEPEL

# Con curl (API REST)
curl -u email:token https://tuempresa.atlassian.net/rest/api/3/project/CASADEPEL
```

### Crear proyecto manualmente

```bash
# Con MCP Jira
mcp-jira create-project \
  --key CASADEPEL \
  --name "Casa De Peli" \
  --type scrum \
  --description "Directorio de viviendas para rodajes"

# Con Jira CLI
jira project create \
  --key CASADEPEL \
  --name "Casa De Peli" \
  --template "Scrum software development"
```

### Listar proyectos

```bash
# Con MCP Jira
mcp-jira list-projects

# Con Jira CLI
jira project list

# Con curl
curl -u email:token https://tuempresa.atlassian.net/rest/api/3/project
```

---

## Troubleshooting

### Error: "Project key ya existe"

**Causa:** Ya existe un proyecto con esa key en Jira.

**Solución:**
1. Verifica si es TU proyecto o de otro equipo
2. Si es tuyo → continúa (el script lo detectará)
3. Si es de otro equipo → personaliza la key en CONTRATO.md

### Error: "No tienes permisos para crear proyectos"

**Solución:**
1. Pide permisos al admin de Jira
2. O crea el proyecto manualmente (ver instrucciones arriba)

### Error: "Project key inválida"

**Causa:** La key generada no cumple reglas de Jira:
- Solo mayúsculas (A-Z)
- 2-10 caracteres
- Debe empezar con letra

**Solución:**
Personaliza la key en CONTRATO.md:

```yaml
jira:
  project_key: "MICLAVE"  # Válida
```

---

## Migración desde v1.0

Si ya tienes proyectos en el sistema antiguo (todos en SCRUM):

### Opción A — Dejar como está

Los proyectos antiguos pueden quedarse en SCRUM. Solo los nuevos usarán proyectos independientes.

### Opción B — Migrar a proyectos independientes

1. Crea nuevo proyecto Jira para cada proyecto SpecLeap
2. Mueve tickets manualmente (Jira no permite mover entre proyectos automáticamente)
3. Actualiza `jira.project_key` en CONTRATO.md

**No recomendado** para proyectos activos (pérdida de historial).

---

## Referencias

- **Script:** `scripts/lib/jira-project-utils.sh`
- **Generador backlog:** `scripts/generate-jira-structure.sh`
- **Creador tickets:** `scripts/create-jira-tickets.sh`
- **Jira Project API:** https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-projects/
