# 🏛️ SpecLeap — Spec-Driven Development Framework

> **Forja tu arquitectura de software con IA.**

Un framework de desarrollo que combina contratos inmutables, agentes conversacionales y standards de código para entregar software de calidad sin improvisación.

---

## 🎯 ¿Qué es SpecLeap?

SpecLeap transforma cualquier IDE con asistente de IA en una máquina de desarrollo **spec-first**:

- 📋 **CONTRATO.md inmutable** — Define alcance y nunca cambia
- 🤖 **Agentes especializados** — Backend, Frontend, Producto
- 💬 **Comandos en español** — `refinar`, `planificar`, `implementar`
- 📦 **Multi-proyecto** — Cada proyecto independiente con su contrato
- 📚 **Standards globales** — Laravel, React, documentación
- 🔧 **CLI opcional** — `openspec` para automatización

---

## 💡 El Problema que Resuelve

❌ **Sin SpecLeap:**
- La IA improvisa código sin contexto
- Specs incompletas → implementación incorrecta
- Sin memoria → repite errores
- Cambios de scope sin control

✅ **Con SpecLeap:**
- CONTRATO define alcance inmutable
- Context/ guarda decisiones arquitectónicas
- Agentes especializados siguen standards
- Comandos conversacionales guían el flujo
- Memoria persistente por proyecto

---

## 🚀 Instalación

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/iapanderson/specleap-framework.git
cd specleap/
chmod +x install.sh
./install.sh
```

El instalador te permitirá seleccionar tu idioma preferido (Español o English).

**¿Qué hace el instalador?**
- ✅ Selección de idioma (ES/EN)
- ✅ Crea archivo de configuración `.specleap/config.json`
- ✅ Genera archivo `.env` con variables de entorno
- ✅ Hace ejecutables todos los scripts
- ✅ Configura traducciones automáticas

### Paso 2: Configurar GitHub + Asana (Necesario para Workflow Profesional)

**¿Por qué GitHub + Asana?**

SpecLeap está diseñado para **desarrollo profesional spec-first**. Para que funcione correctamente necesitas:

✅ **GitHub** (OBLIGATORIO):
- Almacena CONTRATO.md versionado
- Source of truth del proyecto
- Historial de cambios y decisiones
- Colaboración en equipo

✅ **Asana** (OBLIGATORIO para workflow completo):
- Genera backlog automático desde CONTRATO.md
- Trackea progreso de implementación
- Organiza épicas y tareas
- Integración con comandos SpecLeap

**Instalación:**

```bash
bash scripts/setup-mcp.sh
```

El script instalará automáticamente:
- ✅ **Cliente Asana** — Para integración con Asana API
- ✅ **20 Skills TIER 1** — Seguridad, diseño, backend, frontend
- ✅ **Context7 MCP** (opcional) — Docs actualizadas de librerías

**Tiempo:** ~5 minutos total

**⚠️ Sin GitHub/Asana:** SpecLeap funciona parcialmente (solo generación de CONTRATO local), pero pierdes el workflow profesional completo.

**Detalle completo:** Ver [SETUP.md](SETUP.md)

---

## ⭐ Agent Skills — Lo Que Hace la Diferencia

SpecLeap incluye **20 skills especializadas** que transforman la calidad del código:

### Sin Skills vs Con Skills

| Aspecto | Sin Skills | Con Skills TIER 1 |
|---------|-----------|-------------------|
| **Diseño** | Bootstrap genérico | Estilo Vercel/Linear profesional |
| **Seguridad** | Vulnerabilidades básicas | OWASP Top 10 + STRIDE threat modeling |
| **Código** | Duplicación frecuente | DRY automático, verifica antes de crear |
| **APIs** | Diseño inconsistente | REST/GraphQL best practices |
| **Tests** | Coverage <60% | TDD methodology, coverage >=90% |

### TIER 1 (20 Skills Esenciales)

#### 🔒 Seguridad (5)
- SAST configuration
- STRIDE threat modeling
- Security requirement extraction
- Backend/API security
- Frontend/Mobile security

#### 🔄 Consistencia (3)
- **Verification-before-completion** ⭐ **CRÍTICO**
- Code review excellence
- Systematic debugging

#### 🎨 Diseño/Frontend (6)
- Web design guidelines (Vercel)
- Frontend design (Anthropic)
- UI/UX pro max
- Tailwind design system
- shadcn/ui components
- Responsive design

#### 🛠️ Backend/Dev (6)
- Laravel specialist
- React best practices
- Test-driven development
- API design principles
- PostgreSQL table design
- Error handling patterns

**Instalación:** Automática con `setup-mcp.sh` o manual — [Ver SETUP.md](SETUP.md)

---

## 🎯 Cuestionario Interactivo — De Idea a CONTRATO en 20 Minutos

**Nuevo en SpecLeap:** Sistema de 58 preguntas que genera tu CONTRATO.md automáticamente.

### ¿Cómo Funciona?

```bash
# Ejecuta el cuestionario
./scripts/generate-contrato.sh

# Te hace 58 preguntas sobre tu proyecto
# Guarda progreso cada 10 preguntas (puedes interrumpir)
# Genera CONTRATO.md completo con YAML frontmatter
```

### Lo Que Obtienes

✅ **CONTRATO.md completo** con:
- Información del proyecto (nombre, responsable, fecha)
- Identidad (objetivo, problema que resuelve, público objetivo)
- Stack tecnológico (backend, frontend, base de datos, DevOps)
- Funcionalidades core y secundarias
- Sistema de usuarios (roles, autenticación, permisos)
- Diseño (colores, estilo visual, responsive)
- Arquitectura (patrón, separación)
- Seguridad (nivel, GDPR, datos sensibles)
- Rendimiento (targets de carga, usuarios concurrentes)
- Testing (unit, integration, e2e, coverage)
- Restricciones (plazo, presupuesto, fuera de alcance)

✅ **Validaciones inteligentes:**
- Tipos de datos (string, select, boolean, number, array)
- Rangos y longitudes
- Patterns regex (slug, hexcolor, etc.)
- Skip condicional (si no tiene auth, no pregunta métodos)
- Auto-sugerencias (si eliges Laravel, sugiere PHP 8.3)

✅ **Guardado parcial:**
- Checkpoint cada 10 preguntas
- Puedes interrumpir y continuar después
- Detecta sesiones incompletas automáticamente

✅ **Integración Asana:**
- Genera backlog (secciones + user tareas)
- Preview visual antes de crear
- Confirmación manual
- Actualiza CONTRATO.md con metadata Asana

### Workflow Completo

```
1. Ejecuta cuestionario (20 min)
   ↓
2. Responde 58 preguntas
   ↓
3. CONTRATO.md generado automáticamente
   ↓
4. Push a GitHub (OBLIGATORIO — control de versiones)
   ↓
5. planificar → crea backlog Asana
   ↓
6. implementar → desarrolla según spec
```

**⚠️ IMPORTANTE:** El CONTRATO.md DEBE guardarse en GitHub. Es la fuente de verdad del proyecto y debe estar versionado junto con el código.

### Ejemplo de Uso

```bash
$ cd specleap
$ ./scripts/generate-contrato.sh

🎯 SpecLeap — Generador de CONTRATO.md
════════════════════════════════════════

⏱️  Tiempo estimado: 15-20 minutos
💾 Guardado automático cada 10 preguntas
🔄 Puedes interrumpir con Ctrl+C

¿Listo para comenzar? [s/N]: s

━━━ Información del Proyecto ━━━

Pregunta 1/56: ¿Nombre del proyecto? (slug-style)
💡 Usa solo minúsculas, números y guiones
📝 Ejemplo: mi-proyecto
> mi-tienda-online

Pregunta 2/56: ¿Nombre completo para mostrar?
💡 Puede tener mayúsculas, espacios
📝 Ejemplo: Mi Proyecto Awesome
> Mi Tienda Online

... (54 preguntas más)

✅ ¡Cuestionario completado! 🎉

━━━ Generando CONTRATO.md ━━━

✅ CONTRATO.md generado exitosamente
📄 Ubicación: proyectos/mi-tienda-online/CONTRATO.md
```

**Más información:** Ver [docs/SPEC-CUESTIONARIO-INTERACTIVO.md](docs/SPEC-CUESTIONARIO-INTERACTIVO.md)

---

## 📦 Estructura del Framework

```
specleap/
├── proyectos/                    # Proyectos independientes
│   ├── _template/                # Template para nuevos proyectos
│   │   ├── CONTRATO.md           # 🔒 Contrato inmutable
│   │   ├── ANEXOS.md             # ✏️ Mejoras/módulos adicionales
│   │   ├── context/              # Memory-bank del proyecto
│   │   │   ├── brief.md
│   │   │   ├── architecture.md
│   │   │   ├── tech-stack.md
│   │   │   ├── conventions.md
│   │   │   ├── decisions.md
│   │   │   ├── personas.md
│   │   │   └── user-stories.md
│   │   └── openspec/             # CLI state (propuestas)
│   │       └── proposals/
│   └── mi-proyecto/              # Tu proyecto activo
│       └── [misma estructura]
├── .agents/                      # Agentes especializados
│   ├── backend.md
│   ├── frontend.md
│   └── producto.md
├── .commands/                    # Comandos conversacionales
│   ├── inicio.md                 # Cuestionario 58 preguntas
│   ├── refinar.md
│   ├── planificar.md
│   ├── implementar.md
│   ├── documentar.md
│   ├── explicar.md
│   └── adoptar.md
├── rules/                        # Standards globales
│   ├── PHP-LARAVEL.md
│   ├── JAVASCRIPT-REACT.md
│   ├── CSS-TAILWIND.md
│   └── DOCS.md
├── scripts/                      # Automatización
│   ├── generate-contrato.sh      # Cuestionario interactivo ⭐
│   ├── generate-jira-structure.sh
│   ├── analyze-project.sh
│   ├── setup-mcp.sh              # Install Asana + Skills
│   └── install-skills.sh         # Agent Skills installer
├── openspec/                     # CLI (opcional)
│   ├── bin/openspec
│   └── src/
├── CLAUDE.md                     # Reglas generales para IA
├── AGENTS.md                     # Orquestación de agentes
└── SETUP.md                      # Guía completa de setup
```

---

## 🎮 Comandos Conversacionales

Habla con Claude/Cursor/Continue usando comandos en español:

### Para Nuevos Proyectos

```
Hola
→ Inicia cuestionario de 58 preguntas
→ Genera CONTRATO.md completo automáticamente
```

### Para Proyectos Existentes

```
refinar "añadir sistema de notificaciones push"
→ Analiza viabilidad
→ Genera propuesta de cambio
→ Actualiza context/

planificar
→ Lee CONTRATO.md
→ Genera backlog Asana
→ Crea secciones + user stories

implementar "login con google"
→ Verifica si está en CONTRATO
→ Lee context/ para contexto
→ Genera código siguiendo standards

documentar "api de usuarios"
→ Genera docs API (OpenAPI/Swagger)
→ Actualiza README técnico

explicar "arquitectura del sistema"
→ Genera diagrama + explicación
→ Basado en context/architecture.md

adoptar
→ Analiza proyecto existente
→ Genera CONTRATO retroactivo
→ Extrae arquitectura y decisiones
```

**Detalle completo:** Ver [docs/COMANDOS.md](docs/COMANDOS.md)

---

## 🛠️ CLI openspec (Opcional)

Para workflows formales con propuestas de cambio:

```bash
# Inicializar proyecto
openspec init

# Proponer cambio
openspec new "añadir carrito de compras"
→ Crea propuesta en openspec/proposals/
→ Compara con CONTRATO
→ Genera diff

# Revisar propuestas
openspec list
openspec show 001-carrito-compras

# Aprobar/Rechazar
openspec approve 001-carrito-compras
openspec reject 001-carrito-compras --reason "fuera de alcance"

# Verificar implementación
openspec verify 001-carrito-compras
→ Compara código vs propuesta
→ Valida que cumple spec
```

**Detalle completo:** Ver [docs/CLI-OPENSPEC.md](docs/CLI-OPENSPEC.md)

---

## 🎨 Funciona con tu IDE Favorito

**SpecLeap es agnóstico al IDE.** Funciona con **cualquier editor que tenga asistente de IA**:

- ✅ **VSCode** — Con GitHub Copilot, Claude Code, Cursor extension
- ✅ **Cursor** — IDE nativo con Claude integrado
- ✅ **JetBrains** (IntelliJ, PhpStorm, WebStorm) — Con AI Assistant
- ✅ **Vim/Neovim** — Con plugins de IA (copilot.vim, etc.)
- ✅ **Zed** — Editor moderno con IA integrada
- ✅ **Continue.dev** — Compatible con múltiples IDEs
- ✅ **Cualquier IDE con asistente IA** — Si tu editor tiene IA, SpecLeap funciona

**Cómo funciona:**
- Lee archivos del proyecto (CLAUDE.md, GEMINI.md, .cursorrules, .copilot-instructions.md)
- Aplica Agent Skills automáticamente
- Usa comandos conversacionales o CLI según tu preferencia

**No hay IDE "recomendado"** — Usa el que más te guste. SpecLeap se adapta.

---

## 📚 Documentación Completa

- 📖 [SETUP.md](SETUP.md) — Instalación paso a paso
- 🎯 [docs/CUESTIONARIO-INTERACTIVO.md](docs/SPEC-CUESTIONARIO-INTERACTIVO.md) — Sistema 58 preguntas
- 💬 [docs/COMANDOS.md](docs/COMANDOS.md) — Referencia comandos
- 🛠️ [docs/CLI-OPENSPEC.md](docs/CLI-OPENSPEC.md) — CLI formal
- 🤖 [docs/AGENTES.md](docs/AGENTES.md) — Especialización de agentes
- ⭐ [docs/SKILLS-REFERENCE.md](docs/SKILLS-REFERENCE.md) — 20 Agent Skills
- 📋 [docs/CONTRATO-TEMPLATE.md](docs/CONTRATO-TEMPLATE.md) — Template contrato
- 🏗️ [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md) — Filosofía y diseño

---

## 💖 Apoya el Proyecto

SpecLeap es **100% gratuito y open-source**. Si te resulta útil, puedes apoyar su desarrollo:

[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20SpecLeap-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/specleap)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-Support%20SpecLeap-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/specleap)

Las donaciones nos ayudan a:
- ✅ Mantener el framework actualizado
- ✅ Desarrollar nuevas features
- ✅ Mejorar documentación
- ✅ Crear más Agent Skills
- ✅ Soporte a la comunidad

---

## 📜 Licencia

MIT License - Ver [LICENSE](LICENSE)

---

## 🤝 Contribuciones

¡Contribuciones bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una branch (`git checkout -b feature/nueva-feature`)
3. Commit tus cambios (`git commit -am 'Add nueva feature'`)
4. Push a la branch (`git push origin feature/nueva-feature`)
5. Abre un Pull Request

---

## 🔗 Enlaces

- 🌐 **Website:** [specleap.com](https://specleap.com)
- 📦 **GitHub:** [github.com/iapanderson/specleap](https://github.com/iapanderson/specleap-framework)
- 💬 **Comunidad:** (próximamente Discord/Slack)
- 📧 **Contacto:** [Abrir Issue en GitHub](https://github.com/iapanderson/specleap-framework/issues)

---

**Hecho con ❤️ por la comunidad SpecLeap**
