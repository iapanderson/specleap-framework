# CHANGE-0001 — Rediseño-web

| Campo | Valor |
|-------|-------|
| ID | CHANGE-0001 |
| Título | Rediseño-web |
| Estado | draft |
| Autor | Pamela Anderson |
| Fecha | 2026-02-14 |
| Prioridad | high |
| Jira | N/A |

## Archivos

- [proposal.md](./proposal.md) — QUÉ y POR QUÉ
- [design.md](./design.md) — CÓMO (diseño técnico)
- [tasks.md](./tasks.md) — Tareas y Testing Report
- specs/ — Delta specs (si aplica)

## Próximos Pasos

1. Completar `proposal.md` (contexto, problema, solución, alcance)
2. Completar `design.md` (arquitectura, API, datos, seguridad)
3. Desglosar tareas en `tasks.md`
4. Crear delta specs si modifica specs existentes
5. Solicitar aprobación: `openspec verify CHANGE-0001`
6. Implementar: `openspec apply CHANGE-0001`

## Comandos

```bash
# Fast-forward: generar propuesta completa con AI
openspec ff CHANGE-0001

# Aplicar propuesta (crear branch, implementar)
openspec apply CHANGE-0001

# Verificar tests y specs
openspec verify CHANGE-0001

# Code review
openspec code-review CHANGE-0001

# Archivar al completar
openspec archive CHANGE-0001
```
