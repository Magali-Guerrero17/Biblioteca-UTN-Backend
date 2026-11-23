import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './modules/app/app.module.js';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // Valida los datos que llegan con los DTO antes de ejecutar el controlador
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(process.env.PORT ?? 3000);
}
await bootstrap();