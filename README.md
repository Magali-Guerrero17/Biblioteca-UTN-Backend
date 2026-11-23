# BiblioFRT - Backend

API REST del sistema de gestión de la biblioteca de la Universidad Tecnológica Nacional, Facultad Regional Tucumán (UTN FRT). Desarrollada por el Grupo 5 con NestJS.

## Integrantes

- Lopez Claudia Susana
- Guerrero Magali
- Najera Esteban

## Tecnologías

- NestJS
- TypeScript
- Prisma
- PostgreSQL

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

3. Crear la base de datos en PostgreSQL:

```sql
CREATE DATABASE bibliofrt;
```

Luego ejecutar el archivo `bibliofrt.sql` sobre esa base (por ejemplo, desde HeidiSQL con Archivo → Ejecutar archivo SQL) para crear las tablas con sus datos.

4. Crear un archivo `.env` en la raíz del proyecto con la conexión a la base de datos:

```env
DATABASE_URL="postgresql://postgres:CONTRASEÑA@localhost:5432/bibliofrt?schema=public"
PORT=3000
```

Reemplazar `CONTRASEÑA` por la contraseña del usuario `postgres`. El archivo `.env` no se sube al repositorio.

5. Levantar el servidor en modo desarrollo:

```bash
npm run start:dev
```

El servidor queda disponible en `http://localhost:3000`.

## Estructura de carpetas

```
Biblioteca-UTN-Backend/
├── src/
│   ├── main.ts
│   └── modules/
│       ├── alumnos/
│       ├── app/
│       ├── auth/
│       ├── categorias/
│       ├── libros/
│       ├── prestamos/
│       └── users/
├── .env
├── package.json
└── README.md
```

`main.ts` permanece en `src`. Cada módulo se generó con `npx nest g resource modules/nombre-modulo` (API REST con CRUD) e incluye su controlador, servicio, módulo y DTOs.

## Módulos

| Módulo | Descripción |
|--------|-------------|
| app | Módulo raíz de la aplicación |
| alumnos | Gestión de los alumnos de la biblioteca |
| auth | Registro e ingreso de usuarios |
| categorias | Categorías para clasificar los libros |
| libros | Gestión del catálogo de libros |
| prestamos | Registro de préstamos y devoluciones |
| users | Gestión de los usuarios del sistema y sus roles |

## Estrategia de ramas

| Rama | Uso |
|------|-----|
| `main` | Versión estable y final |
| `dev` | Integración del trabajo del equipo |
| `feature/*` | Nuevas funcionalidades |
| `fix/*` | Corrección de errores |
| `refactor/*` | Mejoras internas del código |
| `docs/*` | Documentación |

Flujo de trabajo: cada integrante trabaja en su propia rama, sube los cambios a `dev` mediante Pull Request y, una vez probados, `dev` se integra en `main`.
