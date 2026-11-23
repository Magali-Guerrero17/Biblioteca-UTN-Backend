import { Module } from '@nestjs/common';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { AuthModule } from '../auth/auth.module.js';
import { UsersModule } from '../users/users.module.js';
import { AlumnosModule } from '../alumnos/alumnos.module.js';
import { CategoriasModule } from '../categorias/categorias.module.js';
import { LibrosModule } from '../libros/libros.module.js';
import { PrestamosModule } from '../prestamos/prestamos.module.js';
import { PrismaModule } from '../prisma/prisma.module.js';

@Module({
  imports: [
    AuthModule,
    UsersModule,
    AlumnosModule,
    CategoriasModule,
    LibrosModule,
    PrestamosModule,
    PrismaModule,

  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}