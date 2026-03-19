# Comando: refinar

**Sintaxis:** `refinar [TASK_GID]` o `refinar [nombre-tarea]`

**Objetivo:** Refinar una tarea de Asana para que sea completa, específica y lista para implementación técnica.

**Motor:** Usa `openspec enrich` (CLI) para el refinamiento con AI.

---

## 🌐 Idioma

**TODOS los mensajes y análisis deben estar en ESPAÑOL.**

Esto incluye:
- User stories refinadas
- Criterios de aceptación
- Preguntas de clarificación
- Análisis de complejidad
- Recomendaciones

---

## Flujo

### 1. Leer Tarea de Asana

**Obtener tarea por GID:**

```bash
source scripts/lib/asana-utils.sh
curl -s -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
  "https://app.asana.com/api/1.0/tasks/[TASK_GID]" | jq '.data'
```

**Si el usuario proporciona nombre de tarea:**

Buscar en el proyecto:
```bash
source scripts/lib/asana-utils.sh
asana_list_tasks [PROJECT_GID] | grep -i "[nombre-tarea]"
```

**Si no se encuentra:**
```markdown
No encontré esa tarea en Asana.

Por favor, proporciona:
1. El GID de la tarea (número largo)
2. O el título exacto de la tarea
3. O pega aquí el contenido completo de la tarea
```

Espera la respuesta del usuario.

---

### 2. Leer Contexto del Proyecto

Lee los siguientes archivos para entender el proyecto:

1. `proyectos/[proyecto-actual]/CONTRATO.md`
2. `proyectos/[proyecto-actual]/context/architecture.md`
3. `proyectos/[proyecto-actual]/context/tech-stack.md`
4. `proyectos/[proyecto-actual]/context/conventions.md`

**Nota:** El proyecto actual se determina por el último comando `/inicio` ejecutado, o pregunta cuál es si no está claro.

---

### 3. Preparar Input para CLI

Crea un archivo temporal con la user story + contexto:

```bash
cat > /tmp/user-story-input.md <<EOF
# User Story Original
$TICKET_CONTENT

# Contexto del Proyecto

## Stack
$TECH_STACK

## Arquitectura
$ARCHITECTURE

## Convenciones
$CONVENTIONS
EOF
```

---

### 4. Refinar con CLI

Ejecuta el refinamiento usando CLI:

```bash
openspec enrich --file /tmp/user-story-input.md --output /tmp/user-story-refined.md
```

Esto genera una user story completa con:
- Contexto técnico
- Criterios de aceptación (GIVEN/WHEN/THEN)
- Especificación técnica (endpoints, componentes, DB)
- Validaciones
- Reglas de negocio
- Estimación
- Riesgos
- Fuera de alcance

---

### 5. Mostrar Preview

Lee el resultado:

```bash
cat /tmp/user-story-refined.md
```

Muestra al usuario:

```markdown
📋 **Tarea Refinada (Preview):**

[Primeras 30 líneas del contenido refinado]

...

**¿Aprobar y actualizar Asana?** (s/n)
```

Espera confirmación del usuario.

---

### 6A. Si el usuario aprueba: Actualizar Asana

```bash
# Actualizar tarea en Asana
source scripts/lib/asana-utils.sh

# Leer contenido refinado
REFINED_CONTENT=$(cat /tmp/user-story-refined.md)

# Actualizar notas de la tarea
curl -s -X PUT \
  -H "Authorization: Bearer $ASANA_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"data\": {\"notes\": \"$REFINED_CONTENT\"}}" \
  "https://app.asana.com/api/1.0/tasks/[TASK_GID]"
```

**También guardar localmente:**

```bash
cp /tmp/user-story-refined.md proyectos/[proyecto]/specs/task-[TASK_GID]_refined.md
```

**Mostrar confirmación:**
```markdown
✅ **Tarea actualizada en Asana**

📋 **Local:** `proyectos/[proyecto]/specs/task-[TASK_GID]_refined.md`

📊 **Ver en Asana:** https://app.asana.com/0/[PROJECT_GID]/[TASK_GID]

**Próximos pasos:**
1. Revisa la tarea refinada en Asana
2. Asigna la tarea a un desarrollador
3. Ejecuta `implementar` cuando estés listo
```

---

### 6B. Si el usuario NO aprueba: Editar

```markdown
**¿Qué quieres modificar?**

Puedes decir cosas como:
- "Agrega que debe soportar OAuth"
- "Cambia la estimación a 5 días"
- "Elimina el criterio de aceptación 3"
- "Agrega validación de email único"
```

Espera feedback, edita `/tmp/user-story-refined.md` y vuelve al paso 5.

---

### 7. Confirmar Actualización

```markdown
✅ **Tarea refinada exitosamente.**

**Agregado:**
- ✅ [X] criterios de aceptación (GIVEN/WHEN/THEN)
- ✅ Especificación técnica completa
- ✅ Validaciones (server + client)
- ✅ Estimación: [X días]

**Ubicación:**
- Asana: https://app.asana.com/0/[PROJECT_GID]/[TASK_GID]
- Local: `proyectos/[proyecto]/specs/task-[TASK_GID]_refined.md`

🔄 **Próximo paso:**
- Ejecuta `implementar` para comenzar el desarrollo
```

---

## Ejemplos de Uso

### Ejemplo 1: Con GID de Asana

```
Usuario: "refinar 1234567890123456"

IA:
📥 Leyendo tarea de Asana...
✅ Tarea leída: "Implementar sistema de login"

📚 Cargando contexto del proyecto...
✅ CONTRATO.md, architecture.md, tech-stack.md, conventions.md cargados.

🤖 Refinando con openspec enrich...
✅ Tarea refinada (7 criterios de aceptación, 4 endpoints API, validaciones).

📋 Preview:
[Muestra primeras 30 líneas]

¿Aprobar y actualizar Asana? (s/n)

Usuario: "s"

IA:
✅ Tarea actualizada en Asana.
✅ Guardada localmente en specs/task-1234567890123456_refined.md

Próximo: implementar
```

### Ejemplo 2: Por nombre de tarea

```
Usuario: "refinar login"

IA:
🔍 Buscando tarea 'login' en el proyecto...
✅ Encontrada: "Implementar sistema de login" (GID: 1234567890123456)

📚 Cargando contexto...
✅ Contexto cargado.

🤖 Refinando con openspec enrich...
✅ Tarea refinada.

📋 Preview:
[Muestra contenido]

¿Aprobar? (s/n)

Usuario: "s"

IA:
✅ Tarea actualizada en Asana
✅ Guardado en specs/task-1234567890123456_refined.md

📊 Ver en Asana: https://app.asana.com/0/[PROJECT_GID]/1234567890123456
```

---

## Comandos CLI Usados

| Comando | Propósito |
|---------|-----------|
| `scripts/lib/asana-utils.sh` | Utilidades para API de Asana |
| `curl ... /api/1.0/tasks/[GID]` | Leer tarea de Asana |
| `openspec enrich --file <input> --output <output>` | Refinar tarea con AI |
| `curl -X PUT ... /api/1.0/tasks/[GID]` | Actualizar tarea en Asana |

---

## Reglas Críticas

1. **SIEMPRE usar CLI** — Delegar refinamiento a `openspec enrich`
2. **Leer CONTRATO.md** — Alinear refinamiento con contrato
3. **Preview antes de actualizar** — Pedir confirmación al usuario
4. **Guardar localmente** — Siempre guardar en specs/ además de actualizar Asana
5. **No asumir** — Si falta contexto, preguntar

---

## Agente Relacionado

- `.agents/producto.md` — El CLI `openspec enrich` sigue este rol

---

## Próximo Comando

- `implementar` — Comenzar el desarrollo de la tarea refinada
