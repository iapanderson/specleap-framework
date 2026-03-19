# Comando: crear-tickets

**Sintaxis:** `crear-tickets` o `crear-tickets @CONTRATO.md`

**Objetivo:** Generar tareas de Asana desde el CONTRATO.md.

**Nota:** Este comando es un alias de `planificar`. Ambos hacen lo mismo.

---

## Uso Rápido

```
crear-tickets
```

Es equivalente a:

```
planificar
```

---

## Motor

Usa el mismo CLI que `planificar`:
- `scripts/generate-asana-structure.sh` — Generar proyecto y tareas en Asana

---

## Flujo

Ver documentación completa en: `.commandsplanificar.md`

**Resumen:**
1. Leer CONTRATO.md
2. Generar estructura (secciones + tareas)
3. Mostrar preview
4. Crear en Asana si el usuario aprueba

---

## ¿Por qué dos comandos?

Histórico: `crear-tickets` era el nombre original, luego se renombró a `planificar` por claridad.

**Recomendación:** Usa `planificar` (más claro).

---

## Referencia

- **Comando principal:** `.commandsplanificar.md`
- **CLI:** `scripts/generate-asana-structure.sh`, `scripts/create-asana-tasks.sh`
