import { Injectable } from '@nestjs/common';
import { CreateAuthDto } from './dto/create-auth.dto.js';

@Injectable()
export class AuthService {
  register(createAuthDto: CreateAuthDto) {
    return 'This action registers a new user';
  }

  login(createAuthDto: CreateAuthDto) {
    return 'This action logs in a user';
  }
}