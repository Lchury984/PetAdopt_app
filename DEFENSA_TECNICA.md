# Defensa Técnica - PetAdopt

## 1. Descripción del Proyecto

**PetAdopt** es una aplicación móvil multiplataforma que conecta refugios de animales con adoptantes potenciales. Permite a los refugios publicar mascotas en adopción y a los usuarios buscar, solicitar adopciones y chatear con una IA para recibir asesoría sobre cuidado de mascotas.

## 2. Tecnologías Utilizadas

### Frontend
- **Flutter 3.x** - Framework multiplataforma (Android, iOS, Web, Windows)
- **Dart** - Lenguaje de programación
- **flutter_riverpod** - Gestión de estado reactivo
- **Material Design 3** - Diseño de interfaz

### Backend
- **Supabase** - Backend as a Service
  - PostgreSQL (Base de datos)
  - Autenticación con PKCE
  - Storage para imágenes
  - Realtime subscriptions
  - Row Level Security (RLS)

### Inteligencia Artificial
- **Google Gemini 2.0 Flash** - Chat IA para asesoría sobre mascotas

### Servicios Adicionales
- **flutter_map** - Visualización de refugios en mapa
- **geolocator** - Geolocalización GPS
- **flutter_local_notifications** - Notificaciones push

## 3. Arquitectura

### Clean Architecture (Capas)
```
lib/
├── core/                    # Funcionalidades compartidas
│   ├── config/             # Configuración Supabase
│   ├── services/           # Servicios (notificaciones, storage)
│   └── theme/              # Temas visuales
│
├── features/               # Módulos por funcionalidad
│   ├── auth/              # Autenticación
│   │   ├── data/          # Datasources, repositories
│   │   ├── domain/        # Entities, use cases
│   │   └── presentation/  # Screens, providers
│   │
│   ├── mascota/           # Gestión de mascotas
│   ├── solicitud/         # Solicitudes de adopción
│   ├── chat/              # Chat con IA
│   ├── map/               # Mapa de refugios
│   └── profile/           # Perfil de usuario
```

### Patrón de Diseño
- **Repository Pattern** - Abstracción de fuentes de datos
- **Use Cases** - Lógica de negocio encapsulada
- **Dependency Injection** - GetIt para inyección de dependencias
- **Provider Pattern** - Riverpod para estado reactivo

## 4. Funcionalidades Principales

### 4.1 Autenticación
- Registro de adoptantes (nombre, email, contraseña)
- Registro de refugios (incluye ubicación GPS)
- Login con email/contraseña
- Recuperación de contraseña por email
- Persistencia de sesión

**Implementación técnica:**
```dart
// Registro con creación manual de perfil
final authResponse = await supabaseClient.auth.signUp(email, password);
await Future.delayed(Duration(milliseconds: 500));
await supabaseClient.from('profiles').insert({
  'id': userId, 'nombre': nombre, 'email': email, 'rol': rol
});
```

### 4.2 Gestión de Mascotas (Refugios)
- Crear mascotas con foto (subida a Supabase Storage)
- Listar mascotas propias
- Actualizar información
- Eliminar mascotas
- Filtros por tipo (perro, gato, otros)

**Storage de imágenes:**
```dart
final bytes = await file.readAsBytes();
final path = 'mascotas/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
await supabaseClient.storage.from('mascotas').uploadBinary(path, bytes);
```

### 4.3 Búsqueda y Adopción (Adoptantes)
- Ver catálogo de mascotas disponibles
- Filtrar por categorías
- Ver detalles con fotos
- Solicitar adopción
- Ver estado de solicitudes (pendiente/aprobada/rechazada)

### 4.4 Gestión de Solicitudes (Refugios)
- Recibir solicitudes en tiempo real
- Aprobar o rechazar solicitudes
- Notificaciones automáticas al adoptante

**Realtime con Supabase:**
```dart
supabaseClient
  .from('solicitudes_adopcion')
  .stream(primaryKey: ['id'])
  .eq('refugio_id', userId)
  .listen((data) {
    // Notificar nuevas solicitudes
  });
```

### 4.5 Chat con IA
- Asistente virtual con Gemini AI
- Recomendaciones sobre cuidado de mascotas
- Historial de conversación
- Interfaz tipo WhatsApp

### 4.6 Mapa de Refugios
- Visualización geográfica de refugios
- Cálculo de distancia al usuario
- Marcadores interactivos
- Información de contacto

## 5. Base de Datos

### Esquema PostgreSQL (Supabase)

#### Tabla: profiles
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users,
  nombre TEXT NOT NULL,
  email TEXT NOT NULL,
  rol TEXT CHECK (rol IN ('adoptante', 'refugio')),
  telefono TEXT,
  nombre_refugio TEXT,
  direccion TEXT,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Tabla: mascotas
```sql
CREATE TABLE mascotas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  refugio_id UUID REFERENCES profiles(id),
  nombre TEXT NOT NULL,
  tipo TEXT NOT NULL,
  raza TEXT,
  edad INTEGER,
  sexo TEXT,
  descripcion TEXT,
  foto_url TEXT,
  disponible BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Tabla: solicitudes_adopcion
```sql
CREATE TABLE solicitudes_adopcion (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mascota_id UUID REFERENCES mascotas(id),
  adoptante_id UUID REFERENCES profiles(id),
  refugio_id UUID REFERENCES profiles(id),
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'aprobada', 'rechazada')),
  mensaje TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Row Level Security (RLS)

**Políticas implementadas:**
- Todos pueden leer perfiles y mascotas
- Solo refugios pueden crear/editar mascotas
- Adoptantes ven solo sus solicitudes
- Refugios ven solicitudes de sus mascotas
- Solo el refugio dueño puede cambiar estado de solicitud

```sql
CREATE POLICY "Refugios pueden crear mascotas"
  ON mascotas FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND rol = 'refugio')
  );
```

## 6. Configuración de Variables de Entorno

### Archivo .env (Móvil/Desktop)
```env
SUPABASE_URL=https://iyjjvljjlozigcouztta.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GEMINI_API_KEY=AIzaSyAaksUtGm9l9PV4PjqNFJIA4eFZhhy0POg
```

### Para Web (--dart-define)
```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=... \
  --dart-define=GEMINI_API_KEY=...
```

**Implementación adaptativa:**
```dart
class AppConstants {
  static const String _ddSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
  
  static String get supabaseUrl => 
    (_ddSupabaseUrl.isNotEmpty ? _ddSupabaseUrl : dotenv.env['SUPABASE_URL'])!;
}
```

## 7. Compilación y Deployment

### Android (APK)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk (54MB)
```

### Web
```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

### Windows
```bash
flutter build windows --release
```

## 8. Flujo de Usuario

### Adoptante
1. Registro → Datos personales
2. Login → Pantalla principal con catálogo
3. Buscar mascotas → Filtros por tipo
4. Ver detalles → Información completa + foto
5. Solicitar adopción → Mensaje personalizado
6. Ver solicitudes → Estado en tiempo real
7. Chat IA → Preguntas sobre cuidados

### Refugio
1. Registro → Datos + ubicación GPS
2. Login → Dashboard con estadísticas
3. Agregar mascota → Formulario + foto
4. Recibir solicitudes → Notificación realtime
5. Revisar solicitud → Datos del adoptante
6. Aprobar/Rechazar → Notificación automática
7. Gestionar mascotas → Editar/eliminar

## 9. Seguridad Implementada

- ✅ **Autenticación JWT** con Supabase Auth
- ✅ **PKCE Flow** para prevenir ataques CSRF
- ✅ **Row Level Security** en todas las tablas
- ✅ **Validación de roles** antes de operaciones sensibles
- ✅ **Storage público** solo para lectura, escritura autenticada
- ✅ **Variables de entorno** para secrets (no hardcoded)

## 10. Dependencias Principales

```yaml
dependencies:
  flutter_riverpod: ^2.6.1        # Estado reactivo
  supabase_flutter: ^2.10.2       # Backend
  google_generative_ai: ^0.4.6    # IA
  flutter_map: ^7.1.0             # Mapas
  geolocator: ^13.0.2             # GPS
  get_it: ^8.0.3                  # DI
  dartz: ^0.10.1                  # Programación funcional
  flutter_local_notifications: ^18.0.1
```

## 11. Ventajas Técnicas

1. **Multiplataforma** - Un código, 5 plataformas (Android, iOS, Web, Windows, macOS)
2. **Arquitectura escalable** - Clean Architecture permite agregar features fácilmente
3. **Backend serverless** - Supabase maneja infraestructura, escalado automático
4. **Realtime** - Notificaciones instantáneas sin polling
5. **IA integrada** - Gemini proporciona asesoría inteligente
6. **Geolocalización** - Búsqueda de refugios cercanos
7. **Seguridad robusta** - RLS garantiza acceso correcto a datos

## 12. Métricas del Proyecto

- **Líneas de código:** ~15,000
- **Archivos Dart:** 120+
- **Tiempo de compilación APK:** ~97 segundos
- **Tamaño APK:** 54MB
- **Plataformas soportadas:** 5 (Android, iOS, Web, Windows, macOS)
- **Features implementados:** 7 módulos completos

## 13. Posibles Mejoras Futuras

- [ ] Chat directo refugio-adoptante
- [ ] Sistema de favoritos
- [ ] Historial de adopciones completadas
- [ ] Valoraciones y reviews
- [ ] Notificaciones push (FCM)
- [ ] Filtros avanzados (edad, tamaño, temperamento)
- [ ] Modo oscuro
- [ ] Multi-idioma (i18n)

---

## Conclusión

PetAdopt es una aplicación completa que implementa las mejores prácticas de desarrollo móvil moderno: arquitectura limpia, seguridad robusta, backend escalable y experiencia de usuario intuitiva. El uso de Flutter permite desplegar en múltiples plataformas con un solo código base, mientras que Supabase proporciona un backend potente sin necesidad de mantener servidores propios.

**Estado:** ✅ Funcional y listo para producción

**Desarrollado por:** Axel Pastillo  
**Fecha:** Enero 2026  
**Framework:** Flutter 3.x + Supabase
