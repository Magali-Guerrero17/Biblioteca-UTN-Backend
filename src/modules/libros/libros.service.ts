import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreateLibroDto } from './dto/create-libro.dto.js';
import { UpdateLibroDto } from './dto/update-libro.dto.js';

@Injectable()
export class LibrosService {
  // Inyección de dependencias: Nest nos entrega PrismaService ya listo.
  constructor(private readonly prisma: PrismaService) {}

  // Crea un libro. Antes revisa que el ISBN no esté repetido (409).
  async create(createLibroDto: CreateLibroDto) {
    await this.validateIsbn(createLibroDto.isbn);

    return this.prisma.libro.create({ data: createLibroDto });
  }

  // Lista solo los libros activos, con autor, categoría y préstamos.
  // Con map, a cada libro le agrega "disponibles" (no está en la base).
  async findAll() {
    const libros = await this.prisma.libro.findMany({
      where: { activo: true },
      include: { autor: true, categoria: true, prestamos: true },
    });

    return libros.map((libro) => {
      // Cuenta los préstamos que tienen un ejemplar ocupado
      const ocupados = libro.prestamos.filter(
        (prestamo) =>
          prestamo.estado === 'Pendiente' || prestamo.estado === 'Activo',
      ).length;

      return {
        id: libro.id,
        titulo: libro.titulo,
        isbn: libro.isbn,
        total: libro.total,
        autorId: libro.autorId,
        categoriaId: libro.categoriaId,
        activo: libro.activo,
        createdAt: libro.createdAt,
        updatedAt: libro.updatedAt,
        autor: libro.autor,
        categoria: libro.categoria,
        prestamos: libro.prestamos,
        disponibles: libro.total - ocupados,
      };
    });
  }

  // Busca un libro por id. Si no existe o está dado de baja, da 404.
  async findOne(id: number) {
    const libro = await this.prisma.libro.findUnique({
      where: { id },
      include: { autor: true, categoria: true, prestamos: true },
    });

    if (!libro || !libro.activo) {
      throw new NotFoundException(`No existe un libro con id ${id}.`);
    }

    // Misma cuenta que en findAll, pero para un solo libro
    const ocupados = libro.prestamos.filter(
      (prestamo) =>
        prestamo.estado === 'Pendiente' || prestamo.estado === 'Activo',
    ).length;

    return {
      id: libro.id,
      titulo: libro.titulo,
      isbn: libro.isbn,
      total: libro.total,
      autorId: libro.autorId,
      categoriaId: libro.categoriaId,
      activo: libro.activo,
      createdAt: libro.createdAt,
      updatedAt: libro.updatedAt,
      autor: libro.autor,
      categoria: libro.categoria,
      prestamos: libro.prestamos,
      disponibles: libro.total - ocupados,
    };
  }

  // Modifica un libro. Primero comprueba que exista (404).
  // Si vino un ISBN nuevo, revisa que no lo tenga otro libro (409).
  async update(id: number, updateLibroDto: UpdateLibroDto) {
    await this.findOne(id);

    if (updateLibroDto.isbn) {
      await this.validateIsbn(updateLibroDto.isbn, id);
    }

    return this.prisma.libro.update({
      where: { id },
      data: updateLibroDto,
    });
  }

  // Borrado lógico: no elimina la fila, la marca con activo: false.
  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.libro.update({
      where: { id },
      data: { activo: false },
    });
  }

  // Lanza 409 si ya existe otro libro con ese ISBN.
  // libroId es opcional: en el update sirve para no chocar consigo mismo.
  private async validateIsbn(isbn: string, libroId?: number) {
    const existingBook = await this.prisma.libro.findUnique({
      where: { isbn },
      select: { id: true },
    });

    if (existingBook && existingBook.id !== libroId) {
      throw new ConflictException('Ya existe un libro con ese ISBN.');
    }
  }
}