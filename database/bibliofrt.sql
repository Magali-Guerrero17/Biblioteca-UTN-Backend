-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         8.4.3 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.16.0.7229
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para bibliofrt
CREATE DATABASE IF NOT EXISTS `bibliofrt` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bibliofrt`;

-- Volcando estructura para tabla bibliofrt.alumnos
CREATE TABLE IF NOT EXISTS `alumnos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `legajo` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrera_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `legajo` (`legajo`),
  UNIQUE KEY `correo` (`correo`),
  KEY `carrera_id` (`carrera_id`),
  CONSTRAINT `alumnos_ibfk_1` FOREIGN KEY (`carrera_id`) REFERENCES `carreras` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.alumnos: ~6 rows (aproximadamente)
INSERT INTO `alumnos` (`id`, `nombre`, `apellido`, `legajo`, `correo`, `carrera_id`) VALUES
	(1, 'Lucía', 'Gómez', '45012', 'lucia.gomez@ejemplo.com', 1),
	(2, 'Martín', 'Rojas', '45230', 'martin.rojas@ejemplo.com', 2),
	(3, 'Sofía', 'Paz', '44871', 'sofia.paz@ejemplo.com', 3),
	(4, 'Tomás', 'Ledesma', '45544', 'tomas.ledesma@ejemplo.com', 4),
	(5, 'Valentina', 'Cruz', '45109', 'valentina.cruz@ejemplo.com', 5),
	(6, 'Joaquín', 'Herrera', '44990', 'joaquin.herrera@ejemplo.com', 1);

-- Volcando estructura para tabla bibliofrt.autores
CREATE TABLE IF NOT EXISTS `autores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.autores: ~6 rows (aproximadamente)
INSERT INTO `autores` (`id`, `nombre`) VALUES
	(1, 'Robert C. Martin'),
	(2, 'Ian Sommerville'),
	(3, 'James Stewart'),
	(4, 'Abraham Silberschatz'),
	(5, 'Andrew Tanenbaum'),
	(6, 'Sears y Zemansky');

-- Volcando estructura para tabla bibliofrt.carreras
CREATE TABLE IF NOT EXISTS `carreras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.carreras: ~5 rows (aproximadamente)
INSERT INTO `carreras` (`id`, `nombre`) VALUES
	(1, 'Ing. en Sistemas'),
	(2, 'Ing. Civil'),
	(3, 'Ing. Eléctrica'),
	(4, 'Ing. Mecánica'),
	(5, 'Ing. Química');

-- Volcando estructura para tabla bibliofrt.categorias
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.categorias: ~6 rows (aproximadamente)
INSERT INTO `categorias` (`id`, `nombre`) VALUES
	(1, 'Programación'),
	(2, 'Ingeniería'),
	(3, 'Matemática'),
	(4, 'Bases de datos'),
	(5, 'Sistemas'),
	(6, 'Física');

-- Volcando estructura para tabla bibliofrt.libros
CREATE TABLE IF NOT EXISTS `libros` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isbn` varchar(13) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disponibles` int NOT NULL,
  `total` int NOT NULL,
  `autor_id` int NOT NULL,
  `categoria_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `isbn` (`isbn`),
  KEY `autor_id` (`autor_id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `libros_ibfk_1` FOREIGN KEY (`autor_id`) REFERENCES `autores` (`id`),
  CONSTRAINT `libros_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  CONSTRAINT `libros_chk_1` CHECK ((`disponibles` <= `total`))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.libros: ~6 rows (aproximadamente)
INSERT INTO `libros` (`id`, `titulo`, `isbn`, `disponibles`, `total`, `autor_id`, `categoria_id`) VALUES
	(1, 'Clean Code', '9780132350884', 2, 3, 1, 1),
	(2, 'Ingeniería de Software', '9786073206036', 0, 2, 2, 2),
	(3, 'Cálculo de una variable', '9786075226392', 4, 5, 3, 3),
	(4, 'Fundamentos de Bases de Datos', '9788448190330', 1, 2, 4, 4),
	(5, 'Sistemas Operativos Modernos', '9786073222471', 3, 4, 5, 5),
	(6, 'Física Universitaria', '9786073221245', 0, 3, 6, 6);

-- Volcando estructura para tabla bibliofrt.prestamos
CREATE TABLE IF NOT EXISTS `prestamos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `libro_id` int NOT NULL,
  `fecha_prestamo` date NOT NULL,
  `fecha_devolucion` date NOT NULL,
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `alumno_id` (`alumno_id`),
  KEY `libro_id` (`libro_id`),
  CONSTRAINT `prestamos_ibfk_1` FOREIGN KEY (`alumno_id`) REFERENCES `alumnos` (`id`),
  CONSTRAINT `prestamos_ibfk_2` FOREIGN KEY (`libro_id`) REFERENCES `libros` (`id`),
  CONSTRAINT `prestamos_chk_1` CHECK ((`fecha_devolucion` >= `fecha_prestamo`))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.prestamos: ~6 rows (aproximadamente)
INSERT INTO `prestamos` (`id`, `alumno_id`, `libro_id`, `fecha_prestamo`, `fecha_devolucion`, `estado`) VALUES
	(1, 1, 1, '2026-09-28', '2026-10-12', 'Activo'),
	(2, 3, 3, '2026-09-10', '2026-09-24', 'Vencido'),
	(3, 2, 2, '2026-09-01', '2026-09-15', 'Devuelto'),
	(4, 3, 4, '2026-10-01', '2026-10-15', 'Activo'),
	(5, 5, 5, '2026-09-25', '2026-10-09', 'Activo'),
	(6, 1, 6, '2026-08-20', '2026-09-03', 'Devuelto');

-- Volcando estructura para tabla bibliofrt.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.roles: ~0 rows (aproximadamente)
INSERT INTO `roles` (`id`, `nombre`, `descripcion`) VALUES
	(1, 'alumno', 'Alumno de la facultad'),
	(2, 'bibliotecario', 'Gestiona libros y prestamos'),
	(3, 'docente', 'Docente de la facultad'),
	(4, 'administrador', 'Administra el sistema'),
	(5, 'invitado', 'Solo consulta el catalogo');

-- Volcando estructura para tabla bibliofrt.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol_id` int NOT NULL,
  `alumno_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario` (`usuario`),
  KEY `rol_id` (`rol_id`),
  KEY `alumno_id` (`alumno_id`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`alumno_id`) REFERENCES `alumnos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla bibliofrt.usuarios: ~7 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `usuario`, `password`, `rol_id`, `alumno_id`) VALUES
	(1, 'bibliotecario', '1234', 2, NULL),
	(2, '45012', '1234', 1, 1),
	(3, '45230', '1234', 1, 2),
	(4, '44871', '1234', 1, 3),
	(5, '45544', '1234', 1, 4),
	(6, '45109', '1234', 1, 5),
	(7, '44990', '1234', 1, 6);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
