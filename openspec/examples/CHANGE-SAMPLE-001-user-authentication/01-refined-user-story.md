# [US-AUTH-001] Autenticación de Usuario con Email y Contraseña

## User Story
Como **usuario registrado del sistema**, quiero **autenticarme con mi email y contraseña** para **acceder de forma segura a mi cuenta y funcionalidades personalizadas**.

## Contexto del Negocio
La autenticación es la primera barrera de seguridad del sistema. Permite identificar usuarios, proteger datos personales, y habilitar funcionalidades específicas según permisos. Sin autenticación robusta, no podemos garantizar privacidad ni cumplir con regulaciones de protección de datos.

## Criterios de Aceptación

### Escenario 1: Login exitoso con credenciales válidas
- **GIVEN** un usuario registrado con email `usuario@example.com` y contraseña válida
- **WHEN** ingresa sus credenciales correctas en el formulario de login
- **THEN** el sistema valida las credenciales contra la base de datos
- **AND** genera un token JWT válido por 24 horas
- **AND** redirige al usuario al dashboard principal
- **AND** registra el login en el log de auditoría

### Escenario 2: Login fallido por credenciales inválidas
- **GIVEN** un usuario intenta hacer login
- **WHEN** ingresa un email válido pero contraseña incorrecta
- **THEN** el sistema muestra error genérico "Credenciales inválidas"
- **AND** NO revela si el email existe en el sistema
- **AND** registra el intento fallido con IP y timestamp
- **AND** incrementa contador de intentos fallidos

### Escenario 3: Cuenta bloqueada por intentos fallidos
- **GIVEN** un usuario ha fallado 5 intentos de login en 15 minutos
- **WHEN** intenta hacer login nuevamente
- **THEN** el sistema bloquea la cuenta por 30 minutos
- **AND** muestra mensaje "Cuenta temporalmente bloqueada"
- **AND** envía notificación de seguridad al email del usuario
- **AND** registra el bloqueo en logs de seguridad

### Escenario 4: Email no registrado
- **GIVEN** un usuario intenta login con email no registrado
- **WHEN** envía el formulario
- **THEN** muestra error genérico "Credenciales inválidas" (sin revelar que el email no existe)
- **AND** registra el intento con IP

## Casos de Uso Adicionales

### Caso 1: Recordar sesión (Remember Me)
- Checkbox opcional "Recordar en este dispositivo"
- Si marcado, token válido por 30 días (en lugar de 24h)
- Almacenado en cookie HttpOnly

### Caso 2: Logout
- Invalidar token JWT actual
- Redirigir a página de login
- Limpiar sesión del navegador

### Caso 3: Token expirado
- Detectar token expirado en requests
- Redirigir automáticamente a login
- Mostrar mensaje "Sesión expirada, inicia sesión nuevamente"

## Requisitos No Funcionales

### Performance
- Tiempo de respuesta < 500ms para validación de credenciales
- Soporte para 100 logins simultáneos sin degradación

### Seguridad
- Contraseñas hasheadas con bcrypt (cost factor 12)
- Protección contra brute force (rate limiting)
- Tokens JWT firmados con RS256
- HTTPS obligatorio en producción
- Sanitización de inputs (prevenir SQL injection)
- Headers de seguridad (CSP, X-Frame-Options, etc.)

### UX
- Formulario accesible (WCAG 2.1 nivel AA)
- Mensajes de error claros pero seguros
- Indicador de carga durante autenticación
- Feedback visual en campos inválidos
- Soporte para password managers (autocomplete)

### Auditoría
- Logs detallados de todos los intentos de login
- Registro de IPs, user agents, timestamps
- Alertas automáticas para patrones sospechosos

## Estimación Inicial

- **Complejidad:** Alta (seguridad crítica, múltiples casos edge)
- **Esfuerzo:** M (2-3 sprints)
- **Riesgos:**
  - Vulnerabilidades de seguridad si no se implementa correctamente
  - Bloqueo legítimo de usuarios por falsos positivos
  - Problemas de performance con alta carga

## Fuera de Alcance

- Autenticación con redes sociales (OAuth)
- Autenticación de dos factores (2FA)
- Recuperación de contraseña
- Registro de nuevos usuarios
- SSO (Single Sign-On)

Estas funcionalidades se abordarán en propuestas separadas.

---

**Generado con:** `openspec enrich`  
**Fecha:** 2026-02-12
