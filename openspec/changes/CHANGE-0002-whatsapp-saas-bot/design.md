# CHANGE-0002: Design — SaaS WhatsApp Bot

## Arquitectura de la aplicación

```
saas-whatsapp-bot/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Auth/           # Registro, login, verificación email
│   │   │   ├── WebhookController.php  # Recibe mensajes de Meta
│   │   │   ├── BotController.php      # Lógica del bot
│   │   │   ├── KnowledgeBaseController.php
│   │   │   └── ConversationController.php
│   │   └── Middleware/
│   │       └── TenantMiddleware.php   # Identifica el tenant por API key
│   ├── Models/
│   │   ├── Tenant.php          # Empresa cliente
│   │   ├── WhatsAppNumber.php  # Número WA conectado
│   │   ├── Conversation.php    # Conversación con un usuario
│   │   ├── Message.php         # Mensaje individual
│   │   ├── KnowledgeBase.php   # Base de conocimiento
│   │   └── KnowledgeChunk.php  # Fragmento con embedding
│   ├── Services/
│   │   ├── WhatsAppService.php  # Enviar/recibir mensajes via Meta API
│   │   ├── AIService.php        # GPT-4o-mini, generación de respuesta
│   │   ├── EmbeddingService.php # Generar embeddings
│   │   └── RAGService.php       # Buscar contexto relevante
│   └── Jobs/
│       ├── ProcessIncomingMessage.php
│       └── GenerateEmbeddings.php
├── resources/
│   └── js/                     # React SPA (admin panel)
│       ├── pages/
│       │   ├── Dashboard.tsx
│       │   ├── KnowledgeBase.tsx
│       │   ├── Conversations.tsx
│       │   └── Settings.tsx
│       └── components/
└── database/
    └── migrations/
```

## Base de datos (multi-tenant: un tenant_id en cada tabla)

```sql
tenants          (id, name, email, plan, meta_token, phone_number_id, ...)
conversations    (id, tenant_id, wa_contact_id, status, created_at)
messages         (id, conversation_id, direction, content, timestamp)
knowledge_bases  (id, tenant_id, name, type)
knowledge_chunks (id, knowledge_base_id, content, embedding vector(1536))
```

## Flujo de un mensaje entrante

```
1. Meta envía POST /webhook/{tenant_token}
2. WebhookController verifica firma (X-Hub-Signature-256)
3. Dispatch ProcessIncomingMessage job
4. Job: buscar conversación o crear nueva
5. RAGService: embed pregunta → buscar chunks similares en BD
6. AIService: prompt = system_prompt + contexto + historial + pregunta
7. GPT-4o-mini genera respuesta
8. WhatsAppService: enviar respuesta
9. Guardar mensaje en BD
```

## Integraciones externas

| Servicio | Uso | Docs |
|---------|-----|------|
| Meta WhatsApp Cloud API | Enviar/recibir mensajes | developers.facebook.com/docs/whatsapp |
| OpenAI API | GPT-4o-mini + embeddings | platform.openai.com |
| Stripe | Suscripciones | stripe.com/docs |
| Redis | Cola de mensajes | |
