# 📝 Changelog — SpecLeap

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

---

## [Unreleased]

### Añadido
- Instalador con selección de idioma (ES/EN)
- Sistema i18n completo
- Donaciones via Ko-fi y Buy Me a Coffee

---

## [1.0.0] - 2026-02-12

### 🎉 Lanzamiento Inicial

Primera versión completa de SpecLeap con workflow end-to-end implementado.

### Añadido

#### CLI Ejecutable
- **10 comandos implementados:**
  - `openspec` — Dispatcher principal
  - `enrich` — Refinar user stories con AI
  - `new` — Crear propuestas de cambio
  - `ff` — Fast-forward (generación con AI)
  - `apply` — Aplicar propuesta (branch + delta specs)
  - `verify` — Verificar tests y specs
  - `code-review` — Solicitar review
  - `archive` — Archivar propuesta completada
  - `report` — Generar testing report
  - `status` — Ver estado de propuestas

- **Helper scripts:**
  - `common.sh` — Funciones compartidas (Git, validación, parsing)

- **Documentación CLI:**
  - `openspec/cli/README.md` — Guía de uso
  - `openspec/cli/COMMAND_REFERENCE.md` — Referencia completa de comandos

#### Metodología SDD
- **5 archivos de reglas para AI assistants:**
  - `rules/development-rules.md` — Metodología base
  - `rules/spec-format.md` — Formato de specs
  - `rules/code-standards.md` — Estándares de código
  - `rules/git-workflow.md` — Workflow Git
  - `rules/testing-protocol.md` — Testing obligatorio

- **Soporte multi-IDE:**
  - Claude Code (`AGENTS.md`, `CLAUDE.md`)
  - Cursor (`.cursorrules`)
  - Continue (`.continuerules`)
  - Cline (`.clinerules`)
  - Gemini (`GEMINI.md`)

#### Estructura OpenSpec
- **Directorios:**
  - `openspec/specs/` — Source of truth (4 dominios)
  - `openspec/changes/` — Propuestas de cambio
  - `openspec/templates/` — Templates (proposal, design, tasks)
  - `openspec/examples/` — Ejemplos completos

- **Configuración:**
  - `openspec/config.yaml` — Estados, IDs, integraciones (Jira, CodeRabbit)

#### Ejemplo Completo
- **CHANGE-SAMPLE-001: Autenticación JWT**
  - User story original → refinada
  - Proposal completo (QUÉ y POR QUÉ)
  - Design técnico (arquitectura, API, ADRs, seguridad)
  - Tasks desglosadas (12 tareas, estimaciones, dependencias)
  - Testing Report real (60 tests, 91% coverage)
  - Delta specs (funcional + técnica)
  - README con guía end-to-end

#### Documentación
- **README.md** — Documentación principal
- **SETUP.md** — Guía de instalación y configuración
- **openspec/examples/MERMAID_DIAGRAMS.md** — Guía de diagramas Mermaid
- **openspec/examples/README.md** — Índice de ejemplos

#### VSCode Integration
- **`.vscode/settings.json`** — Configuración de Markdown preview
- **`.vscode/markdown.css`** — CSS personalizado para docs
- **`.vscode/extensions.json`** — Extensiones recomendadas

#### Soporte de Diagramas
- **Mermaid integration:**
  - Flowcharts (flujos de proceso)
  - Sequence diagrams (interacciones)
  - Class diagrams (arquitectura)
  - State diagrams (estados)
  - ER diagrams (modelo de datos)
  - Gantt charts (planificación)

- **3 diagramas en CHANGE-SAMPLE-001:**
  - Diagrama de componentes (flowchart coloreado)
  - Diagrama de secuencia de login (detallado)
  - Diagrama de dependencias de tareas (con leyenda)

#### Integraciones
- **Test Frameworks:**
  - PHPUnit (auto-detección)
  - Jest (auto-detección)

- **Code Review:**
  - CodeRabbit (configuración + documentación)

- **Task Management:**
  - Asana (opcional)
  - Jira (opcional)

### Características

#### Workflow Completo
- ✅ Refinamiento de user stories con AI
- ✅ Creación de propuestas estructuradas
- ✅ Generación automática con AI (fast-forward)
- ✅ Aplicación de delta specs
- ✅ Verificación automática de tests + coverage
- ✅ Testing report automation
- ✅ Archivado con completion report

#### Delta Specs
- Specs temporales en `changes/CHANGE-XXX/specs/`
- Aplicación automática a `specs/` source of truth
- Preserva historial (Git)

#### Testing Report Automation
- Detección automática de PHPUnit/Jest
- Parsing de resultados y coverage
- Actualización automática en `tasks.md`
- Formatos: markdown, JSON, text

#### Preview Profesional
- Custom CSS para markdown
- Diagramas Mermaid renderizados
- Responsive design
- Exportar a PDF/HTML

---

## [0.1.0] - 2026-02-11

### Añadido

#### Estructura Inicial
- Estructura base de directorios
- Templates de propuestas
- Configuración YAML
- Reglas para AI assistants

---

## Tipos de Cambios

- **Añadido** — Nuevas features
- **Cambiado** — Cambios en funcionalidad existente
- **Deprecado** — Features que serán removidas
- **Removido** — Features eliminadas
- **Corregido** — Corrección de bugs
- **Seguridad** — Vulnerabilidades corregidas
