# SpecLeap — Setup & Installation Guide

Guía completa para configurar SpecLeap en tu entorno de desarrollo.

---

## 📋 Prerequisitos

### Software Requerido

- **Git** — Control de versiones
- **Node.js** — v20.x LTS o superior (para cliente npms)
- **npm** o **pnpm** — Gestor de paquetes Node.js

### Opcional (según stack del proyecto)

- **PHP 8.3+** — Para proyectos Laravel
- **Composer** — Gestor de dependencias PHP
- **PostgreSQL** o **MySQL** — Base de datos
- **Docker** — Para entornos containerizados

---

## 🚀 Instalación Básica

### Paso 1: Clonar Repositorio

```bash
git clone https://github.com/iapanderson/specleap-framework.git
cd specleap/
```

### Paso 2: Ejecutar Instalador

```bash
chmod +x install.sh
./install.sh
```

El instalador:
- Te permite seleccionar idioma (Español/English)
- Crea `.specleap/config.json` con tu preferencia
- Configura traducciones automáticas
- Hace ejecutables todos los scripts

### Paso 3: Verificar Estructura

```bash
ls -la

# Deberías ver:
# .agents/
# .commands/
# proyectos/
# openspec/
# CLAUDE.md
# README.md
# etc.
```

### Paso 4: Instalar Git Hooks (Validación Automática)

**IMPORTANTE:** Instala git hooks para validación automática antes de cada commit.

```bash
cd tu-proyecto
bash scripts/install-git-hooks.sh
```

**Qué hace:**
- ✅ Valida linters antes de cada commit
- ✅ Valida formatters (Prettier, PHP-CS-Fixer)
- ✅ Previene commits con código debug (console.log, var_dump)
- ✅ Previene modificación de CONTRATO.md (es inmutable)
- ⚡ Rápido (<5 segundos)

**Resultado:**
```
git commit -m "feat: add login"
→ 🔍 SpecLeap: Validando commit...
→   ✓ ESLint: OK
→   ✓ Prettier: OK
→   ✓ PHPStan: OK
→ ✅ Validación pre-commit exitosa
```

**Si falla:** El commit es rechazado y muestra errores a corregir.

**Para saltarte (NO recomendado):**
```bash
git commit --no-verify -m "mensaje"
```

---

### Paso 5: Listo para Usar

Abre el proyecto en tu IDE favorito:

```bash
code .        # VSCode
cursor .      # Cursor
```

Di **"Hola"** en el chat con tu asistente de IA y empieza a trabajar.

---

## 🔌 Configurar Asana (Recomendado)

### ¿Por Qué Asana?

SpecLeap usa Asana para gestión de backlog porque:
- ✅ API robusta y bien documentada
- ✅ Cliente oficial npm (`asana`)
- ✅ Gratis para equipos pequeños
- ✅ Integración automática con comandos `planificar`

### Setup Rápido con Script

```bash
cd specleap
bash scripts/setup-mcp.sh
```

Este script instala automáticamente:
- ✅ Cliente Asana (`asana` npm package)
- ✅ 20 Agent Skills TIER 1
- ✅ Context7 MCP (opcional)

### Setup Manual (Alternativa)

Si prefieres configurar manualmente:

#### 1. Instalar Cliente Asana

```bash
npm install -g asana
```

#### 2. Obtener Token de Asana

1. Ve a [app.asana.com/0/my-apps](https://app.asana.com/0/my-apps)
2. Click en **"Create new token"**
3. Nombre: `SpecLeap Integration`
4. Copia el token (empieza con `0/`)

#### 3. Obtener Workspace ID

```bash
# Con el token, lista tus workspaces
curl -H "Authorization: Bearer TU_TOKEN_ASANA" \
     https://app.asana.com/api/1.0/workspaces

# Copia el "gid" de tu workspace
```

#### 4. Configurar Variables de Entorno

Edita `.env` en la raíz de SpecLeap:

```bash
# Asana Configuration
ASANA_TOKEN="0/1234567890abcdef..."
ASANA_WORKSPACE_GID="1234567890123456"
ASANA_EMAIL="tu-email@example.com"
```

#### 5. Verificar Configuración

```bash
# Test con CLI
openspec config show

# Debería mostrar:
# ✅ Asana Token: 0/12345... (ocultado)
# ✅ Workspace: Mi Workspace (ID: 123...)
```

---

## ⭐ Agent Skills (CRÍTICO para Calidad)

### ¿Qué son las Agent Skills?

Agent Skills son **extensiones especializadas** para Claude/Cursor/Continue que:
- ✅ Aplican best practices automáticamente
- ✅ Validan seguridad (OWASP Top 10)
- ✅ Sugieren arquitecturas profesionales
- ✅ Revisan código antes de completar tareas

### Instalación Automática (Recomendado)

```bash
cd specleap
bash scripts/setup-mcp.sh
```

Este script instala **20 skills TIER 1** en `~/.skills/`:

#### 🔒 Seguridad (5)
1. `sast-config` — Static analysis security testing
2. `stride-threat` — STRIDE threat modeling
3. `security-extraction` — Extraer reqs de seguridad
4. `backend-security` — Backend/API security patterns
5. `frontend-security` — Frontend/Mobile security

#### 🔄 Consistencia (3)
6. `verification-before-completion` ⭐ **CRÍTICO** — Valida antes de decir "completo"
7. `code-review` — Code review excellence
8. `debugging` — Systematic debugging

#### 🎨 Diseño/Frontend (6)
9. `web-design-vercel` — Estilo Vercel/Linear profesional
10. `frontend-anthropic` — Frontend design Anthropic
11. `ui-ux-pro` — UI/UX patterns avanzados
12. `tailwind-system` — Tailwind design system
13. `shadcn-components` — shadcn/ui integration
14. `responsive-design` — Mobile-first responsive

#### 🛠️ Backend/Dev (6)
15. `laravel-specialist` — Laravel best practices
16. `react-best` — React patterns y optimization
17. `tdd` — Test-driven development
18. `api-design` — REST/GraphQL principles
19. `postgres-design` — PostgreSQL schema design
20. `error-handling` — Error handling patterns

### Instalación Manual

Si `setup-mcp.sh` falla, instala manualmente:

```bash
cd ~/.skills
git clone https://github.com/obra/superpowers
git clone https://github.com/jeffallan/claude-skills
git clone https://github.com/anthropics/skills

# Verifica
ls -la ~/.skills/
```

### Verificar Skills Activas

En tu IDE (Cursor/Continue/VSCode):

1. Abre panel de configuración
2. Busca "Agent Skills" o "MCP Servers"
3. Deberías ver las 20 skills listadas

### TIER 2 Skills (Opcional)

Para proyectos avanzados, considera instalar:

- `oauth-patterns` — OAuth 2.0 / OpenID Connect
- `microservices-arch` — Microservices design
- `graphql-optimization` — GraphQL N+1 prevention
- `redis-caching` — Redis caching strategies
- `docker-compose` — Multi-container orchestration

**Instalación:**

```bash
cd ~/.skills
git clone https://github.com/<repo-tier2>
```

---

## 🎯 Primer Proyecto

### Opción 1: Cuestionario Interactivo (Recomendado)

```bash
cd specleap

# Ejecuta el cuestionario de 56 preguntas
./scripts/generate-contrato.sh
```

Te hará preguntas sobre:
- Información del proyecto (nombre, responsable)
- Objetivo y problema que resuelve
- Público objetivo y casos de uso
- Stack tecnológico (backend, frontend, DB)
- Funcionalidades core y secundarias
- Sistema de usuarios y roles
- Diseño (colores, estilo visual)
- Arquitectura y patrones
- Seguridad (GDPR, datos sensibles)
- Rendimiento y testing
- Restricciones (plazo, presupuesto)

**Tiempo:** 15-20 minutos

**Resultado:** `proyectos/<tu-proyecto>/CONTRATO.md` generado automáticamente.

### Opción 2: Template Manual

```bash
cd proyectos
cp -r _template mi-proyecto
cd mi-proyecto

# Edita CONTRATO.md manualmente
nano CONTRATO.md
```

### Opción 3: Adoptar Proyecto Existente

Si ya tienes código y quieres "specleapificarlo":

```bash
cd mi-proyecto-existente

# En chat con Claude/Cursor:
adoptar

# El agente:
# 1. Analiza el código existente
# 2. Extrae arquitectura y decisiones
# 3. Genera CONTRATO retroactivo
# 4. Crea context/ con hallazgos
```

---

## 🎮 Workflow Diario

### 1. Iniciar Sesión de Trabajo

```bash
cd specleap/proyectos/mi-proyecto
code .
```

### 2. Comandos Conversacionales

En el chat con Claude/Cursor:

```
refinar "añadir notificaciones push"
→ Analiza viabilidad
→ Genera propuesta de cambio
→ Valida contra CONTRATO

planificar
→ Lee CONTRATO
→ Genera backlog Asana
→ Crea user stories

implementar "login con Google"
→ Verifica si está en CONTRATO
→ Lee context/ para contexto
→ Genera código + tests

documentar "API de usuarios"
→ Genera OpenAPI/Swagger
→ Actualiza README técnico
```

### 3. CLI Formal (Opcional)

Para workflows con aprobación formal:

```bash
# Proponer cambio
openspec new "añadir carrito de compras"

# Revisar propuesta
openspec show 001-carrito

# Aprobar
openspec approve 001-carrito

# Implementar
# (chat con Claude: implementar "carrito de compras")

# Verificar
openspec verify 001-carrito
```

---

## 🛠️ Configuración Avanzada

### Context7 MCP (Docs Actualizadas)

Context7 provee documentación actualizada de librerías en tiempo real.

```bash
npm install -g @context7/mcp-server

# Configurar en claude_desktop_config.json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

**Uso:**

```
# En chat con Claude
"¿Cómo uso Laravel 11 Filament?"
→ Context7 busca docs oficiales
→ Claude responde con info actualizada
```

### CodeRabbit (Code Review Automático)

Si tienes cuenta GitHub Pro:

```bash
# Copiar config
cp .coderabbit.yaml tu-proyecto/.coderabbit.yaml
git add .coderabbit.yaml
git commit -m "Add CodeRabbit config"

# Push a GitHub
git push origin main
```

CodeRabbit revisará automáticamente tus PRs.

### Git Hooks (Pre-commit)

```bash
# Instalar pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Verifica que CONTRATO.md no haya cambiado
if git diff --cached --name-only | grep -q "CONTRATO.md"; then
  echo "❌ ERROR: No puedes modificar CONTRATO.md directamente"
  echo "   Usa 'refinar' o 'openspec new' para proponer cambios"
  exit 1
fi
EOF

chmod +x .git/hooks/pre-commit
```

---

## 📚 Recursos Adicionales

### Documentación

- 📖 [README.md](README.md) — Overview del framework
- 💬 [docs/COMANDOS.md](docs/COMANDOS.md) — Comandos conversacionales
- 🛠️ [docs/CLI-OPENSPEC.md](docs/CLI-OPENSPEC.md) — CLI formal
- 🤖 [docs/AGENTES.md](docs/AGENTES.md) — Agentes especializados
- ⭐ [docs/SKILLS-REFERENCE.md](docs/SKILLS-REFERENCE.md) — Quick reference skills
- 🎯 [docs/SPEC-CUESTIONARIO-INTERACTIVO.md](docs/SPEC-CUESTIONARIO-INTERACTIVO.md) — Sistema 56 preguntas

### Ejemplos

Ver `proyectos/_template/` para estructura modelo.

### Comunidad

- 🐛 **Issues:** [github.com/iapanderson/specleap/issues](https://github.com/iapanderson/specleap-framework/issues)
- 💬 **Discusiones:** (próximamente Discord/Slack)

---

## 🆘 Troubleshooting

### "Command not found: openspec"

```bash
# Asegúrate de estar en el directorio specleap
cd specleap

# Verifica que openspec/bin/openspec existe
ls -la openspec/bin/openspec

# Hazlo ejecutable
chmod +x openspec/bin/openspec

# Usa ruta relativa
./openspec/bin/openspec --version
```

### "No encuentro .env"

```bash
# Copia el template
cp .env.example .env

# Edita con tus valores
nano .env
```

### "Agent Skills no aparecen"

1. Verifica instalación:
```bash
ls -la ~/.skills/
```

2. Reinicia tu IDE (Cursor/Continue/VSCode)

3. Revisa configuración MCP:
```bash
cat ~/.config/claude/claude_desktop_config.json
```

### "Error al generar backlog Asana"

1. Verifica token:
```bash
echo $ASANA_TOKEN
# Debe empezar con "0/"
```

2. Test API:
```bash
curl -H "Authorization: Bearer $ASANA_TOKEN" \
     https://app.asana.com/api/1.0/users/me
```

3. Verifica permisos del token (debe poder crear tareas/proyectos)

---

## ✅ Checklist de Setup Completo

- [ ] Git instalado y configurado (user.name, user.email)
- [ ] Node.js 20+ instalado
- [ ] SpecLeap clonado y `install.sh` ejecutado
- [ ] `.env` configurado con Asana token + workspace
- [ ] 20 Agent Skills TIER 1 instaladas en `~/.skills/`
- [ ] Context7 MCP instalado (opcional)
- [ ] Primer proyecto creado con cuestionario o template
- [ ] Comando `"Hola"` ejecutado en IDE para validar setup

---

**¡Listo para construir software de calidad spec-first! 🚀**
