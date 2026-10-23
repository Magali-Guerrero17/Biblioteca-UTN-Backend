import { Module } from '@nestjs/common';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { LibrosModule } from './libros/libros.module.js';
import { AutoresModule } from './autores/autores.module.js';
import { UsuariosModule } from './usuarios/usuarios.module.js';
import { PrestamosModule } from './prestamos/prestamos.module.js';
import { CategoriasModule } from './categorias/categorias.module.js';
import { AuthModule } from './auth/auth.module.js';
import { ContactoModule } from './contacto/contacto.module.js';

@Module({
  imports: [LibrosModule, AutoresModule, UsuariosModule, PrestamosModule, CategoriasModule, AuthModule, ContactoModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
