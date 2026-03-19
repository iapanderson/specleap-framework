---
name: Code Standards
globs: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.php", "**/*.py"]
alwaysApply: false
description: Estándares de código para desarrollo
---

# Estándares de Código

## Principios

1. **DRY** — No repetir lógica
2. **KISS** — La solución más simple que funcione
3. **YAGNI** — No construir lo que no se necesita aún
4. **Tests primero** — TDD cuando sea práctico

## Idioma

- **Código**: Variables, funciones, clases en **inglés**
- **Comentarios**: En **español**
- **Documentación**: En **español**
- **Commits**: En **español** (prefijos en inglés)

## TypeScript/JavaScript

- Componentes funcionales con hooks
- TypeScript strict mode
- Nombres de componentes en PascalCase
- Hooks personalizados con prefijo `use`
- Props tipadas con interfaces

```typescript
// ✅ Correcto
interface UserCardProps {
  user: User;
  onSelect: (id: string) => void;
}

// Componente para mostrar información del usuario
const UserCard: React.FC<UserCardProps> = ({ user, onSelect }) => {
  // ...
};
```

## PHP/Laravel

- PSR-12 coding standard
- Eloquent para queries
- Form Requests para validación
- Resources para transformar respuestas API

## Seguridad

- ❌ Nunca hardcodear credenciales
- ✅ Validar TODOS los inputs
- ✅ Sanitizar outputs
- ✅ CSRF protection activa
- ✅ Prepared statements / ORM

## Testing

- Unit tests: lógica de negocio 80%+
- Integration tests: APIs y flujos
- Cobertura mínima documentada en spec
