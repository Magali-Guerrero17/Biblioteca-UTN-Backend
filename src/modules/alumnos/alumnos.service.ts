import { Injectable } from '@nestjs/common';
import { CreateAlumnoDto } from './dto/create-alumno.dto.js';
import { UpdateAlumnoDto } from './dto/update-alumno.dto.js';

@Injectable()
export class AlumnosService {
  create(createAlumnoDto: CreateAlumnoDto) {
    return 'Esta accion añade un nuevo alumno';
  }

  findAll() {
    return `Esta accion devuelve todos losalumnos`;
  }

  findOne(id: number) {
    return `Esta accion devuelve un #${id} alumno`;
  }

  update(id: number, updateAlumnoDto: UpdateAlumnoDto) {
    return `Esta accion actualiza un #${id} alumno`;
  }

  remove(id: number) {
    return `Esta accion elimina un #${id} alumno`;
  }
}
