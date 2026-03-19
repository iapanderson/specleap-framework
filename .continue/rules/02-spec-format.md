---
name: OpenSpec Format
globs: ["**/openspec/**/*.md", "**/*.spec.md"]
alwaysApply: false
description: Formato estándar para especificaciones OpenSpec
---

# Formato de Especificaciones

## Estructura de Archivo Spec

```markdown
# [SPEC-XXX] Nombre de la Especificación

| Campo | Valor |
|-------|-------|
| ID | SPEC-XXX |
| Versión | 1.0.0 |
| Estado | draft / review / approved / implemented |
| Prioridad | critical / high / medium / low |
| Proyecto | nombre-proyecto |

## Descripción
Qué hace este componente/feature

## Requisitos

### Requirement: Nombre del requisito
- The system SHALL [obligatorio].
- The system SHOULD [recomendado].
- The system MAY [opcional].

## Escenarios

### Scenario: Nombre del escenario
- GIVEN [precondición]
- WHEN [acción]
- THEN [resultado]
- AND [resultado adicional]

## Criterios de Aceptación
- [ ] CA-01: ...
- [ ] CA-02: ...

## Dependencias
| Tipo | Spec ID | Descripción |
|------|---------|-------------|
| Depende de | SPEC-XXX | Razón |

## Notas Técnicas
Decisiones de implementación, restricciones, etc.
```

## Palabras Clave RFC-2119

- `SHALL` = obligatorio (MUST)
- `SHOULD` = recomendado
- `MAY` = opcional

## Escenarios BDD

Usar formato Gherkin:
- `GIVEN` = precondición/contexto
- `WHEN` = acción del usuario/sistema
- `THEN` = resultado esperado
- `AND` = condiciones adicionales

## Estados de Spec

| Estado | Significado |
|--------|-------------|
| `draft` | En borrador, no aprobada |
| `review` | En revisión |
| `approved` | Aprobada, lista para implementar |
| `implemented` | Implementada y testeada |
| `deprecated` | Obsoleta |
