---
name: Testing Report Format
globs: ["**/tasks.md", "**/*test*", "**/*spec*"]
alwaysApply: false
description: Formato obligatorio de Testing Report
---

# Testing Report (OBLIGATORIO)

Cada feature completada DEBE incluir un Testing Report.

## Formato Estándar

```markdown
## Testing Report

### Resultados
| Suite | Tests | Passed | Failed | Skipped | Coverage |
|-------|-------|--------|--------|---------|----------|
| Unit | X | X | 0 | 0 | XX% |
| Integration | X | X | 0 | 0 | N/A |
| E2E | X | X | 0 | 0 | N/A |

### Cobertura por Módulo
| Módulo | Statements | Branches | Functions | Lines |
|--------|------------|----------|-----------|-------|
| src/module | XX% | XX% | XX% | XX% |

### Comando de Ejecución
\`\`\`bash
npm test -- --coverage
\`\`\`

### Code Review Status
- [ ] Review solicitado
- [ ] Comentarios resueltos
- [ ] Review aprobado

### Notas
- Observaciones relevantes sobre los tests
```

## Cobertura Mínima

| Tipo de Código | Cobertura Mínima |
|----------------|------------------|
| Lógica de negocio | 80% |
| Utilidades | 90% |
| Componentes UI | Tests de comportamiento |

## Convención de Nombres de Tests

```typescript
describe('[NombreComponente]', () => {
  it('debería [comportamiento] cuando [condición]', () => {
    // Arrange → Act → Assert
  });
});
```

## Regla de Oro

> **Si no hay Testing Report, no hay merge.**
