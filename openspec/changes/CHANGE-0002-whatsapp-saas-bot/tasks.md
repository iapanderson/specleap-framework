# CHANGE-0002: Tasks — SaaS WhatsApp Bot

## Fase 1: Setup y Auth (Semana 1)
- [ ] T1.1: Crear proyecto Laravel 11 + Breeze (auth)
- [ ] T1.2: Configurar multi-tenancy (tenant_id en todas las tablas)
- [ ] T1.3: Migraciones: tenants, conversations, messages
- [ ] T1.4: Panel React inicial (Vite + shadcn/ui)
- [ ] T1.5: Registro + login + verificación email

## Fase 2: Integración WhatsApp (Semana 1-2)
- [ ] T2.1: Crear app en Meta for Developers
- [ ] T2.2: Implementar webhook endpoint + verificación de firma
- [ ] T2.3: WhatsAppService: enviar mensajes de texto
- [ ] T2.4: Recibir y guardar mensajes entrantes
- [ ] T2.5: Test end-to-end: recibir msg → guardar → responder

## Fase 3: Knowledge Base + IA (Semana 2-3)
- [ ] T3.1: Modelo KnowledgeBase + KnowledgeChunk
- [ ] T3.2: EmbeddingService (OpenAI text-embedding-3-small)
- [ ] T3.3: RAGService: búsqueda por similitud vectorial
- [ ] T3.4: AIService: construir prompt + llamar GPT-4o-mini
- [ ] T3.5: ProcessIncomingMessage job completo
- [ ] T3.6: UI para crear/editar FAQs en el panel

## Fase 4: Panel Admin (Semana 3-4)
- [ ] T4.1: Dashboard con métricas básicas
- [ ] T4.2: Historial de conversaciones en tiempo real
- [ ] T4.3: Vista de conversación individual (mensajes)
- [ ] T4.4: Página de configuración del bot

## Fase 5: Pagos (Semana 4-5)
- [ ] T5.1: Integración Stripe (productos + precios)
- [ ] T5.2: Webhook Stripe (activar/desactivar tenant)
- [ ] T5.3: Página de planes en el panel

## Fase 6: Testing + Deploy (Semana 5-6)
- [ ] T6.1: Tests unitarios (RAG, AI, WhatsApp service)
- [ ] T6.2: Tests de integración (webhook flow)
- [ ] T6.3: Deploy en Hostinger/VPS
- [ ] T6.4: Onboarding del primer cliente piloto

## Decisiones abiertas
- [ ] D1: Nombre del producto
- [ ] D2: Dominio
- [ ] D3: pgvector vs Pinecone para embeddings
- [ ] D4: Cuenta Meta para verificación empresarial

## Testing Criteria
- Bot responde en < 5 segundos
- Webhook procesa mensajes sin pérdidas
- Multi-tenant: datos de un cliente no accesibles desde otro
- Panel carga en < 2 segundos
- Stripe activa/desactiva bot al pagar/cancelar
