import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service.js';
import { isPrismaUniqueConstraintError } from '../prisma/prisma-error.util.js';
import { LoginAuthDto } from './dto/login-auth.dto.js';
import { RegisterAuthDto } from './dto/register-auth.dto.js';
import { hashPassword, verifyPassword } from './password.util.js';

@Injectable()
export class AuthService {
  // Inyección de dependencias: Nest nos entrega PrismaService y JwtService ya listos.
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  // Registra un alumno: crea el alumno y después su usuario (el usuario es el legajo).
  async register(registerAuthDto: RegisterAuthDto) {
    const passwordHash = await hashPassword(registerAuthDto.password);

    try {
      const alumno = await this.prisma.alumno.create({
        data: {
          nombre: registerAuthDto.nombre,
          apellido: registerAuthDto.apellido,
          legajo: registerAuthDto.legajo,
          correo: registerAuthDto.correo,
          carreraId: registerAuthDto.carreraId,
        },
      });

      const user = await this.prisma.usuario.create({
        data: {
          usuario: registerAuthDto.legajo,
          passwordHash,
          rolId: 1,
          alumnoId: alumno.id,
        },
        select: {
          id: true,
          usuario: true,
          rolId: true,
          alumnoId: true,
          activo: true,
          createdAt: true,
          updatedAt: true,
          alumno: true,
        },
      });

      return user;
    } catch (error) {
      if (isPrismaUniqueConstraintError(error)) {
        throw new ConflictException(
          'Ya existe un alumno con ese legajo o ese correo.',
        );
      }

      throw error;
    }
  }

  // Verifica usuario y contraseña y, si están bien, devuelve un JWT.
  async login(loginAuthDto: LoginAuthDto) {
    const user = await this.prisma.usuario.findUnique({
      where: { usuario: loginAuthDto.usuario },
      include: { rol: true, alumno: true },
    });

    if (
      !user ||
      !user.activo ||
      !(await verifyPassword(loginAuthDto.password, user.passwordHash))
    ) {
      throw new UnauthorizedException('Usuario o contraseña incorrectos.');
    }

    const accessToken = await this.jwtService.signAsync({
      sub: user.id,
      usuario: user.usuario,
      rol: user.rol.nombre,
    });

    return {
      access_token: accessToken,
      usuario: {
        id: user.id,
        usuario: user.usuario,
        rol: user.rol.nombre,
        alumnoId: user.alumnoId,
        nombre: user.alumno ? user.alumno.nombre : user.usuario,
      },
    };
  }
}