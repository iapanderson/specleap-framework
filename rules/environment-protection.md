# Protección del Entorno — SpecLeap

> Reglas para proteger archivos críticos y mantener la integridad del proyecto.

## Archivos Protegidos

Los siguientes archivos y carpetas requieren **confirmación explícita** antes de ser modificados:

### 🔴 Nivel Máximo — Nunca modificar sin aprobación

| Archivo/Carpeta | Razón |
|----------------|-------|
| `openspec/specs/` | Contratos funcionales del proyecto |
| `openspec/changes/` | Historial de propuestas de cambio |
| `context/` | Memoria y contexto del proyecto |
| `.env` | Variables de entorno sensibles |
| `config/` | Configuración central |
| `main` branch | Rama de producción |

### 🟡 Nivel Alto — Confirmar antes de modificar

| Archivo/Carpeta | Razón |
|----------------|-------|
| `rules/` | Reglas del proyecto |
| `AGENTS.md` | Configuración de agentes AI |
| `README.md` | Documentación principal |
| Migraciones de DB | Afectan datos existentes |

## Reglas de Protección

### 1. Specs como Fuente de Verdad

Las specs en `openspec/specs/` son **contratos**. Para modificar una spec:

1. Crear una propuesta de cambio (`openspec/changes/`)
2. Documentar QUÉ cambia y POR QUÉ
3. Obtener aprobación
4. Solo entonces modificar la spec

**NUNCA** modificar una spec directamente sin propuesta.

### 2. Context como Memoria del Proyecto

Los archivos en `context/` documentan decisiones arquitectónicas. Para modificarlos:

1. Verificar que el cambio refleja una decisión real (no una suposición)
2. Documentar la fecha y razón del cambio
3. Actualizar `context/decisions.md` con la nueva decisión

### 3. Protección de Archivos en Producción

Antes de tocar archivos que afectan producción:

```
⚠️ PREGUNTA: ¿Este cambio puede afectar al entorno de producción?

SI → Requiere:
  1. Review de al menos 1 persona
  2. Plan de rollback documentado
  3. Ventana de mantenimiento acordada

NO → Proceder con el flujo normal
```

### 4. Archivos que NUNCA Deben Subirse al Repositorio

| Archivo | Razón |
|---------|-------|
| `.env` | Credenciales sensibles |
| `*.log` | Logs de desarrollo |
| `node_modules/` | Dependencias (se instalan) |
| `vendor/` | Dependencias PHP (se instalan) |
| `storage/*.key` | Claves privadas |
| `*.sqlite` | Bases de datos locales |

Verificar que `.gitignore` incluye todos estos patrones.

### 5. Backups Antes de Cambios Destructivos

Antes de:
- Eliminar archivos o carpetas
- Modificar migraciones existentes
- Cambiar estructura de base de datos
- Resetear ramas

**Hacer backup:**
```bash
# Backup de archivos
cp -r carpeta/ carpeta.backup/

# Backup de rama
git branch backup/nombre-rama
```

---

*La protección del entorno no es opcional. Estas reglas previenen pérdida de trabajo y datos.*
