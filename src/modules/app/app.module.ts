import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { AuthModule } from '../auth/auth.module.js';
import { UsersModule } from '../users/users.module.js';
import { AlumnosModule } from '../alumnos/alumnos.module.js';
import { CategoriasModule } from '../categorias/categorias.module.js';
import { LibrosModule } from '../libros/libros.module.js';
import { PrestamosModule } from '../prestamos/prestamos.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    AuthModule,
    UsersModule,
    AlumnosModule,
    CategoriasModule,
    LibrosModule,
    PrestamosModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}