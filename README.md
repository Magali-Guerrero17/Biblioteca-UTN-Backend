# BiblioFRT - Backend

API REST del sistema de gestión de la biblioteca de la Universidad Tecnológica Nacional, Facultad Regional Tucumán (UTN FRT). Desarrollada por el Grupo 5 con NestJS para la materia Programación IV.

## Integrantes

- Lopez Claudia Susana
- Guerrero Magali
- Najera Esteban

## Tecnologías

- NestJS
- TypeScript
- Prisma 7 (ORM)
- PostgreSQL
- class-validator y class-transformer (validación de datos)
- JWT y bcrypt (autenticación)
- Postman (pruebas y documentación de los endpoints)

## Requisitos previos

- Node.js (versión LTS)
- Git
- PostgreSQL (puerto 5432)
- Un cliente de base de datos, por ejemplo HeidiSQL

## Instalación y ejecución

1. Clonar el repositorio y entrar a la carpeta del proyecto:

```bash
git clone https://github.com/Magali-Guerrero17/Biblioteca-UTN-Backend.git
cd Biblioteca-UTN-Backend
```

2. Instalar las dependencias:

```bash
npm install
```

3. Crear la base de datos en PostgreSQL (por ejemplo, desde la pestaña Consulta de HeidiSQL):

```sql
CREATE DATABASE bibliofrt;
```

4. Crear un archivo `.env` en la raíz del proyecto, con las variables que se explican en la sección [Variables de entorno](#variables-de-entorno). El archivo `.env` no se sube al repositorio.

5. Generar el cliente de Prisma y crear las tablas con la migración:

```bash
npx prisma generate
npx prisma migrate dev
```

Si Prisma avisa que tiene que reiniciar la base ("We need to reset the public schema"), correr `npx prisma migrate reset`, confirmar y volver a ejecutar `npx prisma migrate dev`.

6. Cargar los datos de prueba: ejecutar sobre la base `bibliofrt` **solo la PARTE 2** del archivo `database/bibliofrt.sql` (desde el comentario "PARTE 2: DATOS DE PRUEBA" hasta el final). Las tablas ya las creó la migración.

7. Levantar el servidor en modo desarrollo:

```bash
npm run start:dev
```

El servidor queda disponible en `http://localhost:4000`.

## Variables de entorno

| Variable | Para qué sirve | Ejemplo |
|----------|----------------|---------|
| `PORT` | Puerto donde corre el servidor | `4000` |
| `DATABASE_URL` | Conexión a PostgreSQL: usuario, contraseña, puerto y base | `"postgresql://postgres:CONTRASEÑA@localhost:5432/bibliofrt?schema=public"` |
| `API_BASE_URL` | Dirección base de la API | `http://localhost:4000/` |
| `JWT_SECRET` | Clave secreta con la que se firman los tokens JWT | una cadena larga y al azar |

En `DATABASE_URL`, reemplazar `CONTRASEÑA` por la contraseña del usuario `postgres`. Los valores reales no se suben al repositorio.

## Base de datos

La base está normalizada en tercera forma normal (3FN) y tiene 8 tablas: `Autor`, `Categoria`, `Carrera`, `Rol`, `Libro`, `Alumno`, `Usuario` y `Prestamo`.

- Se diseñó a mano (`database/bibliofrt.sql`) y después se pasó a Prisma con una sola migración (`init`). Desde entonces, los cambios de estructura se hacen en `prisma/schema.prisma` con una nueva migración.
- Todas las tablas tienen el campo `activo`: el borrado es lógico (se pone `activo = false`, nunca se borra una fila).
- La cantidad de ejemplares disponibles de un libro no se guarda: se calcula (total menos préstamos Pendientes y Activos).
- Las contraseñas se guardan encriptadas con bcrypt en `passwordHash` y nunca se devuelven en las respuestas.

## Estructura de carpetas

```
Biblioteca-UTN-Backend/
├── database/
│   └── bibliofrt.sql        (estructura y datos de prueba)
├── prisma/
│   ├── migrations/          (historial de migraciones)
│   └── schema.prisma        (modelos de la base de datos)
├── src/
│   ├── main.ts
│   ├── generated/prisma/    (cliente de Prisma, se genera con npx prisma generate y no se sube)
│   └── modules/
│       ├── alumnos/
│       ├── app/
│       ├── auth/
│       ├── categorias/
│       ├── libros/
│       ├── prestamos/
│       ├── prisma/
│       └── users/
├── .env                     (no se sube)
├── prisma7.config.ts
├── package.json
└── README.md
```

`main.ts` permanece en `src`. Los módulos se generaron con `npx nest g resource modules/nombre-modulo` (API REST con CRUD). Cada uno tiene su módulo, su controlador (define las rutas), su servicio (la lógica, con Prisma) y sus DTOs (las validaciones). El módulo `prisma` se creó a mano y es global: ofrece la conexión a la base a los demás módulos.

## Módulos

| Módulo | Descripción |
|--------|-------------|
| app | Módulo raíz: conecta los demás módulos |
| prisma | Conexión a la base de datos (PrismaService) |
| auth | Registro e ingreso de usuarios con JWT |
| users | Gestión de los usuarios del sistema |
| alumnos | Gestión de los alumnos de la facultad |
| categorias | Categorías para clasificar los libros |
| libros | Catálogo de libros, con los ejemplares disponibles calculados |
| prestamos | Préstamos de libros a los alumnos |

## Endpoints

Base: `http://localhost:4000`

### Autenticación (`auth`)

| Método | Ruta | Qué hace |
|--------|------|----------|
| POST | `/auth/register` | Registra un alumno y crea su usuario (el usuario es el legajo) |
| POST | `/auth/login` | Verifica usuario y contraseña y devuelve un token JWT |

Body de `POST /auth/register`:

```json
{
  "nombre": "Ana",
  "apellido": "Pérez",
  "legajo": "45999",
  "correo": "ana.perez@ejemplo.com",
  "carreraId": 1,
  "password": "1234"
}
```

Body de `POST /auth/login`:

```json
{
  "usuario": "45012",
  "password": "1234"
}
```

La respuesta del login incluye `access_token` (el JWT, válido por 1 hora) y los datos de la sesión del usuario.

### Resto de los módulos (`users`, `alumnos`, `categorias`, `libros`, `prestamos`)

Todos tienen las mismas cinco rutas (en el ejemplo, `libros`):

| Método | Ruta | Qué hace |
|--------|------|----------|
| GET | `/libros` | Lista los registros activos |
| GET | `/libros/:id` | Devuelve uno (404 si no existe) |
| POST | `/libros` | Crea uno (los datos se validan con el DTO: 400 si no cumplen) |
| PATCH | `/libros/:id` | Modifica algunos campos |
| DELETE | `/libros/:id` | Lo da de baja (borrado lógico) |

`POST /users` se usa para crear usuarios que no son alumnos (por ejemplo, bibliotecario o docente). Los alumnos se registran con `POST /auth/register`.

Todos los endpoints están probados y documentados en la colección de Postman **BiblioFRT-backend**.

## Usuarios de prueba

| Usuario | Contraseña | Rol |
|---------|------------|-----|
| `bibliotecario` | `1234` | Bibliotecario |
| `45012` | `1234` | Alumna con préstamos |
| `44871` | `1234` | Alumna con un préstamo vencido |
| `45544` | `1234` | Alumno sin préstamos |

## Estrategia de ramas

| Rama | Uso |
|------|-----|
| `main` | Versión estable: una entrega por cada trabajo práctico |
| `dev` | Integración del trabajo del equipo |
| `feature/*` | Nuevas funcionalidades |
| `fix/*` | Corrección de errores |
| `refactor/*` | Mejoras internas del código |
| `docs/*` | Documentación |

Flujo de trabajo: cada integrante trabaja en su propia rama creada desde `dev`, sube los cambios a `dev` mediante Pull Request (lo revisa y lo integra otro integrante) y, al terminar cada trabajo práctico, `dev` se integra en `main`.