import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreateUserDto } from './dto/create-user.dto.js';
import { UpdateUserDto } from './dto/update-user.dto.js';
import { hashPassword } from '../auth/password.util.js';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    await this.validateUsuario(createUserDto.usuario);

    return this.prisma.usuario.create({
      data: {
        usuario: createUserDto.usuario,
        passwordHash: await hashPassword(createUserDto.password),
        rolId: createUserDto.rolId,
        alumnoId: createUserDto.alumnoId,
      },
      select: {
        id: true,
        usuario: true,
        rolId: true,
        alumnoId: true,
        activo: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  findAll() {
    return this.prisma.usuario.findMany({
      where: { activo: true },
      select: {
        id: true,
        usuario: true,
        rolId: true,
        alumnoId: true,
        activo: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  async findOne(id: number) {
    const usuario = await this.prisma.usuario.findUnique({
      where: { id },
      select: {
        id: true,
        usuario: true,
        rolId: true,
        alumnoId: true,
        activo: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!usuario || !usuario.activo) {
      throw new NotFoundException(`No existe un usuario con id ${id}.`);
    }

    return usuario;
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    await this.findOne(id);

    if (updateUserDto.usuario) {
      await this.validateUsuario(updateUserDto.usuario, id);
    }

const passwordHash = updateUserDto.password
  ? await hashPassword(updateUserDto.password)
  : undefined;

    return this.prisma.usuario.update({
      where: { id },
      data: {
        usuario: updateUserDto.usuario,
        passwordHash,
        rolId: updateUserDto.rolId,
        alumnoId: updateUserDto.alumnoId,
      },
      select: {
        id: true,
        usuario: true,
        rolId: true,
        alumnoId: true,
        activo: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  async remove(id: number) {
    await this.findOne(id);

    return this.prisma.usuario.update({
      where: { id },
      data: { activo: false },
      select: {
        id: true,
        usuario: true,
        rolId: true,
        alumnoId: true,
        activo: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  private async validateUsuario(usuario: string, usuarioId?: number) {
    const existente = await this.prisma.usuario.findUnique({
      where: { usuario },
      select: { id: true },
    });

    if (existente && existente.id !== usuarioId) {
      throw new ConflictException('Ya existe un usuario con ese nombre.');
    }
  }
}