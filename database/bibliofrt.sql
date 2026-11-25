-- =====================================================================
-- BiblioFRT - Base de datos completa: estructura + datos de prueba (PostgreSQL)
-- Programación IV - UTN FRT - Grupo 5
--
-- Base normalizada en tercera forma normal (3FN):
-- - Cada dato se guarda en un solo lugar: autores, categorías, carreras y
--   roles tienen su propia tabla y las demás los referencian con una FK.
-- - No se guardan datos que se pueden calcular: la cantidad de ejemplares
--   disponibles de un libro es el total menos sus préstamos Pendientes y
--   Activos, y la calcula el backend.
-- - Todas las tablas tienen "activo" para el borrado lógico (nunca se
--   borra una fila: se pone activo = false), y createdAt / updatedAt.
--
-- Nombres: las tablas y columnas se llaman igual que los model y campos
-- de prisma/schema.prisma (como en el repo de la profe): tablas en
-- singular con mayúscula ("Libro") y columnas en camelCase ("autorId").
-- En PostgreSQL, un nombre con mayúsculas se escribe entre comillas
-- dobles; por ejemplo: SELECT * FROM "Libro";
--
-- Uso:
-- - Antes de Prisma (TP9 y TP10): crear la base vacía con
--     CREATE DATABASE bibliofrt;
--   conectarse a ella y ejecutar este archivo completo.
-- - Desde el TP11, las tablas las administra Prisma. Si la migración
--   inicial reinicia la base, ejecutar solo la PARTE 2 para volver a
--   cargar los datos.
-- =====================================================================

-- =====================================================================
-- PARTE 1: ESTRUCTURA
-- =====================================================================

-- Si las tablas ya existen, se borran para poder correr el script de nuevo
DROP TABLE IF EXISTS "Prestamo", "Usuario", "Alumno", "Libro", "Rol", "Carrera", "Categoria", "Autor" CASCADE;

-- ---------------------------------------------------------------------
-- Tablas sin claves foráneas (las "de apoyo")
-- ---------------------------------------------------------------------

CREATE TABLE "Autor" (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL UNIQUE,
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Categoria" (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(60)  NOT NULL UNIQUE,
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Carrera" (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(60)  NOT NULL UNIQUE,
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Rol" (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(30)  NOT NULL UNIQUE,
  descripcion VARCHAR(120),
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Libros: cada libro tiene un autor y una categoría.
-- No hay columna "disponibles": se calcula (3FN).
-- ---------------------------------------------------------------------

CREATE TABLE "Libro" (
  id           SERIAL PRIMARY KEY,
  titulo       VARCHAR(200) NOT NULL,
  isbn         VARCHAR(13)  NOT NULL UNIQUE,
  total        INTEGER      NOT NULL CHECK (total > 0),
  "autorId"     INTEGER      NOT NULL REFERENCES "Autor" (id),
  "categoriaId" INTEGER      NOT NULL REFERENCES "Categoria" (id),
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Alumnos: cada alumno pertenece a una carrera
-- ---------------------------------------------------------------------

CREATE TABLE "Alumno" (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(60)  NOT NULL,
  apellido    VARCHAR(60)  NOT NULL,
  legajo      VARCHAR(15)  NOT NULL UNIQUE,
  correo      VARCHAR(120) NOT NULL UNIQUE,
  "carreraId"  INTEGER      NOT NULL REFERENCES "Carrera" (id),
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Usuarios: cada usuario tiene un rol; si es alumno, apunta a su alumno
-- (el bibliotecario no es alumno, por eso alumno_id puede ser NULL).
-- La contraseña se guarda encriptada (passwordHash) desde el TP12.
-- ---------------------------------------------------------------------

CREATE TABLE "Usuario" (
  id            SERIAL PRIMARY KEY,
  usuario       VARCHAR(30)  NOT NULL UNIQUE,
  "passwordHash" VARCHAR(255) NOT NULL,
  "rolId"        INTEGER      NOT NULL REFERENCES "Rol" (id),
  "alumnoId"     INTEGER      UNIQUE REFERENCES "Alumno" (id),
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- Préstamos: un alumno pide un libro
--   Pendiente -> solicitado, todavía sin retirar (sin fecha de préstamo)
--   Activo    -> el alumno tiene el libro ("Vencido" no se guarda: es un
--                Activo con fecha_devolucion anterior a hoy)
--   Devuelto  -> el alumno lo devolvió (fecha_devolucion_real)
--   Cancelado -> la solicitud Pendiente se canceló
-- ---------------------------------------------------------------------

CREATE TABLE "Prestamo" (
  id                    SERIAL PRIMARY KEY,
  "alumnoId"             INTEGER     NOT NULL REFERENCES "Alumno" (id),
  "libroId"              INTEGER     NOT NULL REFERENCES "Libro" (id),
  "fechaSolicitud"       DATE        NOT NULL DEFAULT CURRENT_DATE,
  "fechaPrestamo"        DATE,
  "fechaDevolucion"      DATE,
  "fechaDevolucionReal" DATE,
  renovado              BOOLEAN     NOT NULL DEFAULT FALSE,
  estado                VARCHAR(20) NOT NULL DEFAULT 'Pendiente'
                        CHECK (estado IN ('Pendiente', 'Activo', 'Devuelto', 'Cancelado')),
  activo      BOOLEAN      NOT NULL DEFAULT TRUE,
  "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK ("fechaDevolucion" >= "fechaPrestamo")
);

-- =====================================================================
-- PARTE 2: DATOS DE PRUEBA
--
-- No se cargan los id: la base los genera solos (1, 2, 3...) en el orden
-- de cada INSERT, y las claves foráneas usan esos números.
-- updatedAt se carga explícito porque, en las tablas que crea Prisma,
-- esa columna no tiene valor por defecto.
-- Las fechas de los préstamos son relativas al día en que se corre
-- (CURRENT_DATE - 5 = hace 5 días): siempre hay uno al día y uno vencido.
-- =====================================================================


INSERT INTO "Autor" (nombre, "updatedAt") VALUES
  ('Robert C. Martin',     CURRENT_TIMESTAMP),  -- 1
  ('Ian Sommerville',      CURRENT_TIMESTAMP),  -- 2
  ('James Stewart',        CURRENT_TIMESTAMP),  -- 3
  ('Abraham Silberschatz', CURRENT_TIMESTAMP),  -- 4
  ('Andrew Tanenbaum',     CURRENT_TIMESTAMP),  -- 5
  ('Sears y Zemansky',     CURRENT_TIMESTAMP);  -- 6

INSERT INTO "Categoria" (nombre, "updatedAt") VALUES
  ('Programación',   CURRENT_TIMESTAMP),  -- 1
  ('Ingeniería',     CURRENT_TIMESTAMP),  -- 2
  ('Matemática',     CURRENT_TIMESTAMP),  -- 3
  ('Bases de datos', CURRENT_TIMESTAMP),  -- 4
  ('Sistemas',       CURRENT_TIMESTAMP),  -- 5
  ('Física',         CURRENT_TIMESTAMP);  -- 6

INSERT INTO "Carrera" (nombre, "updatedAt") VALUES
  ('Ing. en Sistemas', CURRENT_TIMESTAMP),  -- 1
  ('Ing. Civil',       CURRENT_TIMESTAMP),  -- 2
  ('Ing. Eléctrica',   CURRENT_TIMESTAMP),  -- 3
  ('Ing. Mecánica',    CURRENT_TIMESTAMP),  -- 4
  ('Ing. Química',     CURRENT_TIMESTAMP),  -- 5
  ('Ing. Electrónica', CURRENT_TIMESTAMP);  -- 6

INSERT INTO "Rol" (nombre, descripcion, "updatedAt") VALUES
  ('alumno',        'Alumno de la facultad',       CURRENT_TIMESTAMP),  -- 1
  ('bibliotecario', 'Gestiona libros y préstamos', CURRENT_TIMESTAMP),  -- 2
  ('docente',       'Docente de la facultad',      CURRENT_TIMESTAMP),  -- 3
  ('administrador', 'Administra el sistema',       CURRENT_TIMESTAMP),  -- 4
  ('invitado',      'Solo consulta el catálogo',   CURRENT_TIMESTAMP);  -- 5

-- Disponibles (calculado): 1 → 2 de 3 | 2 → 0 de 1 | 3 → 4 de 5 | 4 → 1 de 2 | 5 → 3 de 4 | 6 → 3 de 3
INSERT INTO "Libro" (titulo, isbn, total, "autorId", "categoriaId", "updatedAt") VALUES
  ('Clean Code',                    '9780132350884', 3, 1, 1, CURRENT_TIMESTAMP),  -- 1
  ('Ingeniería de Software',        '9786073206036', 1, 2, 2, CURRENT_TIMESTAMP),  -- 2
  ('Cálculo de una variable',       '9786075226392', 5, 3, 3, CURRENT_TIMESTAMP),  -- 3
  ('Fundamentos de Bases de Datos', '9788448190330', 2, 4, 4, CURRENT_TIMESTAMP),  -- 4
  ('Sistemas Operativos Modernos',  '9786073222471', 4, 5, 5, CURRENT_TIMESTAMP),  -- 5
  ('Física Universitaria',          '9786073221245', 3, 6, 6, CURRENT_TIMESTAMP);  -- 6

INSERT INTO "Alumno" (nombre, apellido, legajo, correo, "carreraId", "updatedAt") VALUES
  ('Lucía',     'Gómez',   '45012', 'lucia.gomez@ejemplo.com',     1, CURRENT_TIMESTAMP),  -- 1
  ('Martín',    'Rojas',   '45230', 'martin.rojas@ejemplo.com',    2, CURRENT_TIMESTAMP),  -- 2
  ('Sofía',     'Paz',     '44871', 'sofia.paz@ejemplo.com',       3, CURRENT_TIMESTAMP),  -- 3
  ('Tomás',     'Ledesma', '45544', 'tomas.ledesma@ejemplo.com',   4, CURRENT_TIMESTAMP),  -- 4
  ('Valentina', 'Cruz',    '45109', 'valentina.cruz@ejemplo.com',  5, CURRENT_TIMESTAMP),  -- 5
  ('Joaquín',   'Herrera', '44990', 'joaquin.herrera@ejemplo.com', 1, CURRENT_TIMESTAMP);  -- 6

-- Contraseña de todos: 1234, guardada encriptada con bcrypt (hash generado con PATCH /users/:id).
INSERT INTO "Usuario" (usuario, "passwordHash", "rolId", "alumnoId", "updatedAt") VALUES
  ('bibliotecario', '$2b$12$zyzum/0l47t0EQ8MtVzTdeYGZC8L8hAapOEiD9cUpLS/BKGaoJpla', 2, NULL, CURRENT_TIMESTAMP),
  ('45012',         '$2b$12$OC7IVXFc9C7neUb/N/Z.xeX5kky7c25GrGpEE8PtpFNCQBE2cnYsq', 1, 1,    CURRENT_TIMESTAMP),
  ('45230',         '$2b$12$oIRAYuZYE8oQLnhfaIFMSO.sohEmJl2r07sst/oI7c3LvLv6jCNJ.', 1, 2,    CURRENT_TIMESTAMP),
  ('44871',         '$2b$12$qtvCSA8YVIPjscRLmG1/ou0dwZjRiT/MFCbnP8G2Q20c7tj1hbQci', 1, 3,    CURRENT_TIMESTAMP),
  ('45544',         '$2b$12$6Baf.XbDmi59htL9j6Tmge35nl0VPExXYGM2Vsj0QGZxttRdFgg3W', 1, 4,    CURRENT_TIMESTAMP),
  ('45109',         '$2b$12$quLPPsf1MGHZoyvefD62buOXoumLg0gSr7CsGEa3CJ0HXayWApkqm', 1, 5,    CURRENT_TIMESTAMP),
  ('44990',         '$2b$12$RMZM3tDZ85eDJNX6ujbXm.NUF0iuSJblwxKNtB4KbO0BOIIVAO9ca', 1, 6,    CURRENT_TIMESTAMP);

-- Lucía (45012): un préstamo al día y uno devuelto
-- Sofía (44871): un préstamo vencido (no puede pedir más) y uno al día
-- Tomás (45544): sin préstamos
-- Valentina (45109): un préstamo ya renovado
-- Joaquín (44990): una solicitud pendiente de retirar
-- Martín (45230): un préstamo devuelto y una solicitud cancelada
INSERT INTO "Prestamo" ("alumnoId", "libroId", "fechaSolicitud", "fechaPrestamo", "fechaDevolucion", "fechaDevolucionReal", renovado, estado, "updatedAt") VALUES
  (1, 1, CURRENT_DATE - 6,  CURRENT_DATE - 5,  CURRENT_DATE + 9,  NULL,              FALSE, 'Activo',    CURRENT_TIMESTAMP),
  (3, 3, CURRENT_DATE - 25, CURRENT_DATE - 24, CURRENT_DATE - 10, NULL,              FALSE, 'Activo',    CURRENT_TIMESTAMP),
  (2, 2, CURRENT_DATE - 61, CURRENT_DATE - 60, CURRENT_DATE - 46, CURRENT_DATE - 48, FALSE, 'Devuelto',  CURRENT_TIMESTAMP),
  (3, 4, CURRENT_DATE - 9,  CURRENT_DATE - 8,  CURRENT_DATE + 6,  NULL,              FALSE, 'Activo',    CURRENT_TIMESTAMP),
  (5, 5, CURRENT_DATE - 17, CURRENT_DATE - 16, CURRENT_DATE + 5,  NULL,              TRUE,  'Activo',    CURRENT_TIMESTAMP),
  (1, 6, CURRENT_DATE - 81, CURRENT_DATE - 80, CURRENT_DATE - 66, CURRENT_DATE - 67, FALSE, 'Devuelto',  CURRENT_TIMESTAMP),
  (6, 2, CURRENT_DATE - 1,  NULL,              NULL,              NULL,              FALSE, 'Pendiente', CURRENT_TIMESTAMP),
  (2, 6, CURRENT_DATE - 20, NULL,              NULL,              NULL,              FALSE, 'Cancelado', CURRENT_TIMESTAMP);
