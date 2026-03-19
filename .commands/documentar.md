# Comando: documentar

**Sintaxis:** `documentar` o `documentar [archivo]`

**Objetivo:** Actualizar documentación técnica (context/) cuando hay cambios importantes.

**Motor:** Usa Git para analizar cambios + actualización manual guiada.

---

## Flujo

### 1. Identificar Qué Documentar

**Opción A: Archivo específico**
```
documentar context/architecture.md
```

**Opción B: Análisis automático**
```
documentar
```
→ Analiza cambios recientes y determina qué actualizar

---

### 2. Analizar Cambios Recientes (Git)

```bash
cd [directorio-proyecto]

# Ver commits recientes
git log --oneline -20

# Ver archivos modificados
git diff HEAD~10..HEAD --name-only

# Ver cambios en dependencias
git diff HEAD~10..HEAD package.json composer.json
```

**Identificar:**
- ✅ Nuevas features implementadas
- ✅ Cambios arquitectónicos
- ✅ Nuevas dependencias
- ✅ Decisiones técnicas tomadas

---

### 3. Leer Documentación Actual

```bash
cd proyectos/[proyecto]/context/

# Leer todos los archivos
cat brief.md
cat architecture.md
cat tech-stack.md
cat conventions.md
cat decisions.md
```

---

### 4. Determinar Actualizaciones Necesarias

**Checklist:**

**brief.md:**
- [ ] Cambió el propósito del proyecto
- [ ] Hay nuevos módulos completados
- [ ] Cambió el estado (% progreso)

**architecture.md:**
- [ ] Nueva capa/componente agregado
- [ ] Cambió estructura de directorios
- [ ] Modificó patrón arquitectónico
- [ ] Nuevas dependencias entre módulos

**tech-stack.md:**
- [ ] Nueva dependencia (npm/composer)
- [ ] Actualización de versión importante
- [ ] Cambió herramienta (ej: Webpack → Vite)
- [ ] Nuevo servicio externo

**conventions.md:**
- [ ] Nuevo patrón de código establecido
- [ ] Cambió naming convention
- [ ] Nueva regla de testing

**decisions.md:**
- [ ] Decisión técnica importante tomada
- [ ] Alternativas evaluadas
- [ ] Decisión pendiente resuelta

---

### 5. Actualizar Archivos

Para cada archivo que necesita actualización:

**A) Mostrar contenido actual:**
```markdown
📄 **Contenido actual de [archivo]:**

[Mostrar primeras 30 líneas]

...

¿Qué quieres actualizar?
```

**B) Esperar input del usuario:**

Ejemplos:
- "Agrega que ahora usamos Redis para cache"
- "Actualiza la versión de Laravel a 11.x"
- "Agrega decisión sobre usar PostgreSQL en lugar de MySQL"

**C) Aplicar cambios:**

Editar el archivo con los cambios especificados.

**D) Mostrar diff:**
```bash
git diff context/[archivo]
```

```markdown
**Cambios en [archivo]:**

[Mostrar diff con colores]

¿Aprobar cambios? (s/n)
```

---

### 6. Confirmar y Commitear

Si el usuario aprueba:

```bash
git add context/*.md
git commit -m "docs: update context/ documentation

Updated:
- [archivo1]: [cambio1]
- [archivo2]: [cambio2]

Refs: [commits que motivaron la actualización]"
```

```markdown
✅ **Documentación actualizada**

**Archivos modificados:**
- context/architecture.md
- context/tech-stack.md
- context/decisions.md

**Commit:** docs: update context/ documentation

¿Pushear cambios? (s/n)
```

---

## Ejemplo Completo

```
Usuario: "documentar"

IA:
🔍 Analizando cambios recientes...

git log --oneline -20:
  a1b2c3d feat: implement Redis cache
  d4e5f6g feat: upgrade Laravel to 11.x
  g7h8i9j refactor: move to PostgreSQL

📋 **Cambios detectados:**
1. Redis implementado para cache (commit a1b2c3d)
2. Laravel actualizado a 11.x (commit d4e5f6g)
3. Migración a PostgreSQL (commit g7h8i9j)

**Archivos a actualizar:**
- ✅ context/tech-stack.md (Redis + Laravel 11.x + PostgreSQL)
- ✅ context/architecture.md (nueva capa de cache)
- ✅ context/decisions.md (decisión PostgreSQL vs MySQL)

¿Actualizar estos archivos? (s/n)

Usuario: "s"

IA:
📝 Actualizando context/tech-stack.md...

**Agregando:**
- Laravel: 10.x → 11.x
- Cache: Redis 7.x (nuevo)
- Database: MySQL 8.0 → PostgreSQL 16.x

✅ tech-stack.md actualizado.

📝 Actualizando context/decisions.md...

**Agregando decisión:**
## 2026-02-26: Migración a PostgreSQL

**Contexto:** MySQL presentaba limitaciones con JSON queries.

**Alternativas evaluadas:**
1. MySQL 8.0 con JSON
2. PostgreSQL 16
3. MongoDB

**Decisión:** PostgreSQL 16

**Razones:**
- JSON nativo + mejor performance
- JSONB indexable
- Full-text search integrado
- Compatibilidad Laravel excelente

✅ decisions.md actualizado.

📝 Actualizando context/architecture.md...

**Agregando capa:**
## Cache Layer (Redis)

Implementado para reducir carga en base de datos.

**Cache keys:**
- `user:{id}` — Datos de usuario (TTL: 1h)
- `product:{id}` — Datos de producto (TTL: 30min)
- `categories` — Árbol de categorías (TTL: 24h)

✅ architecture.md actualizado.

💾 **Commiteando cambios...**

git commit -m "docs: update context/ - Redis cache + Laravel 11.x + PostgreSQL"

✅ Commit realizado.

¿Pushear? (s/n)

Usuario: "s"

git push origin main

✅ Documentación actualizada y pusheada.
```

---

## Comandos/Herramientas Usados

| Comando | Propósito |
|---------|-----------|
| `git log --oneline -20` | Ver commits recientes |
| `git diff HEAD~10..HEAD --name-only` | Archivos modificados |
| `git diff HEAD~10..HEAD package.json` | Cambios en dependencias |
| `git diff context/[archivo]` | Preview de cambios |
| `git add context/*.md` | Preparar commit |
| `git commit -m "..."` | Commitear |

---

## Reglas

1. **Siempre usar Git** para detectar cambios reales
2. **Mostrar diff** antes de commitear
3. **Pedir aprobación** al usuario
4. **Commits atómicos** (documentación separada de código)
5. **Referencias** a commits que motivaron la actualización

---

## Próximo Comando

- `explicar [concepto]` — Explicar código/arquitectura existente
