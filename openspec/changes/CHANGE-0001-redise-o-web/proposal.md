# CHANGE-0001: Rediseño completo del sitio web de Conceptual Creative

## Status: DRAFT
## Priority: HIGH
## Author: Pamela Anderson
## Date: 2026-02-14

---

## 1. Objetivo

Rediseñar completamente el sitio web de Conceptual Creative (conceptualcreative.com) para que refleje la imagen, servicios y filosofía actual de la empresa. El sitio actual es un SPA React con CSR que no representa lo que hacen, tiene problemas graves de SEO y una imagen desactualizada.

## 2. Problema Actual

- **Renderizado:** SPA React con CSR puro → Google ve `<div id="root"></div>` vacío
- **Contenido:** No refleja los servicios reales (software a medida, IA, CRM, etc.)
- **SEO:** Title genérico ("diseño web canarias"), meta description tipo spam, sin Schema.org, sin robots.txt, solo 9 URLs
- **Imagen:** No transmite la calidad técnica ni la filosofía de la empresa
- **Idioma:** Solo español, sin versión inglesa

## 3. Solución Propuesta

Nuevo sitio web con Astro 4 + Tailwind CSS + React Islands. Generación estática (SSG) para SEO perfecto. Bilingüe ES/EN.

### 3.1 Stack Técnico
- **Framework:** Astro 4 (SSG)
- **Estilos:** Tailwind CSS 3
- **Interactividad:** React Islands (componentes interactivos)
- **i18n:** Astro i18n routing (ES/EN)
- **Deploy:** Hosting estático (FTP a servidor actual)

### 3.2 Diseño
- **Fondo:** Negro total (#000000)
- **Texto:** Blanco (#FFFFFF)
- **Acento:** Azul corporativo (#12BAEB)
- **Tipografía:** Combinación de fuentes finas y gruesas (ej: Inter 300/700 o Space Grotesk)
- **Estilo:** Moderno, llamativo, nivel Silicon Valley. NO estándar de plantillas IA.
- **Logo:** Logo corporativo azul existente

### 3.3 Servicios a Mostrar
1. **Software a medida en la nube** — Core del negocio
2. **Desarrollo con IA** — Nombre corto, sin referenciar herramientas internas
3. **CRM** — Salesforce, HubSpot, Zoho y otros
4. **Channel Managers a medida** — Sector hotelero/turístico
5. **Domótica** — Canchas de pádel y similares
6. **Automatización de procesos** — Para negocios con trabajo repetitivo
7. **Soluciones para Educación** — Alumnos, profesores, centros y startups edu

### 3.4 Páginas / Secciones
- **Home** — Hero impactante, servicios, testimonios, CTA
- **Servicios** — Página individual o agrupada por categoría
- **Sobre nosotros / Equipo** — Sin fotos, texto + roles
- **Blog** — Contenido propio, orientado a SEO long-tail local
- **Contacto** — Formulario de contacto funcional
- **Legal:**
  - Aviso legal
  - Política de privacidad
  - Política de cookies
  - Banner RGPD/LOPD (consentimiento de cookies)

### 3.5 SEO Integrado
- Schema.org (LocalBusiness + Organization + Service)
- Meta tags dinámicos por página
- Sitemap.xml auto-generado
- robots.txt
- Open Graph / Twitter Cards
- Hreflang ES/EN
- Preparado para Google Search Console + GA4

### 3.6 Contenido
- Textos nuevos 100% (no reutilizar web actual)
- Testimonios extraídos de https://www.malt.es/profile/davidarias
- Blog con contenido original
- Sin precios visibles — solo "Contactar"

## 4. Fuera de Alcance
- E-commerce / carrito de compras
- Panel de administración / CMS
- Apps móviles nativas
- Integración con pasarelas de pago
- Google Ads / SEM

## 5. Criterios de Aceptación
- [ ] Sitio funcional en local (localhost)
- [ ] SSG genera HTML estático completo (verificable con curl)
- [ ] Lighthouse Performance > 90
- [ ] Lighthouse SEO = 100
- [ ] Versión ES y EN completas
- [ ] Banner RGPD/LOPD funcional
- [ ] Formulario de contacto operativo
- [ ] Schema.org válido (probado en Google Rich Results Test)
- [ ] Responsive (móvil, tablet, desktop)
- [ ] Diseño aprobado por Styng
- [ ] Deploy funcional en hosting estático via FTP

## 6. Constraints
- NO mencionar SpecLeap ni herramientas internas en el sitio
- NO usar Safari para desarrollo/testing — solo Chrome
- Desarrollo local → GitHub → Servidor
- Deploy lo realiza Styng manualmente
- Hosting normal (no VPS)

## 7. Bonus
Este proyecto sirve como caso de éxito real de SpecLeap — "diseñado con nuestra propia herramienta".
