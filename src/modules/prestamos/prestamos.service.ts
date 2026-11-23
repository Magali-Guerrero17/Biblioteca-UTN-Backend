import { Injectable } from '@nestjs/common';
import { CreatePrestamoDto } from './dto/create-prestamo.dto.js';
import { UpdatePrestamoDto } from './dto/update-prestamo.dto.js';

@Injectable()
export class PrestamosService {
  create(createPrestamoDto: CreatePrestamoDto) {
    return 'Esta acción crea un nuevo prestamo';
  }

  findAll() {
    return `Esta acción devuelve todos los prestamos`;
  }

  findOne(id: number) {
    return `Esta acción devuelve un prestamo #${id} `;
  }

  update(id: number, updatePrestamoDto: UpdatePrestamoDto) {
    return `Esta acción actualiza el prestamo #${id}`;
  }

  remove(id: number) {
    return `Esta acción elimina el prestamo #${id}`;
  }
}
