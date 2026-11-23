import { Injectable } from '@nestjs/common';
import { CreateLibroDto } from './dto/create-libro.dto.js';
import { UpdateLibroDto } from './dto/update-libro.dto.js';

@Injectable()
export class LibrosService {
  create(createLibroDto: CreateLibroDto) {
    return 'Esta accion añade un nuevo libro';
  }

  findAll() {
    return `Esta accion devuelve todos los libros`;
  }

  findOne(id: number) {
    return `Esta accion devuelve un #${id} libro`;
  }

  update(id: number, updateLibroDto: UpdateLibroDto) {
    return `Esta accion actualiza un #${id} libro`;
  }

  remove(id: number) {
    return `Esta accion elimina un #${id} libro`;
  }
}
