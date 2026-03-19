# CHANGE-0002: SaaS de Chatbot WhatsApp con IA

## Status: DRAFT
## Priority: HIGH
## Author: Pamela Anderson
## Date: 2026-02-19
## Jira: (pendiente crear epic)

---

## 1. Objetivo

Construir un producto SaaS multi-tenant que permita a empresas conectar un chatbot de IA a su WhatsApp Business para responder automáticamente a preguntas de clientes.

El producto se vende por suscripción mensual y cada cliente gestiona su bot desde un panel de administración.

---

## 2. Problema que resuelve

Las empresas pierden clientes por:
- No responder fuera del horario laboral
- Lentitud en responder preguntas frecuentes (horarios, precios, disponibilidad)
- Coste elevado de atención al cliente humana

**Oportunidad:** WhatsApp tiene >2.000M usuarios. Las empresas necesitan presencia 24/7.

---

## 3. Solución Propuesta

### 3.1 Producto

**[NOMBRE PENDIENTE]** — Chatbot IA para WhatsApp Business, listo en minutos.

Cada cliente:
1. Se registra y crea su cuenta
2. Conecta su número de WhatsApp Business (via Meta Cloud API)
3. Sube su base de conocimiento (FAQs, catálogo, horarios, políticas...)
4. El bot empieza a responder automáticamente en su nombre

### 3.2 Stack Técnico

| Capa | Tecnología |
|------|-----------|
| Backend | Laravel 11 (API REST + Webhooks) |
| Frontend | React + Vite + shadcn/ui |
| Base de datos | MySQL (multi-tenant, un schema por cliente) |
| IA | OpenAI GPT-4o-mini (RAG sobre knowledge base) |
| WhatsApp | Meta WhatsApp Cloud API |
| Embeddings | OpenAI text-embedding-3-small |
| Vector DB | pgvector (PostgreSQL extension) o Pinecone |
| Cola de mensajes | Laravel Queues + Redis |
| Hosting | Hostinger / VPS |

### 3.3 Arquitectura

```
Cliente (WhatsApp) → Meta Cloud API → Webhook → Laravel
                                                    ↓
                                            Mensaje recibido
                                                    ↓
                                     Buscar contexto en knowledge base
                                      (RAG: embedding + vector search)
                                                    ↓
                                        GPT-4o-mini + contexto
                                                    ↓
                                          Respuesta generada
                                                    ↓
                                     Enviar via WhatsApp Cloud API
```

### 3.4 Panel de Administración (React)

- **Dashboard:** mensajes hoy, tasa de respuesta, conversaciones activas
- **Knowledge Base:** subir documentos (PDF, texto), FAQs editables
- **Conversaciones:** historial completo, intervención humana manual
- **Configuración:** personalidad del bot, idioma, horario de respuesta
- **Facturación:** plan actual, uso del mes, upgrade

---

## 4. Modelo de Negocio

### Planes

| Plan | Precio | Mensajes/mes | Features |
|------|--------|-------------|----------|
| Starter | 29€/mes | 1.000 | 1 número, panel básico |
| Pro | 59€/mes | 5.000 | 1 número, analytics, prioridad soporte |
| Business | 99€/mes | 15.000 | 3 números, CRM webhook, API acceso |
| Enterprise | Custom | Ilimitado | SLA, on-premise, soporte dedicado |

### Costes por cliente (Starter a 1.000 msg/mes)

| Concepto | Coste |
|---------|-------|
| WhatsApp Cloud API (1.000 conv/mes gratis) | 0€ |
| OpenAI GPT-4o-mini (1.000 msg) | ~0,50€ |
| Infraestructura (amortizada) | ~2€ |
| **Total coste** | **~2,50€** |
| **Precio venta** | **29€** |
| **Margen** | **~91%** |

### Proyección

| Clientes | Ingresos/mes | Costes/mes | Beneficio |
|---------|-------------|-----------|-----------|
| 10 | 290€ | ~30€ | 260€ |
| 50 | 1.950€ | ~130€ | 1.820€ |
| 100 | 4.500€ | ~260€ | 4.240€ |

---

## 5. Fases de Desarrollo

### Fase 1: MVP (4-6 semanas)
- Auth multi-tenant (registro, login, planes)
- Conexión WhatsApp Business API
- Knowledge base básica (texto plano + FAQs)
- Bot responde a preguntas simples
- Panel admin mínimo viable

### Fase 2: IA Avanzada (2-3 semanas)
- RAG con embeddings (respuestas contextuales desde documentos)
- Subida de PDFs y procesado automático
- Fallback a humano cuando el bot no sabe

### Fase 3: Panel Completo (2-3 semanas)
- Analytics y métricas
- Historial de conversaciones
- Intervención manual en tiempo real
- Personalización del bot (nombre, tono, idioma)

### Fase 4: Comercialización
- Stripe para pagos y suscripciones
- Landing page del producto
- Onboarding guiado

---

## 6. Constraints y Riesgos

| Riesgo | Mitigación |
|--------|-----------|
| Meta puede cambiar precios de API | Calcular con buffer, actualizar términos |
| Verificación de empresa en Meta (puede tardar) | Iniciar proceso al comenzar desarrollo |
| OpenAI costes si escala | Implementar caché de respuestas frecuentes |
| GDPR/privacidad de conversaciones | Cifrado en reposo, política de privacidad clara |

---

## 7. Fuera de Scope (v1)

- Integración con CRMs (v2)
- Bot de voz
- Instagram DMs / Facebook Messenger (v2)
- App móvil para el panel

---

## 8. Criterios de Aceptación

- [ ] Un cliente puede registrarse, conectar su WhatsApp y recibir respuestas del bot en < 30 min
- [ ] El bot responde correctamente a preguntas contenidas en la knowledge base
- [ ] El panel muestra historial de conversaciones en tiempo real
- [ ] El sistema soporta 10 clientes simultáneos sin degradación
- [ ] Los mensajes se envían en < 5 segundos tras recibirse

---

## 9. Decisiones Pendientes

- [ ] Nombre del producto
- [ ] Dominio
- [ ] ¿Vector DB: pgvector vs Pinecone?
- [ ] ¿Modelo IA: OpenAI exclusivo o multi-provider?
- [ ] ¿Verificación de empresa Meta: usar cuenta Conceptual Creative o crear entidad nueva?
