import { Injectable } from '@nestjs/common';
import { CreateCategoriaDto } from './dto/create-categoria.dto.js';
import { UpdateCategoriaDto } from './dto/update-categoria.dto.js';

@Injectable()
export class CategoriasService {
  create(createCategoriaDto: CreateCategoriaDto) {
    return 'Esta accion añade una nueva categoria';
  }

  findAll() {
    return `Esta accion devuelve todas las categorias`;
  }

  findOne(id: number) {
    return `Esta accion devuelve una #${id} categoria`;
  }

  update(id: number, updateCategoriaDto: UpdateCategoriaDto) {
    return `Esta accion actualiza una #${id} categoria`;
  }

  remove(id: number) {
    return `Esta accion elimina una #${id} categoria`;
  }
}
