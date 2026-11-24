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
  // Inyección de dependencias: Nest nos entrega PrismaService ya listo.
  constructor(private readonly prisma: PrismaService) {}

  // Crea un alumno. Antes revisa que legajo y correo no estén repetidos (409).
  async create(createAlumnoDto: CreateAlumnoDto) {
    await this.validateLegajo(createAlumnoDto.legajo);
    await this.validateCorreo(createAlumnoDto.correo);

    return this.prisma.alumno.create({ data: createAlumnoDto });
  }

  // Lista solo los alumnos activos, e incluye los datos de su carrera.
  findAll() {
    return this.prisma.alumno.findMany({
      where: { activo: true },
      include: { carrera: true },
    });
  }

  // Busca un alumno por id. Si no existe o está dado de baja, da 404.
  async findOne(id: number) {
    const alumno = await this.prisma.alumno.findUnique({ where: { id } });

    if (!alumno || !alumno.activo) {
      throw new NotFoundException(`No existe un alumno con id ${id}.`);
    }

    return alumno;
  }

  // Modifica un alumno. Primero comprueba que exista (404).
  // Si vino un legajo o un correo nuevo, revisa que no lo tenga otro alumno (409).
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

  // Borrado lógico: no elimina la fila, la marca con activo: false.
  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.alumno.update({
      where: { id },
      data: { activo: false },
    });
  }

  // Lanza 409 si ya existe otro alumno con ese legajo.
  // alumnoId es opcional: en el update sirve para no chocar consigo mismo.
  private async validateLegajo(legajo: string, alumnoId?: number) {
    const existingAlumno = await this.prisma.alumno.findUnique({
      where: { legajo },
      select: { id: true },
    });

    if (existingAlumno && existingAlumno.id !== alumnoId) {
      throw new ConflictException('Ya existe un alumno con ese legajo.');
    }
  }

  // Lanza 409 si ya existe otro alumno con ese correo.
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