# Agent Skills — Repositorios Reales en GitHub

## Cómo Funcionan las Agent Skills

1. **Son carpetas** con archivos `SKILL.md`
2. **Se almacenan** en `~/.skills/` (o donde el editor las busque)
3. **Se instalan** clonando repos de GitHub y copiando las carpetas
4. **Se usan** en VSCode, Claude Code, Cursor, etc.

---

## Repositorios Verificados

### 1. obra/superpowers
**URL:** https://github.com/obra/superpowers  
**Descripción:** An agentic skills framework & software development methodology

**Skills disponibles:**
- `verification-before-completion` ⭐ (CRÍTICA)
- `systematic-debugging`
- `test-driven-development`
- `brainstorming`
- `writing-plans`
- `executing-plans`
- `requesting-code-review`
- `receiving-code-review`
- `dispatching-parallel-agents`
- `subagent-driven-development`
- Y más...

**Instalación:**
```bash
git clone https://github.com/obra/superpowers.git
cp -r superpowers/verification-before-completion ~/.skills/
```

---

### 2. jeffallan/claude-skills
**URL:** https://github.com/jeffallan/claude-skills  
**Descripción:** 66 Specialized Skills for Full-Stack Developers

**Skills relevantes:**
- `laravel-specialist` ⭐
- `flutter-expert`
- `golang-pro`
- Y 63 más...

**Instalación:**
```bash
git clone https://github.com/jeffallan/claude-skills.git
cp -r claude-skills/laravel-specialist ~/.skills/
```

---

### 3. wshobson/agents
**URL:** https://github.com/wshobson/agents  
**Descripción:** Agent skills collection

**Skills probables:**
- `tailwind-design-system`
- `api-design-principles`
- `code-review-excellence`
- `postgresql-table-design`
- `error-handling-patterns`
- Y más...

**Instalación:**
```bash
git clone https://github.com/wshobson/agents.git
cp -r agents/<skill-name> ~/.skills/
```

---

### 4. anthropics/skills
**URL:** https://github.com/anthropics/skills  
**Descripción:** Official Anthropic skills repository

**Skills disponibles:**
- `frontend-design`
- `pdf`
- `docx`
- `pptx`
- `xlsx`
- `mcp-builder`
- `skill-creator`
- Y más...

---

### 5. vercel-labs/agent-skills
**URL:** https://github.com/vercel-labs/agent-skills  
**Descripción:** Vercel agent skills

**Skills relevantes:**
- `vercel-react-best-practices`
- `web-design-guidelines`
- `vercel-composition-patterns`

---

## Script de Instalación Completo

```bash
#!/bin/bash
# install-skills.sh

SKILLS_DIR="${HOME}/.skills"
mkdir -p "${SKILLS_DIR}"

# Clonar repos
TMP="/tmp/skills-install"
mkdir -p "$TMP"

# obra/superpowers
git clone https://github.com/obra/superpowers.git "$TMP/superpowers"
cp -r "$TMP/superpowers/verification-before-completion" "$SKILLS_DIR/"
cp -r "$TMP/superpowers/systematic-debugging" "$SKILLS_DIR/"
cp -r "$TMP/superpowers/test-driven-development" "$SKILLS_DIR/"

# jeffallan/claude-skills
git clone https://github.com/jeffallan/claude-skills.git "$TMP/claude-skills"
cp -r "$TMP/claude-skills/laravel-specialist" "$SKILLS_DIR/"

# wshobson/agents (verificar estructura primero)
git clone https://github.com/wshobson/agents.git "$TMP/agents"
# Copiar skills según estructura del repo

# anthropics/skills
git clone https://github.com/anthropics/skills.git "$TMP/anthropics"
cp -r "$TMP/anthropics/skills/frontend-design" "$SKILLS_DIR/"

# vercel-labs/agent-skills
git clone https://github.com/vercel-labs/agent-skills.git "$TMP/vercel"
cp -r "$TMP/vercel/vercel-react-best-practices" "$SKILLS_DIR/"
cp -r "$TMP/vercel/web-design-guidelines" "$SKILLS_DIR/"

# Cleanup
rm -rf "$TMP"

echo "✅ Skills instaladas en $SKILLS_DIR"
```

---

## Verificar Instalación

```bash
# Listar skills instaladas
ls -la ~/.skills/

# Ver una skill específica
cat ~/.skills/verification-before-completion/SKILL.md
```

---

## Siguiente Paso

1. **Investigar estructura** de cada repo (qué carpetas son skills)
2. **Crear script definitivo** con las 20 skills confirmadas
3. **Testear** en VSCode/Claude Code

¿Quieres que clone los repos y vea la estructura real ahora?
