# Actualización de Base de Datos - Perfil de Refugios

## Ejecuta estos comandos SQL en Supabase SQL Editor:

```sql
-- Agregar nuevos campos a la tabla users
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS phone TEXT,
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

-- Crear índice para búsquedas de refugios con ubicación
CREATE INDEX IF NOT EXISTS idx_users_role_location 
ON users(role, latitude, longitude) 
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- Comentarios para documentación
COMMENT ON COLUMN users.phone IS 'Teléfono de contacto del usuario/refugio';
COMMENT ON COLUMN users.description IS 'Descripción o información sobre el refugio/usuario';
COMMENT ON COLUMN users.address IS 'Dirección física del refugio';
COMMENT ON COLUMN users.latitude IS 'Latitud de la ubicación del refugio';
COMMENT ON COLUMN users.longitude IS 'Longitud de la ubicación del refugio';
```

## Políticas RLS (Row Level Security)

Si aún no tienes políticas RLS, agrégalas:

```sql
-- Permitir a usuarios autenticados leer todos los perfiles de refugios
CREATE POLICY IF NOT EXISTS "Shelters profiles are viewable by everyone"
ON users FOR SELECT
USING (role = 'shelter');

-- Permitir a usuarios actualizar solo su propio perfil
CREATE POLICY IF NOT EXISTS "Users can update own profile"
ON users FOR UPDATE
USING (auth.uid() = id);
```

## Verificar cambios

```sql
-- Ver la estructura actualizada de la tabla
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users';

-- Ver refugios con ubicación
SELECT id, full_name, address, latitude, longitude 
FROM users 
WHERE role = 'shelter' AND latitude IS NOT NULL;
```
