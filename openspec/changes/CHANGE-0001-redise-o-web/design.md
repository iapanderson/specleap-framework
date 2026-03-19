# CHANGE-0001: Design — Rediseño Web Conceptual Creative

## Arquitectura

```
conceptualcreative/
├── src/
│   ├── components/          # Componentes Astro + React
│   │   ├── Hero.astro
│   │   ├── Services.astro
│   │   ├── ServiceCard.astro
│   │   ├── Testimonials.astro
│   │   ├── Team.astro
│   │   ├── ContactForm.tsx   # React Island (interactivo)
│   │   ├── CookieBanner.tsx  # React Island (RGPD)
│   │   ├── LanguageSwitcher.astro
│   │   ├── Navbar.astro
│   │   ├── Footer.astro
│   │   └── BlogCard.astro
│   ├── layouts/
│   │   ├── BaseLayout.astro  # Layout principal (SEO, meta, Schema.org)
│   │   └── BlogLayout.astro  # Layout para posts
│   ├── pages/
│   │   ├── es/               # Páginas en español
│   │   │   ├── index.astro
│   │   │   ├── servicios.astro
│   │   │   ├── nosotros.astro
│   │   │   ├── contacto.astro
│   │   │   ├── blog/
│   │   │   │   └── index.astro
│   │   │   ├── aviso-legal.astro
│   │   │   ├── privacidad.astro
│   │   │   └── cookies.astro
│   │   ├── en/               # Páginas en inglés
│   │   │   ├── index.astro
│   │   │   ├── services.astro
│   │   │   ├── about.astro
│   │   │   ├── contact.astro
│   │   │   ├── blog/
│   │   │   │   └── index.astro
│   │   │   ├── legal.astro
│   │   │   ├── privacy.astro
│   │   │   └── cookies.astro
│   │   ├── index.astro       # Redirect → /es/
│   │   ├── robots.txt.ts
│   │   └── sitemap.xml.ts
│   ├── content/
│   │   └── blog/             # Markdown blog posts
│   ├── i18n/
│   │   ├── es.json
│   │   └── en.json
│   ├── styles/
│   │   └── global.css        # Tailwind + custom fonts
│   └── lib/
│       ├── seo.ts            # Schema.org generators
│       └── i18n.ts           # i18n utilities
├── public/
│   ├── logo.svg
│   ├── fonts/
│   └── og-image.png
├── astro.config.mjs
├── tailwind.config.mjs
├── package.json
└── tsconfig.json
```

## Decisiones Técnicas

### 1. Astro SSG
- Genera HTML estático en build → SEO perfecto
- Se sube a hosting normal via FTP
- React Islands solo para componentes interactivos (formulario, cookies)

### 2. i18n
- Routing por directorio: `/es/`, `/en/`
- JSON files para traducciones
- Hreflang tags automáticos
- Default: español, redirect `/` → `/es/`

### 3. Diseño System
- **Background:** `bg-black` (#000000)
- **Text primary:** `text-white`
- **Text secondary:** `text-gray-400`
- **Accent:** `text-[#12BAEB]` / `bg-[#12BAEB]`
- **Font heading:** Space Grotesk (bold 700)
- **Font body:** Inter (light 300, regular 400)
- **Tamaños heading:** Grandes, impactantes (text-5xl a text-8xl)

### 4. SEO
- BaseLayout genera: title, description, OG, Twitter, hreflang, canonical
- Schema.org JSON-LD: LocalBusiness + Organization + Service
- Sitemap auto con @astrojs/sitemap
- robots.txt generado

### 5. RGPD/LOPD
- Cookie banner con React (estado local)
- No cargar GA4 hasta consentimiento
- Páginas legales estáticas
- Textos adaptados a normativa española

### 6. Formulario de Contacto
- React Island con validación client-side
- Backend: envío via formspree.io o netlify forms (o email directo)
- Fallback: mailto: link

### 7. Blog
- Astro Content Collections (Markdown)
- Posts con frontmatter: title, date, description, lang, tags
- Listado con paginación
- RSS feed
