# Comando: ayuda

**Trigger:** Usuario escribe "ayuda", "help", "comandos", o "qué puedo hacer"

---

## 📚 Todos los Comandos Disponibles en SpecLeap

SpecLeap tiene **dos formas de trabajar**: Comandos conversacionales (recomendado para chat) y CLI formal (para automatización).

---

### 🗣️ Comandos Conversacionales (Uso en Chat)

**Para proyectos nuevos:**
- **`Hola`** — Iniciar nuevo proyecto con cuestionario 58 preguntas

**Para proyectos existentes:**
- **`refinar`** — Refinar y enriquecer user story con IA
- **`planificar`** — Generar backlog Asana desde CONTRATO.md
- **`implementar`** — Desarrollar funcionalidad según spec
- **`documentar`** — Generar/actualizar documentación técnica
- **`explicar`** — Explicar arquitectura o código existente
- **`crear-tickets`** — Alias de `planificar` (mismo comando)
- **`adoptar`** — Adoptar proyecto legacy (análisis + CONTRATO retroactivo)

**Cómo usar:** Simplemente escribe el comando en el chat con Claude/Cursor/Copilot.

Ejemplo:
```
refinar "Como usuario quiero login con Google"
```

---

### ⚙️ CLI Formal (OpenSpec - Uso en Terminal)

**Para workflow formal con propuestas de cambio:**

```bash
# Ver todos los comandos CLI
openspec --help

# Comandos disponibles:
openspec enrich <user-story>        # Refinar user story con IA
openspec new <CHANGE-ID> <titulo>   # Crear propuesta de cambio
openspec ff <CHANGE-ID>             # Fast-forward: generar propuesta completa
openspec apply <CHANGE-ID>          # Implementar propuesta aprobada
openspec verify <CHANGE-ID>         # Verificar tests y specs
openspec implement <CHANGE-ID>      # Aplicar cambios de code review
openspec code-review <CHANGE-ID>    # Review con CodeRabbit
openspec archive <CHANGE-ID>        # Archivar propuesta completada
openspec report <CHANGE-ID>         # Generar testing report
openspec status                     # Ver propuestas activas
```

**Cómo usar:** Ejecuta desde terminal en la raíz del proyecto.

Ejemplo:
```bash
cd ~/proyectos/mi-app
openspec new CHANGE-001 "Añadir autenticación JWT"
openspec ff CHANGE-001
openspec apply CHANGE-001
```

---

## 🤔 ¿Cuándo Usar Cada Uno?

### Usa **Comandos Conversacionales** cuando:
- ✅ Trabajas solo o en equipo pequeño (1-3 devs)
- ✅ Prefieres chat natural con IA
- ✅ Quieres rapidez y simplicidad
- ✅ No necesitas propuestas formales documentadas

**Perfecto para:** Indie devs, startups, prototipado rápido, proyectos personales

---

### Usa **CLI OpenSpec** cuando:
- ✅ Trabajas en equipo grande (4+ devs)
- ✅ Necesitas propuestas de cambio formales y trazables
- ✅ Quieres workflow estructurado (propuesta → diseño → implementación → review → archivo)
- ✅ Necesitas auditoría completa de cambios
- ✅ Integras con CodeRabbit para code reviews automáticos

**Perfecto para:** Empresas, equipos distribuidos, proyectos enterprise, compliance/auditoría

---

## 🔄 ¿Se Pueden Combinar?

**Sí.** Puedes usar comandos conversacionales para el día a día y CLI para cambios grandes/críticos:

```
Desarrollo normal:
  implementar "fix bug login"              (conversacional - rápido)

Feature grande:
  openspec new CHANGE-015 "Rediseño completo autenticación"
  openspec ff CHANGE-015
  openspec apply CHANGE-015                (CLI - formal + trazable)
```

---

## 📖 Documentación Completa

- **Comandos conversacionales:** Ver archivos `.commands/*.md`
- **CLI OpenSpec:** `openspec/README.md` y `openspec/cli/COMMAND_REFERENCE.md`
- **Guía completa:** `README.md`

---

## 💡 Atajos Rápidos

**Ver este mensaje de ayuda:**
```
ayuda
help
comandos
```

**Listar proyectos:**
```
ls proyectos/
```

**Ver estado de un proyecto:**
```
cd proyectos/mi-proyecto
cat CONTRATO.md
```

**Ver comandos CLI disponibles:**
```bash
openspec --help
```

---

¿Necesitas ayuda con algún comando específico? Dime cuál y te explico en detalle.
