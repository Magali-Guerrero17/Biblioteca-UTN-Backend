-- CreateTable
CREATE TABLE "Autor" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Autor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Categoria" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(60) NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Categoria_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Carrera" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(60) NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Carrera_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rol" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(30) NOT NULL,
    "descripcion" VARCHAR(120),
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Rol_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Libro" (
    "id" SERIAL NOT NULL,
    "titulo" VARCHAR(200) NOT NULL,
    "isbn" VARCHAR(13) NOT NULL,
    "total" INTEGER NOT NULL,
    "autorId" INTEGER NOT NULL,
    "categoriaId" INTEGER NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Libro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alumno" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(60) NOT NULL,
    "apellido" VARCHAR(60) NOT NULL,
    "legajo" VARCHAR(15) NOT NULL,
    "correo" VARCHAR(120) NOT NULL,
    "carreraId" INTEGER NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Alumno_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Usuario" (
    "id" SERIAL NOT NULL,
    "usuario" VARCHAR(30) NOT NULL,
    "passwordHash" VARCHAR(255) NOT NULL,
    "rolId" INTEGER NOT NULL,
    "alumnoId" INTEGER,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Prestamo" (
    "id" SERIAL NOT NULL,
    "alumnoId" INTEGER NOT NULL,
    "libroId" INTEGER NOT NULL,
    "fechaSolicitud" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaPrestamo" DATE,
    "fechaDevolucion" DATE,
    "fechaDevolucionReal" DATE,
    "renovado" BOOLEAN NOT NULL DEFAULT false,
    "estado" VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Prestamo_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Autor_nombre_key" ON "Autor"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Categoria_nombre_key" ON "Categoria"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Carrera_nombre_key" ON "Carrera"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Rol_nombre_key" ON "Rol"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Libro_isbn_key" ON "Libro"("isbn");

-- CreateIndex
CREATE UNIQUE INDEX "Alumno_legajo_key" ON "Alumno"("legajo");

-- CreateIndex
CREATE UNIQUE INDEX "Alumno_correo_key" ON "Alumno"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_usuario_key" ON "Usuario"("usuario");

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_alumnoId_key" ON "Usuario"("alumnoId");

-- AddForeignKey
ALTER TABLE "Libro" ADD CONSTRAINT "Libro_autorId_fkey" FOREIGN KEY ("autorId") REFERENCES "Autor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Libro" ADD CONSTRAINT "Libro_categoriaId_fkey" FOREIGN KEY ("categoriaId") REFERENCES "Categoria"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alumno" ADD CONSTRAINT "Alumno_carreraId_fkey" FOREIGN KEY ("carreraId") REFERENCES "Carrera"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Usuario" ADD CONSTRAINT "Usuario_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES "Rol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Usuario" ADD CONSTRAINT "Usuario_alumnoId_fkey" FOREIGN KEY ("alumnoId") REFERENCES "Alumno"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prestamo" ADD CONSTRAINT "Prestamo_alumnoId_fkey" FOREIGN KEY ("alumnoId") REFERENCES "Alumno"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prestamo" ADD CONSTRAINT "Prestamo_libroId_fkey" FOREIGN KEY ("libroId") REFERENCES "Libro"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
