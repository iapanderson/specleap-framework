# Publicar SpecLeap en npm

## Prerequisitos

1. Cuenta en npm: https://www.npmjs.com/signup
2. npm CLI configurado:
   ```bash
   npm login
   ```

## Pasos para publicar

### 1. Verificar package.json

```bash
cat package.json
```

Debe tener:
- `"name": "specleap-framework"`
- `"version": "2.0.0"` (incrementar con cada release)
- `"bin": { "specleap": "./setup.sh" }`
- `"files": [...]` (qué archivos se publican)

### 2. Test local

```bash
# Simular instalación
npm pack

# Instalar el .tgz generado
npm install -g ./specleap-framework-2.0.0.tgz

# Probar
npx specleap-framework
```

### 3. Publish a npm

```bash
npm publish
```

Si es la primera vez:
```bash
npm publish --access public
```

### 4. Verificar

```bash
npm info specleap-framework
```

### 5. Instalar desde npm

```bash
npx specleap-framework@latest
```

## Actualizar versión

Cada vez que publiques una nueva versión:

```bash
# Incrementar versión (patch/minor/major)
npm version patch

# Publish
npm publish
```

## Tags

Para versiones beta:

```bash
npm publish --tag beta
```

Instalar beta:
```bash
npx specleap-framework@beta
```

## Deprecar versión vieja

```bash
npm deprecate specleap-framework@1.0.0 "Use version 2.0.0+"
```

## Unpublish (solo primeras 72h)

```bash
npm unpublish specleap-framework@2.0.0
```

**⚠️ Después de 72h no se puede unpublish. Solo deprecar.**
