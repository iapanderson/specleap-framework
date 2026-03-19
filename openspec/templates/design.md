# [CHANGE-XXX] Diseño Técnico: Título del Cambio

| Campo | Valor |
|-------|-------|
| ID | CHANGE-XXX |
| Propuesta | `proposal.md` |
| Fecha | YYYY-MM-DD |
| Estado | draft / review / approved |
| Arquitecto | nombre |

## Resumen del Diseño

Descripción técnica de alto nivel de cómo se implementará la propuesta.

## Arquitectura

### Diagrama de Componentes

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Componente A│────▶│ Componente B│────▶│ Componente C│
└─────────────┘     └─────────────┘     └─────────────┘
```

### Componentes Afectados

| Componente | Tipo de Cambio | Descripción |
|------------|----------------|-------------|
| ComponenteA | Nuevo / Modificado | Qué cambia |
| ComponenteB | Modificado | Qué cambia |

## Modelo de Datos

### Nuevas Entidades

```typescript
interface NuevaEntidad {
  id: string;
  campo1: string;
  campo2: number;
  createdAt: Date;
  updatedAt: Date;
}
```

### Cambios en Entidades Existentes

```diff
interface EntidadExistente {
  id: string;
  campoExistente: string;
+ nuevoCampo: string;      // Añadido
- campoEliminado: string;  // Eliminado
}
```

### Migraciones de Base de Datos

```sql
-- Migration: YYYYMMDDHHMMSS_descripcion
ALTER TABLE tabla ADD COLUMN nuevo_campo VARCHAR(255);
```

## API / Interfaces

### Nuevos Endpoints

```
POST /api/v1/recurso
GET  /api/v1/recurso/:id
PUT  /api/v1/recurso/:id
DELETE /api/v1/recurso/:id
```

### Contratos de API

```typescript
// POST /api/v1/recurso
interface CreateRecursoRequest {
  campo1: string;
  campo2: number;
}

interface CreateRecursoResponse {
  id: string;
  campo1: string;
  campo2: number;
  createdAt: string;
}
```

## Flujo de Datos

### Secuencia Principal

```
Usuario → Frontend → API → Service → Repository → Database
                              ↓
                         Validación
                              ↓
                      Lógica de Negocio
```

### Casos de Error

| Código | Escenario | Respuesta |
|--------|-----------|-----------|
| 400 | Validación fallida | `{ error: "Campo X inválido" }` |
| 404 | Recurso no encontrado | `{ error: "No encontrado" }` |
| 500 | Error interno | `{ error: "Error del servidor" }` |

## Seguridad

### Autenticación/Autorización
- Método de autenticación requerido
- Roles con acceso: admin, user, etc.

### Validación de Inputs
- Campo1: string, max 255 chars, sanitizado
- Campo2: number, min 0, max 1000

### Consideraciones de Seguridad
- [ ] CSRF protection
- [ ] Rate limiting
- [ ] Input sanitization
- [ ] SQL injection prevention

## Performance

### Estimaciones de Carga
- Requests esperados: X/segundo
- Tamaño de datos: X registros

### Optimizaciones
- Índices de base de datos necesarios
- Caché strategy
- Paginación

## Testing Strategy

### Unit Tests
- [ ] Service layer: lógica de negocio
- [ ] Validators: validación de inputs
- [ ] Utils: funciones auxiliares

### Integration Tests
- [ ] API endpoints
- [ ] Database operations

### E2E Tests (si aplica)
- [ ] Flujo principal del usuario

## Plan de Rollback

### Pasos para Revertir
1. Revertir código (git revert)
2. Revertir migración de BD
3. Limpiar caché

### Datos a Preservar
- Qué datos no se pueden perder
- Estrategia de backup

## Decisiones Técnicas (ADR)

### ADR-001: Elección de X sobre Y

**Contexto:** Necesitamos decidir entre X e Y para...

**Decisión:** Elegimos X porque...

**Consecuencias:**
- Positivo: ...
- Negativo: ...

## Referencias

- Propuesta: `proposal.md`
- Spec principal: `openspec/specs/domain/spec.md`
- Delta specs: `specs/domain/spec.md`
- Documentación externa: links
