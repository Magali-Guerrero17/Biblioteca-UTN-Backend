import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreateCategoriaDto } from './dto/create-categoria.dto.js';
import { UpdateCategoriaDto } from './dto/update-categoria.dto.js';

@Injectable()
export class CategoriasService {
  // Inyección de dependencias: Nest nos entrega PrismaService ya listo.
  constructor(private readonly prisma: PrismaService) {}

  // Crea una categoría. Antes revisa que el nombre no esté repetido (409).
  async create(createCategoriaDto: CreateCategoriaDto) {
    await this.validateNombre(createCategoriaDto.nombre);

    return this.prisma.categoria.create({ data: createCategoriaDto });
  }

  // Lista solo las categorías activas (las dadas de baja no aparecen).
  findAll() {
    return this.prisma.categoria.findMany({ where: { activo: true } });
  }

  // Busca una categoría por id. Si no existe o está dada de baja, da 404.
  async findOne(id: number) {
    const categoria = await this.prisma.categoria.findUnique({ where: { id } });

    if (!categoria || !categoria.activo) {
      throw new NotFoundException(`No existe una categoría con id ${id}.`);
    }

    return categoria;
  }

  // Modifica una categoría. Primero comprueba que exista (404).
  // Si vino un nombre nuevo, revisa que no lo tenga otra categoría (409).
  async update(id: number, updateCategoriaDto: UpdateCategoriaDto) {
    await this.findOne(id);

    if (updateCategoriaDto.nombre) {
      await this.validateNombre(updateCategoriaDto.nombre, id);
    }

    return this.prisma.categoria.update({
      where: { id },
      data: updateCategoriaDto,
    });
  }

  // Borrado lógico: no elimina la fila, la marca con activo: false.
  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.categoria.update({
      where: { id },
      data: { activo: false },
    });
  }

  // Lanza 409 si ya existe otra categoría con ese nombre.
  // categoriaId es opcional: en el update sirve para no chocar consigo misma.
  private async validateNombre(nombre: string, categoriaId?: number) {
    const existingCategoria = await this.prisma.categoria.findUnique({
      where: { nombre },
      select: { id: true },
    });

    if (existingCategoria && existingCategoria.id !== categoriaId) {
      throw new ConflictException('Ya existe una categoría con ese nombre.');
    }
  }
}