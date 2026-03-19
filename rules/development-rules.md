# Reglas de Desarrollo — SpecLeap

> Reglas obligatorias para todo desarrollo dentro de proyectos gestionados con SpecLeap.

## 1. Centralización de Configuración

**NUNCA hardcodear valores.** Todo valor configurable debe estar en:

- Variables de entorno (`.env`)
- Archivos de configuración (`config/`)
- Constantes centralizadas

```
❌ $url = "https://api.example.com/v1";
✅ $url = config('services.api.url');
```

**Sin excepciones.** URLs, credenciales, puertos, rutas de archivos, claves API — todo centralizado.

## 2. Non-Destructive Development

Antes de cualquier cambio, evaluar la **jerarquía de impacto**:

| Nivel | Pregunta | Acción requerida |
|-------|----------|-----------------|
| 🔴 Crítico | ¿Puede romper producción? | Review obligatorio + rollback plan |
| 🟡 Alto | ¿Afecta datos existentes? | Migración reversible + backup |
| 🟢 Medio | ¿Cambia API pública? | Deprecación primero, luego cambio |
| ⚪ Bajo | ¿Cambio interno sin impacto externo? | Proceder con tests |

**Reglas:**
- Toda migración de base de datos debe ser **reversible** (`up` + `down`)
- Nunca eliminar columnas/tablas sin período de deprecación
- Cambios en APIs públicas requieren versionado

## 3. Análisis Previo Obligatorio

**ANTES de crear código nuevo:**

1. **Buscar** si ya existe funcionalidad similar en el proyecto
2. **Revisar** specs existentes relacionadas
3. **Verificar** patrones establecidos en el código
4. **Consultar** `context/conventions.md` del proyecto

```bash
# Buscar código existente antes de crear
grep -r "función_similar" src/
# Revisar specs relacionadas
ls openspec/specs/functional/ | grep "tema"
```

**Si existe algo similar:** reutilizar o extender, NO duplicar.

## 4. Consistencia de Patrones

**Replicar EXACTAMENTE los patrones existentes del proyecto.**

- Si el proyecto usa Services → crear un Service, no inventar otra capa
- Si los Controllers siguen un formato → seguir ese formato exacto
- Si hay una convención de nombres → respetarla

**Antes de introducir un patrón nuevo:**
1. Documentar por qué el patrón actual no sirve
2. Proponer el nuevo patrón en una spec
3. Obtener aprobación antes de implementar

## 5. Comunicación de Errores

Cuando se detecta un error, documentar con esta estructura:

```markdown
### Error detectado
- **Causa:** [descripción técnica de la causa raíz]
- **Impacto:** [qué afecta y a quién]
- **Solución:** [qué se hizo para resolverlo]
- **Verificación:** [cómo se verificó que está resuelto]
- **Prevención:** [qué se puede hacer para evitarlo en el futuro]
```

## 6. Fix de Errores por Análisis

Al encontrar un error:

1. **Primero:** Buscar código que YA funciona en el proyecto como referencia
2. **Segundo:** Analizar la diferencia entre lo que funciona y lo que falla
3. **Tercero:** Aplicar la corrección basándose en el patrón funcional
4. **Nunca:** Copiar soluciones externas sin adaptarlas al proyecto

## 7. Métodos Estáticos vs Instancia

Guía para decidir cuándo usar cada uno:

| Usar estático cuando | Usar instancia cuando |
|---------------------|----------------------|
| No necesita estado interno | Necesita estado o configuración |
| Es una utilidad pura (helper) | Tiene dependencias inyectadas |
| No necesita ser mockeado en tests | Debe ser testeable con mocks |
| Operación sin efectos secundarios | Interactúa con DB, APIs, filesystem |

## 8. Prohibición de Archivos en Raíz

**JAMÁS crear archivos sueltos en la raíz del proyecto** sin autorización explícita.

Todo archivo debe ir en su carpeta correspondiente:
- Código → `src/`
- Tests → `tests/`
- Configuración → `config/`
- Documentación → `docs/`
- Specs → `openspec/specs/`

---

*Estas reglas son obligatorias. Cualquier excepción debe ser aprobada y documentada en `context/decisions.md`.*
