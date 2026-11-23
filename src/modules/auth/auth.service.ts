import { Injectable } from '@nestjs/common';
import { CreateAuthDto } from './dto/create-auth.dto.js';

@Injectable()
export class AuthService {
  register(createAuthDto: CreateAuthDto) {
    return 'Esta acción registra un nuevo usuario';
  }

  login(createAuthDto: CreateAuthDto) {
    return 'Esta acción inicia sesión con un usuario';
  }
}