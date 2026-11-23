import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto.js';
import { UpdateUserDto } from './dto/update-user.dto.js';

@Injectable()
export class UsersService {
  create(createUserDto: CreateUserDto) {
    return 'Esta acción crea un nuevo usuario';
  }

  findAll() {
    return `Esta acción devuelve todos los usuarios`;
  }

  findOne(id: number) {
    return `Esta acción devuelve un usuario #${id}`;
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    return `Esta acción actualiza un usuario #${id}`;
  }

  remove(id: number) {
    return `Esta acción elimina un usuario #${id}`;
  }
}
