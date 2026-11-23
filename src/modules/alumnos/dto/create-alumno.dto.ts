import {
  IsEmail,
  IsNotEmpty,
  IsString,
  Matches,
  MaxLength,
} from 'class-validator';

export class CreateAlumnoDto {
  @IsString({ message: 'El nombre debe ser un texto.' })
  @IsNotEmpty({ message: 'El nombre es obligatorio.' })
  @MaxLength(60, { message: 'El nombre no puede superar los 60 caracteres.' })
  nombre: string;

  @IsString({ message: 'El apellido debe ser un texto.' })
  @IsNotEmpty({ message: 'El apellido es obligatorio.' })
  @MaxLength(60, { message: 'El apellido no puede superar los 60 caracteres.' })
  apellido: string;

  @IsString({ message: 'El legajo debe ser un texto.' })
  @IsNotEmpty({ message: 'El legajo es obligatorio.' })
  @MaxLength(15, { message: 'El legajo no puede superar los 15 caracteres.' })
  @Matches(/^[0-9]+$/, { message: 'El legajo solo puede contener números.' })
  legajo: string;

  @IsEmail({}, { message: 'El correo debe tener un formato válido.' })
  @MaxLength(120, { message: 'El correo no puede superar los 120 caracteres.' })
  correo: string;

  carreraId: number;
}
