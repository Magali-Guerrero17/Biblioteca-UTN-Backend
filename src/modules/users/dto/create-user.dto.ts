import { IsNotEmpty, IsString, MaxLength, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsString({ message: 'El usuario debe ser un texto.' })
  @IsNotEmpty({ message: 'El usuario es obligatorio.' })
  @MaxLength(30, { message: 'El usuario no puede superar los 30 caracteres.' })
  usuario: string;

  @IsString({ message: 'La contraseña debe ser un texto.' })
  @IsNotEmpty({ message: 'La contraseña es obligatoria.' })
  @MinLength(4, { message: 'La contraseña debe tener al menos 4 caracteres.' })
  @MaxLength(72, { message: 'La contraseña no puede superar los 72 caracteres.' })
  password: string;

  rolId: number;
  alumnoId?: number;
}