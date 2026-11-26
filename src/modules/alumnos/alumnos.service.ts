import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreateAlumnoDto } from './dto/create-alumno.dto.js';
import { UpdateAlumnoDto } from './dto/update-alumno.dto.js';

@Injectable()
export class AlumnosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createAlumnoDto: CreateAlumnoDto) {
    await this.validateLegajo(createAlumnoDto.legajo);
    await this.validateCorreo(createAlumnoDto.correo);

    return this.prisma.alumno.create({ data: createAlumnoDto });
  }

  findAll() {
    return this.prisma.alumno.findMany({
      where: { activo: true },
      include: { carrera: true },
    });
  }

  async findOne(id: number) {
    const alumno = await this.prisma.alumno.findUnique({ where: { id } });

    if (!alumno || !alumno.activo) {
      throw new NotFoundException(`No existe un alumno con id ${id}.`);
    }

    return alumno;
  }

  async update(id: number, updateAlumnoDto: UpdateAlumnoDto) {
    await this.findOne(id);

    if (updateAlumnoDto.legajo) {
      await this.validateLegajo(updateAlumnoDto.legajo, id);
    }

    if (updateAlumnoDto.correo) {
      await this.validateCorreo(updateAlumnoDto.correo, id);
    }

    return this.prisma.alumno.update({
      where: { id },
      data: updateAlumnoDto,
    });
  }

  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.alumno.update({
      where: { id },
      data: { activo: false },
    });
  }

  private async validateLegajo(legajo: string, alumnoId?: number) {
    const existingAlumno = await this.prisma.alumno.findUnique({
      where: { legajo },
      select: { id: true },
    });

    if (existingAlumno && existingAlumno.id !== alumnoId) {
      throw new ConflictException('Ya existe un alumno con ese legajo.');
    }
  }

  private async validateCorreo(correo: string, alumnoId?: number) {
    const existingAlumno = await this.prisma.alumno.findUnique({
      where: { correo },
      select: { id: true },
    });

    if (existingAlumno && existingAlumno.id !== alumnoId) {
      throw new ConflictException('Ya existe un alumno con ese correo.');
    }
  }
}