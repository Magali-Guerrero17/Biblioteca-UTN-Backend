import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreatePrestamoDto } from './dto/create-prestamo.dto.js';
import { UpdatePrestamoDto } from './dto/update-prestamo.dto.js';

@Injectable()
export class PrestamosService {
  constructor(private readonly prisma: PrismaService) {}

  create(createPrestamoDto: CreatePrestamoDto) {
    return this.prisma.prestamo.create({
      data: {
        alumnoId: createPrestamoDto.alumnoId,
        libroId: createPrestamoDto.libroId,
      },
    });
  }

  findAll() {
    return this.prisma.prestamo.findMany({
      where: { activo: true },
      include: { alumno: true, libro: true },
    });
  }

  async findOne(id: number) {
    const prestamo = await this.prisma.prestamo.findUnique({
      where: { id },
      include: { alumno: true, libro: true },
    });

    if (!prestamo || !prestamo.activo) {
      throw new NotFoundException(`No existe un préstamo con id ${id}.`);
    }

    return prestamo;
  }

  async update(id: number, updatePrestamoDto: UpdatePrestamoDto) {
    await this.findOne(id);

    return this.prisma.prestamo.update({
      where: { id },
      data: updatePrestamoDto,
    });
  }

  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.prestamo.update({
      where: { id },
      data: { activo: false },
    });
  }
}