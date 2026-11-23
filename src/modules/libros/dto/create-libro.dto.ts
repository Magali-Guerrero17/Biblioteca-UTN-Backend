import {
  IsInt,
  IsNotEmpty,
  IsString,
  MaxLength,
  MinLength,
  Min,
  Matches,
} from 'class-validator';

export class CreateLibroDto {
  @IsString({ message: 'El título debe ser un texto.' })
  @IsNotEmpty({ message: 'El título es obligatorio.' })
  @MaxLength(200, { message: 'El título no puede superar los 200 caracteres.' })
  @MinLength(1, { message: 'El título no puede estar vacío.' })
  titulo: string;

  @IsString({ message: 'El ISBN debe ser un texto.' })
  @IsNotEmpty({ message: 'El ISBN es obligatorio.' })
  @Matches(/^([0-9]{10}|[0-9]{13})$/, {
    message: 'El ISBN debe tener 10 o 13 dígitos, sin guiones.',
  })
  isbn: string;

  @IsInt({ message: 'El total debe ser un número entero.' })
  @Min(1, { message: 'El total debe ser como mínimo 1.' })
  total: number;

  autorId: number;

  categoriaId: number;
}