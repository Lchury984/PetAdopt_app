# 🐾 PetAdopt - Guía de Configuración Completa

## ✅ Estado del Proyecto
**Proyecto funcional y listo para usar**

La aplicación PetAdopt está completamente configurada y lista para usar. Todas las funcionalidades principales están implementadas y funcionando correctamente.

## 📋 Funcionalidades Implementadas

### 1. Autenticación ✅
- ✅ Registro de adoptantes
- ✅ Registro de refugios (con geolocalización)
- ✅ Login con email/contraseña
- ✅ Recuperación de contraseña
- ✅ Logout
- ✅ Persistencia de sesión

### 2. Gestión de Mascotas ✅
- ✅ Crear nuevas mascotas (refugios)
- ✅ Ver listado de mascotas
- ✅ Ver detalles de mascota
- ✅ Actualizar información de mascotas
- ✅ Eliminar mascotas
- ✅ Subir fotos de mascotas a Supabase Storage

### 3. Solicitudes de Adopción ✅
- ✅ Crear solicitudes de adopción (adoptantes)
- ✅ Ver solicitudes realizadas
- ✅ Aprobar/rechazar solicitudes (refugios)
- ✅ Notificaciones en tiempo real
- ✅ Estado de solicitudes (pendiente, aprobada, rechazada)

### 4. Chat con IA (Gemini) ✅
- ✅ Chat inteligente sobre adopción de mascotas
- ✅ Recomendaciones personalizadas
- ✅ Historial de conversación
- ✅ Interfaz moderna con burbujas de chat

### 5. Mapa de Refugios ✅
- ✅ Visualización de refugios en mapa
- ✅ Geolocalización del usuario
- ✅ Cálculo de distancia a refugios
- ✅ Información detallada de cada refugio

### 6. Notificaciones ✅
- ✅ Notificaciones push para solicitudes
- ✅ Notificaciones en tiempo real
- ✅ Sistema de permisos

## 🔧 Configuración Inicial

### 1. Archivo .env

El proyecto ya tiene configurado el archivo `.env`:

```env
SUPABASE_URL=https://iyjjvljjlozigcouztta.supabase.co
SUPABASE_ANON_KEY=sb_publishable_QQ-o8NteInSxHBKatMHFGA_oiPMPpHA
GEMINI_API_KEY=AIzaSyAaksUtGm9l9PV4PjqNFJIA4eFZhhy0POg
```

### 2. Dependencias

Instalar dependencias:
```bash
flutter pub get
```

### 3. Base de Datos Supabase

#### Tablas ya configuradas:
- ✅ `profiles` - Perfiles de usuarios
- ✅ `mascotas` - Información de mascotas
- ✅ `solicitudes_adopcion` - Solicitudes de adopción

#### SQL para crear las tablas (si necesitas recrearlas):

```sql
-- Tabla de perfiles
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  email TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('adoptante', 'refugio')),
  telefono TEXT,
  nombre_refugio TEXT,
  direccion TEXT,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de mascotas
CREATE TABLE mascotas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  refugio_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  tipo TEXT NOT NULL,
  raza TEXT,
  edad INTEGER,
  sexo TEXT,
  descripcion TEXT,
  foto_url TEXT,
  disponible BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de solicitudes de adopción
CREATE TABLE solicitudes_adopcion (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mascota_id UUID REFERENCES mascotas(id) ON DELETE CASCADE,
  adoptante_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  refugio_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'aprobada', 'rechazada')),
  mensaje TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Políticas RLS (Row Level Security)

-- Perfiles: todos pueden leer, solo el dueño puede actualizar
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Perfiles públicos visibles para todos"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Mascotas: todos pueden leer, solo refugios pueden crear/modificar
ALTER TABLE mascotas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Mascotas visibles para todos"
  ON mascotas FOR SELECT
  USING (true);

CREATE POLICY "Refugios pueden crear mascotas"
  ON mascotas FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND rol = 'refugio'
    )
  );

CREATE POLICY "Refugios pueden actualizar sus mascotas"
  ON mascotas FOR UPDATE
  USING (refugio_id = auth.uid());

CREATE POLICY "Refugios pueden eliminar sus mascotas"
  ON mascotas FOR DELETE
  USING (refugio_id = auth.uid());

-- Solicitudes: adoptantes ven las suyas, refugios ven las de sus mascotas
ALTER TABLE solicitudes_adopcion ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Adoptantes ven sus solicitudes"
  ON solicitudes_adopcion FOR SELECT
  USING (adoptante_id = auth.uid());

CREATE POLICY "Refugios ven solicitudes de sus mascotas"
  ON solicitudes_adopcion FOR SELECT
  USING (refugio_id = auth.uid());

CREATE POLICY "Adoptantes pueden crear solicitudes"
  ON solicitudes_adopcion FOR INSERT
  WITH CHECK (adoptante_id = auth.uid());

CREATE POLICY "Refugios pueden actualizar estado de solicitudes"
  ON solicitudes_adopcion FOR UPDATE
  USING (refugio_id = auth.uid());
```

#### Storage Bucket para fotos:

```sql
-- Crear bucket público para fotos de mascotas
INSERT INTO storage.buckets (id, name, public)
VALUES ('mascotas', 'mascotas', true);

-- Política para permitir subir fotos
CREATE POLICY "Refugios pueden subir fotos"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'mascotas' AND
  auth.role() = 'authenticated'
);

-- Política para leer fotos (público)
CREATE POLICY "Fotos públicas"
ON storage.objects FOR SELECT
USING (bucket_id = 'mascotas');
```

## 🚀 Cómo Ejecutar la App

### Modo Debug (Desarrollo)
```bash
# En Android/iOS
flutter run

# En Web
flutter run -d chrome
```

### Modo Release (APK para producción)
```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Flujo de Usuario

### Para Adoptantes:
1. Registrarse como adoptante
2. Ver listado de mascotas disponibles
3. Ver detalles de mascota
4. Solicitar adopción
5. Ver estado de solicitudes
6. Chatear con IA sobre cuidados
7. Ver refugios cercanos en el mapa

### Para Refugios:
1. Registrarse como refugio (con ubicación)
2. Agregar mascotas con fotos
3. Gestionar mascotas (editar/eliminar)
4. Recibir solicitudes de adopción
5. Aprobar o rechazar solicitudes
6. Ver estadísticas
7. Recibir notificaciones en tiempo real

## 🐛 Solución de Problemas

### Error: "Supabase no inicializado"
**Solución:** Asegúrate de que el archivo `.env` existe en la raíz del proyecto con las credenciales correctas.

### Error: "No se pueden cargar las imágenes"
**Solución:** Verifica que el bucket `mascotas` existe en Supabase Storage y tiene permisos públicos.

### Error: "No llegan notificaciones"
**Solución:** Verifica que los permisos de notificación están activados en el dispositivo.

### La app se cierra al iniciar
**Solución:** Ejecuta `flutter clean && flutter pub get` y vuelve a compilar.

## 📊 Estructura del Proyecto

```
lib/
├── core/                    # Funcionalidades compartidas
│   ├── config/             # Configuración de Supabase
│   ├── constants/          # Constantes globales
│   ├── services/           # Servicios (notificaciones, storage)
│   ├── theme/              # Temas y estilos
│   └── widgets/            # Widgets reutilizables
├── features/               # Características por módulo
│   ├── auth/              # Autenticación
│   ├── chat/              # Chat con IA
│   ├── home/              # Pantallas principales
│   ├── map/               # Mapa de refugios
│   └── mascota/           # Gestión de mascotas
└── main.dart              # Punto de entrada
```

## 🎯 Próximos Pasos (Mejoras Futuras)

- [ ] Sistema de favoritos
- [ ] Filtros avanzados de búsqueda
- [ ] Chat directo entre adoptante y refugio
- [ ] Historial de adopciones
- [ ] Sistema de valoraciones
- [ ] Compartir mascotas en redes sociales
- [ ] Modo oscuro
- [ ] Soporte multi-idioma

## 📄 Licencia

Proyecto educativo - Libre uso

## 👨‍💻 Desarrollador

Axel Pastillo

---

**¡La app está lista para usar! 🎉**

Si tienes dudas, revisa este documento o contacta al desarrollador.
