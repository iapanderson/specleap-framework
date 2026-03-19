# OpenSpec — DevFlow Pro

Sistema de especificaciones para Spec-Driven Development (SDD).

## Estructura

```
openspec/
├── specs/                      # 📋 Source of Truth
│   ├── functional/             # Specs funcionales
│   ├── technical/              # Specs técnicas
│   ├── integration/            # Specs de integración
│   └── security/               # Specs de seguridad
│
├── changes/                    # 📝 Propuestas de cambios
│   └── CHANGE-XXXX-nombre/
│       ├── proposal.md         # QUÉ y POR QUÉ
│       ├── design.md           # CÓMO (técnico)
│       ├── tasks.md            # Tareas + Testing Report
│       └── specs/              # Delta specs
│
├── templates/                  # 📄 Plantillas
│   ├── proposal.md
│   ├── design.md
│   ├── tasks.md
│   └── .coderabbit.yaml        # Config para repos
│
├── config.yaml                 # ⚙️ Configuración
└── README.md                   # Este archivo
```

## Flujo de Trabajo

```
USER STORY → /enrich → REFINED US → /new + /ff → PROPOSAL ARTIFACTS
                                                       ↓
                                                    /apply
                                                       ↓
                       BRANCH + TESTS + DOCS + CODE + TESTING REPORT
                                                       ↓
                                               /verify + /archive
                                                       ↓
                       /commit → FEATURE READY → /code-review → PR → PUBLISHED
```

## Comandos

| Comando | Acción |
|---------|--------|
| `/enrich` | Refinar user story |
| `/new` | Crear propuesta de cambio |
| `/ff` | Fast-forward (generar rápido) |
| `/apply` | Implementar propuesta |
| `/verify` | Verificar tests y spec |
| `/code-review` | Review con CodeRabbit (OBLIGATORIO) |
| `/archive` | Archivar propuesta completada |

## Crear Nueva Propuesta

1. Crear carpeta: `changes/CHANGE-XXXX-nombre/`
2. Copiar plantillas desde `templates/`
3. Completar `proposal.md` (qué y por qué)
4. Completar `design.md` (cómo técnicamente)
5. Desglosar tareas en `tasks.md`
6. Si modifica specs existentes, crear delta en `specs/`

## CodeRabbit

CodeRabbit es **obligatorio** para todos los PRs.

### Setup en nuevo repositorio:

```bash
cp openspec/templates/.coderabbit.yaml .coderabbit.yaml
```

### Características activadas:
- Profile: `assertive` (reviews rigurosos)
- Idioma: español
- Pre-merge checks: title, spec reference, testing report
- Request changes workflow: activado
- Herramientas: ESLint, PHPStan, Gitleaks, Semgrep, etc.

## Testing Report

Cada PR debe incluir en `tasks.md`:

```markdown
## Testing Report

| Suite | Tests | Passed | Failed | Coverage |
|-------|-------|--------|--------|----------|
| Unit | 45 | 45 | 0 | 87% |
| Integration | 12 | 12 | 0 | N/A |

### CodeRabbit Status
- ✅ Review aprobado
```

## Referencias

- Metodología: AGENTS.md
- Configuración: config.yaml
- Plantillas: templates/
