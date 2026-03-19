# Agent Skills Reference — SpecLeap

**Última actualización:** 2026-02-21

---

## Quick Reference

**Instaladas:** 20 skills TIER 1 (si ejecutaste `setup-mcp.sh` con "sí")  
**Ubicación:** `~/.skills/`  
**Activación:** Automática según contexto  
**Directorio:** https://skills.sh

---

## TIER 1 (20 Skills Esenciales)

### 🔒 Seguridad (5 skills)

| Skill | Cuándo se Activa | Qué Hace |
|-------|------------------|----------|
| **sast-configuration** | Al configurar análisis estático | Configura SAST tools (SonarQube, Semgrep) |
| **stride-analysis-patterns** | Al hacer threat modeling | Aplica metodología STRIDE (Spoofing, Tampering, etc.) |
| **security-requirement-extraction** | Al generar CONTRATO.md | Extrae requisitos de seguridad desde threat models |
| **backend-api-security** | Al crear endpoints API | Auth, rate limiting, validation, SQL injection prevention |
| **frontend-mobile-security** | Al crear componentes | XSS/CSRF prevention, secure storage, input sanitization |

**Ejemplo:**
```
User: "Crear API /api/users con autenticación JWT"

Skills activadas:
  ✓ backend-api-security → Valida JWT, rate limiting, CSRF
  ✓ security-requirement-extraction → Define requisitos de seguridad
```

---

### 🔄 Consistencia & Calidad (3 skills)

| Skill | Cuándo se Activa | Qué Hace |
|-------|------------------|----------|
| **verification-before-completion** ⭐ | **SIEMPRE** antes de crear código | Verifica código existente, busca duplicación, lee conventions.md |
| **code-review-excellence** | Al hacer PR o code review | Review exhaustivo: duplicación, tests, security, conventions |
| **systematic-debugging** | Al debuggear | Análisis sistemático antes de modificar código |

**Ejemplo (CRÍTICO):**
```
User: "Crear función formatCurrency()"

verification-before-completion:
  1. Busca "format" en codebase
  2. Encuentra "formatPrice()" existente
  3. DETIENE creación
  4. Pregunta: "Ya existe formatPrice(), ¿usamos esa o necesitas algo diferente?"
```

**Sin esta skill:** Crea `formatCurrency()` duplicando `formatPrice()` ❌

---

### 🎨 Diseño & Frontend (6 skills)

| Skill | Cuándo se Activa | Qué Hace |
|-------|------------------|----------|
| **web-design-guidelines** | Al diseñar UI web | Guías de diseño profesional (estilo Vercel) |
| **frontend-design** | Al crear componentes | Diseño frontend moderno (Anthropic standards) |
| **ui-ux-pro-max** | Al diseñar experiencias | UX profesional con micro-interacciones |
| **tailwind-design-system** | Al usar Tailwind CSS | Design systems coherentes con Tailwind |
| **shadcn-ui** | Al usar shadcn/ui | Componentes shadcn/ui profesionales |
| **responsive-design** | Al crear layouts | Responsive mobile-first (CSS Grid, Flexbox) |

**Ejemplo:**
```
User: "Diseñar dashboard con cards de métricas"

Skills activadas:
  ✓ web-design-guidelines → Paleta profesional, spacing consistente
  ✓ tailwind-design-system → Design tokens, 4px grid
  ✓ responsive-design → Mobile-first, breakpoints correctos
  ✓ ui-ux-pro-max → Micro-interacciones en hover
```

**Resultado:** Dashboard estilo Vercel/Linear, no Bootstrap genérico.

---

### 🛠️ Backend & Development (6 skills)

| Skill | Cuándo se Activa | Qué Hace |
|-------|------------------|----------|
| **laravel-specialist** | Al trabajar con Laravel | Best practices Laravel 11+ (Eloquent, Middleware, Validation) |
| **vercel-react-best-practices** | Al trabajar con React | Best practices React 18+ (hooks, RSC, performance) |
| **test-driven-development** | Al escribir tests | TDD methodology: Red → Green → Refactor |
| **api-design-principles** | Al diseñar APIs | REST/GraphQL best practices (versioning, pagination, HATEOAS) |
| **postgresql-table-design** | Al diseñar BD | Schema design, indexes, constraints, normalization |
| **error-handling-patterns** | Al manejar errores | Error handling robusto (Result types, exceptions, logging) |

**Ejemplo:**
```
User: "planificar SCRUM-23 backend"

Skills activadas:
  ✓ laravel-specialist → Estructura Laravel correcta
  ✓ api-design-principles → Diseño REST endpoints
  ✓ postgresql-table-design → Schema products table
  ✓ test-driven-development → Tests >= 90% coverage
  ✓ error-handling-patterns → Validation errors bien manejados
```

**Resultado:** Plan de implementación profesional, completo, listo para `implementar`.

---

## Cómo Funcionan

### Progressive Disclosure

Las skills NO cargan todo el conocimiento en contexto de inmediato. Usan 3 niveles:

1. **Metadata** (siempre cargado):
   - Nombre de la skill
   - Criterios de activación ("Use when...")

2. **Instructions** (se cargan al activar):
   - Guías principales
   - Best practices
   - Patterns

3. **Resources** (bajo demanda):
   - Ejemplos completos
   - Templates
   - Referencias externas

**Beneficio:** Token efficiency. Solo carga lo necesario cuando lo necesita.

### Ejemplo de Activación

```markdown
User: "Crear endpoint POST /products con validación"

1. Sistema detecta keywords: "endpoint", "POST", "validación"

2. Activa skills relevantes:
   - api-design-principles (detecta "endpoint")
   - backend-api-security (detecta "POST" + "validación")
   - laravel-specialist (contexto del proyecto)
   - verification-before-completion (SIEMPRE activo)

3. Carga Instructions de cada skill

4. Genera código usando conocimiento combinado de las 4 skills

5. Resultado: Endpoint profesional, seguro, sin duplicar código
```

---

## TIER 2 (Opcional — 10 Skills Adicionales)

Si instalaste o quieres agregar más skills:

### Infraestructura & DevOps (4)

```bash
npx skills add wshobson/agents/kubernetes-operations
npx skills add wshobson/agents/cloud-infrastructure
npx skills add wshobson/agents/cicd-automation
npx skills add wshobson/agents/deployment-strategies
```

### Marketing & SEO (3)

```bash
npx skills add coreyhaines31/marketingskills/seo-audit
npx skills add coreyhaines31/marketingskills/copywriting
npx skills add coreyhaines31/marketingskills/content-strategy
```

### Avanzado (3)

```bash
npx skills add wshobson/agents/architecture-patterns
npx skills add obra/superpowers/subagent-driven-development
npx skills add anthropics/skills/mcp-builder
```

---

## Troubleshooting

### "La IA no está usando las skills"

**Posible causa:**
1. Skills no instaladas
2. IDE no reiniciado después de instalar
3. Skills instaladas pero no en `~/.skills/`

**Solución:**
```bash
# Verificar skills instaladas
ls ~/.skills/

# Si vacío, instalar:
bash specleap/scripts/setup-mcp.sh

# Reiniciar IDE completamente
```

### "La IA duplica código (verification-before-completion no funciona)"

**Posible causa:**
1. Skill no instalada
2. Skill instalada pero IA no la activa

**Solución:**
```bash
# Verificar instalación
ls ~/.skills/ | grep verification

# Reinstalar si falta
npx skills add obra/superpowers/verification-before-completion

# Reiniciar IDE
```

### "Quiero desactivar una skill"

**Solución:**
```bash
# Eliminar skill
rm -rf ~/.skills/[skill-name]

# O renombrar temporalmente
mv ~/.skills/[skill-name] ~/.skills/[skill-name].disabled
```

---

## Ver Skills en Acción

La IA menciona qué skills está usando cuando trabaja:

```
User: "Crear componente Button con Tailwind"

IA:
"Activando skills:
  - tailwind-design-system
  - frontend-design
  - verification-before-completion

Verificando código existente...
[busca Button en components/]

No encontré Button existente. Creando...

[genera código siguiendo las 3 skills]
```

**Si NO ves esto:** Las skills probablemente NO están instaladas.

---

## Recursos

- **Directorio oficial:** https://skills.sh
- **wshobson/agents:** https://github.com/wshobson/agents (129 skills total)
- **obra/superpowers:** https://github.com/obra/superpowers (metodologías)
- **Anthropic Skills Spec:** https://github.com/anthropics/skills

---

## Instalar Skills Manualmente

Si no usaste `setup-mcp.sh`, instalar todas manualmente:

```bash
# Seguridad (5)
npx skills add wshobson/agents/sast-configuration
npx skills add wshobson/agents/stride-analysis-patterns
npx skills add wshobson/agents/security-requirement-extraction
npx skills add wshobson/agents/backend-api-security
npx skills add wshobson/agents/frontend-mobile-security

# Consistencia (3)
npx skills add obra/superpowers/verification-before-completion
npx skills add wshobson/agents/code-review-excellence
npx skills add obra/superpowers/systematic-debugging

# Diseño (6)
npx skills add vercel-labs/agent-skills/web-design-guidelines
npx skills add anthropics/skills/frontend-design
npx skills add nextlevelbuilder/ui-ux-pro-max-skill/ui-ux-pro-max
npx skills add wshobson/agents/tailwind-design-system
npx skills add giuseppe-trisciuoglio/developer-kit/shadcn-ui
npx skills add wshobson/agents/responsive-design

# Backend (6)
npx skills add jeffallan/claude-skills/laravel-specialist
npx skills add vercel-labs/agent-skills/vercel-react-best-practices
npx skills add obra/superpowers/test-driven-development
npx skills add wshobson/agents/api-design-principles
npx skills add wshobson/agents/postgresql-table-design
npx skills add wshobson/agents/error-handling-patterns
```

**Tiempo:** ~2-3 minutos

---

**Última actualización:** 2026-02-21  
**Versión SpecLeap:** 1.0.0
