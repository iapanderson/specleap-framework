---
name: SDD Methodology - Spec-Driven Development
alwaysApply: true
description: Metodología principal de desarrollo basada en especificaciones
---

# Spec-Driven Development (SDD)

## Principio Fundamental
> **Primero la especificación, luego el código. Nunca al revés.**

## Flujo de Trabajo

```
USER STORY → REFINED STORY → PROPOSAL → IMPLEMENTATION → VERIFICATION → DELIVERY
```

## Fases del Desarrollo

### Fase 1: Discovery
- Analizar requisitos y alcance
- Documentar en `project-brief.md`
- Investigar arquitectura

### Fase 2: Especificación
- Crear spec en `openspec/specs/<domain>/`
- Usar formato GIVEN/WHEN/THEN para escenarios
- Cada feature tiene spec ANTES de codificar

### Fase 3: Propuesta de Cambio
- Crear carpeta en `openspec/changes/CHANGE-XXXX-nombre/`
- Incluir: proposal.md, design.md, tasks.md
- Documentar delta specs

### Fase 4: Implementación
- Crear branch desde develop
- Implementar según spec
- Escribir tests (unit + integration)
- Documentar cambios

### Fase 5: Verificación
- Ejecutar todos los tests
- Generar Testing Report
- Code review OBLIGATORIO
- Resolver comentarios

### Fase 6: Entrega
- Merge a develop/main
- Actualizar spec → "implemented"
- Archivar propuesta

## Reglas Importantes

1. **Sin spec no hay código** - Siempre crear/actualizar spec antes de implementar
2. **Testing Report obligatorio** - Cada feature documenta sus tests
3. **Code review obligatorio** - Ningún PR se mergea sin review
4. **Documentación en español** - Código en inglés, docs en español
