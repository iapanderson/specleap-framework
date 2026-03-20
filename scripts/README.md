# SpecLeap Scripts

Colección de scripts de automatización para SpecLeap.

---

## 📋 Scripts Disponibles

### `install-git-hooks.sh`

**Propósito:** Instalar git hooks de validación automática en proyectos

**Uso:**
```bash
# Desde la raíz del proyecto
bash scripts/install-git-hooks.sh

# O especificando ruta
bash scripts/install-git-hooks.sh /path/to/proyecto
```

**Qué instala:**
- **Pre-commit hook** — Validación rápida antes de cada commit

**Validaciones incluidas:**
- ✅ Sintaxis PHP (php -l)
- ✅ ESLint (JS/TS)
- ✅ Prettier (formateo)
- ✅ PHPStan (análisis estático PHP)
- ✅ PHP-CS-Fixer (estilo PHP)
- ✅ CONTRATO.md no se modifica (es inmutable)
- ✅ No hay TODOs críticos
- ✅ No hay código debug (console.log, var_dump, dd())

**Tiempo de ejecución:** <5 segundos

**Saltarse validación (NO recomendado):**
```bash
git commit --no-verify -m "mensaje"
```

---

### `setup-mcp.sh`

**Propósito:** Instalación rápida de dependencias SpecLeap

**Uso:**
```bash
bash scripts/setup-mcp.sh
```

**Instala:**
- ✅ Cliente Asana (npm global)
- ✅ 20 Agent Skills TIER 1
- ✅ Context7 MCP (opcional)

**Tiempo:** ~5 minutos

---

### `install-skills.sh`

**Propósito:** Instalar Agent Skills manualmente

**Uso:**
```bash
bash scripts/install-skills.sh
```

**Instala:** 20 Agent Skills TIER 1 en `~/.skills/`

**Skills incluidas:**
- 5 skills de seguridad (SAST, STRIDE, OWASP)
- 3 skills de consistencia (verification-before-completion, DRY)
- 6 skills de diseño (Vercel-style, Tailwind, shadcn/ui)
- 6 skills de backend/dev (Laravel, React, TDD, API design)

---

## 🔧 Troubleshooting

### Git hooks no se ejecutan

**Causa:** Permisos incorrectos

**Solución:**
```bash
chmod +x .git/hooks/pre-commit
```

### ESLint no encontrado

**Solución:**
```bash
npm install -D eslint
# o globalmente
npm install -g eslint
```

### PHPStan no encontrado

**Solución:**
```bash
composer require --dev phpstan/phpstan
# o globalmente
composer global require phpstan/phpstan
```

### Hook muy lento

**Causa:** Demasiados archivos staged

**Solución:** Commit en batches más pequeños
```bash
git add archivo1.js
git commit -m "feat: archivo 1"
git add archivo2.js
git commit -m "feat: archivo 2"
```

---

## 📚 Referencias

- **Git Hooks:** https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
- **ESLint:** https://eslint.org
- **PHPStan:** https://phpstan.org
- **PHP-CS-Fixer:** https://cs.symfony.com
