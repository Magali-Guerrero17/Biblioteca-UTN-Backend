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
  constructor(private readonly prisma: PrismaService) {}

  async create(createLibroDto: CreateLibroDto) {
    await this.validateIsbn(createLibroDto.isbn);

    return this.prisma.libro.create({ data: createLibroDto });
  }

  async findAll() {
    const libros = await this.prisma.libro.findMany({
      where: { activo: true },
      include: { autor: true, categoria: true, prestamos: true },
    });

    return libros.map((libro) => {
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

  async findOne(id: number) {
    const libro = await this.prisma.libro.findUnique({
      where: { id },
      include: { autor: true, categoria: true, prestamos: true },
    });

    if (!libro || !libro.activo) {
      throw new NotFoundException(`No existe un libro con id ${id}.`);
    }

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

  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.libro.update({
      where: { id },
      data: { activo: false },
    });
  }

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