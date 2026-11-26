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
  constructor(private readonly prisma: PrismaService) {}

  async create(createCategoriaDto: CreateCategoriaDto) {
    await this.validateNombre(createCategoriaDto.nombre);

    return this.prisma.categoria.create({ data: createCategoriaDto });
  }

  findAll() {
    return this.prisma.categoria.findMany({ where: { activo: true } });
  }

  async findOne(id: number) {
    const categoria = await this.prisma.categoria.findUnique({ where: { id } });

    if (!categoria || !categoria.activo) {
      throw new NotFoundException(`No existe una categoría con id ${id}.`);
    }

    return categoria;
  }

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

  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.categoria.update({
      where: { id },
      data: { activo: false },
    });
  }

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