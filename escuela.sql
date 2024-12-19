-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-12-2024 a las 00:55:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

DELIMITER $$
--
-- Procedimientos
--
CREATE  PROCEDURE `sp_get_alumno` (IN `p_buscar` INT)   BEGIN
	SELECT `nIdAlumno`, `nEstatus`,
    CASE
		WHEN nEstatus = 1 THEN "Activo"
		WHEN nEstatus = 2 THEN "Suspendido"
		WHEN nEstatus = 3 THEN "Eliminado"
	END AS sEstatus
    , `sIdAlumno`, `sNombre`, `sPaterno`, `sMaterno`, `dFecNacimiento`, `sGenero` 
	FROM `dat_alumno` 
    WHERE IF(p_buscar != '',
			sIdAlumno LIKE CONCAT('%', p_buscar, '%') OR
			sNombre LIKE CONCAT('%', p_buscar, '%') OR			
            sPaterno LIKE CONCAT('%', p_buscar, '%') OR
            sMaterno LIKE CONCAT('%', p_buscar, '%') 
			,1=1);
END$$

CREATE  PROCEDURE `sp_get_alumnos` ()   BEGIN

SELECT `nIdAlumno`, `nEstatus`,
 CASE
		WHEN nEstatus = 1 THEN "Activo"
		WHEN nEstatus = 2 THEN "Suspendido"
		WHEN nEstatus = 3 THEN "Eliminado"
	END AS sEstatus,
 `sIdAlumno`, `sNombre`, `sPaterno`, `sMaterno`, `dFecNacimiento`, `sGenero` 
FROM `dat_alumno`;

END$$

CREATE  PROCEDURE `sp_insert_alumno` (IN `p_sIdAlumno` VARCHAR(100), IN `p_sNombre` VARCHAR(150), IN `p_sPaterno` VARCHAR(100), IN `p_sMaterno` VARCHAR(100), IN `p_dFecNacimiento` DATE, IN `p_sGenero` CHAR(1))   BEGIN
	INSERT INTO dat_alumno(nIdAlumno, sIdAlumno, sNombre, sPaterno, sMaterno, dFecNacimiento, sGenero, dFecRegistro, dFecMovimiento) 
    VALUES (null,p_sIdAlumno,p_sNombre,p_sPaterno,p_sMaterno,p_dFecNacimiento,p_sGenero,now(),now());
    
	IF ROW_COUNT() > 0 THEN
		SET @codigo = 1;
		SET @msg = 'Registro Exitoso';
	ELSE 
		SET @codigo = 0;
		SET @msg = 'Operacion Fallida';    
	END IF;
    SELECT @codigo as `sCodigo`, @msg as `sMensaje`;

END$$

CREATE  PROCEDURE `sp_insert_calificacion` (IN `p_nIdAlumno` INT, IN `p_nIdMateria` INT, IN `p_nCalificacion` DECIMAL(3,1), IN `p_nGrado` INT, IN `p_nMes` INT, IN `p_nYear` INT)   BEGIN
	INSERT INTO dat_calificaciones(nIdCalificacion,nIdAlumno,nIdMateria,nCalificacion,nGrado,nMes,nYear,dFecRegistro,dFecMovimiento) 
    VALUES (null,p_nIdAlumno,p_nIdMateria,p_nCalificacion,p_nGrado,p_nMes,p_nYear,now(),now());
	
    IF ROW_COUNT() > 0 THEN
		SET @codigo = 1;
		SET @msg = 'Registro Exitoso';
	ELSE 
		SET @codigo = 0;
		SET @msg = 'Operacion Fallida';    
	END IF;
    SELECT @codigo as `sCodigo`, @msg as `sMensaje`;
    
END$$

CREATE  PROCEDURE `sp_search_alumno` (IN `p_buscar` VARCHAR(200))   BEGIN
	SELECT `nIdAlumno`, `nEstatus`, 
    CASE
		WHEN nEstatus = 1 THEN "Activo"
		WHEN nEstatus = 2 THEN "Suspendido"
		WHEN nEstatus = 3 THEN "Eliminado"
	END AS sEstatus,
    `sIdAlumno`, `sNombre`, `sPaterno`, `sMaterno`, `dFecNacimiento`, `sGenero`
	FROM `dat_alumno` 
    WHERE IF(p_buscar != '',
			sIdAlumno LIKE CONCAT('%', p_buscar, '%') OR
			sNombre LIKE CONCAT('%', p_buscar, '%') OR			
            sPaterno LIKE CONCAT('%', p_buscar, '%') OR
            sMaterno LIKE CONCAT('%', p_buscar, '%') or
            concat(sNombre,' ',sPaterno,' ',sMaterno) LIKE CONCAT('%', p_buscar, '%') 
			,1=1);
END$$

CREATE  PROCEDURE `sp_search_calificacion` (IN `p_sIdAlumno` VARCHAR(100), IN `p_nGrado` INT, IN `p_nMes` INT, IN `p_nYear` INT)   BEGIN
	SELECT nIdCalificacion, cal.nIdAlumno, concat(sNombre,' ',sPaterno,' ',IFNULL(sMaterno,'')) AS sAlumno, cal.nIdMateria, mat.sMateria,
    nCalificacion, cal.nGrado, gra.sGrado, nMes, nYear 
    FROM dat_calificaciones cal 
    INNER JOIN dat_alumno alu ON alu.nIdAlumno=cal.nIdAlumno 
    INNER JOIN cat_materia mat ON mat.nIdMateria=cal.nIdMateria
    INNER JOIN cat_grado gra ON gra.nIdGrado=cal.nGrado
    WHERE alu.sIdAlumno=p_sIdAlumno AND cal.nGrado=p_nGrado AND cal.nMes=p_nMes AND cal.nYear=p_nYear;
END$$

CREATE  PROCEDURE `sp_select_usuario` (IN `p_sUsuario` VARCHAR(100), IN `p_sPassword` INT)   BEGIN
	SELECT nId,sUsuario, sPassword FROM dat_user WHERE sUsuario=p_sUsuario AND sPassword=p_sPassword;
END$$

CREATE  PROCEDURE `sp_update_alumno` (IN `p_nIdAlumno` INT, IN `p_nEstatus` INT, IN `p_sIdAlumno` VARCHAR(100), IN `p_sNombre` VARCHAR(150), IN `p_sPaterno` VARCHAR(100), IN `p_sMaterno` VARCHAR(100), IN `p_dFecNacimiento` DATE, IN `p_sGenero` CHAR(1))   BEGIN
	UPDATE dat_alumno SET 
    nEstatus=p_nEstatus,
    sIdAlumno=p_sIdAlumno,
    sNombre=p_sNombre,
    sPaterno=p_sPaterno,
    sMaterno=p_sMaterno,
    dFecNacimiento=p_dFecNacimiento,
    sGenero=p_sGenero
    WHERE nIdAlumno=p_nIdAlumno;
    
    IF ROW_COUNT() > 0 THEN
		SET @codigo = 1;
		SET @msg = 'Actulizacion Exitosa';
	ELSE 
		SET @codigo = 0;
		SET @msg = 'Operacion Fallida';    
	END IF;
    SELECT @codigo as `sCodigo`, @msg as `sMensaje`;
    
END$$

CREATE  PROCEDURE `sp_update_estatus_alumno` (IN `p_nIdAlumno` INT, IN `p_nEstatus` INT)   BEGIN
	UPDATE dat_alumno SET 
    nEstatus=p_nEstatus
    WHERE nIdAlumno=p_nIdAlumno;
    
    IF ROW_COUNT() > 0 THEN
		SET @codigo = 1;
		SET @msg = 'Actulizacion Exitosa';
	ELSE 
		SET @codigo = 0;
		SET @msg = 'Operacion Fallida';    
	END IF;
    SELECT @codigo as `sCodigo`, @msg as `sMensaje`;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_grado`
--

CREATE TABLE `cat_grado` (
  `nIdGrado` int(11) NOT NULL,
  `sGrado` varchar(50) NOT NULL,
  `dFecRegistro` datetime NOT NULL,
  `dFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cat_grado`
--

INSERT INTO `cat_grado` (`nIdGrado`, `sGrado`, `dFecRegistro`, `dFecMovimiento`) VALUES
(1, 'PRIMERO', '2024-12-14 03:22:37', '2024-12-14 02:22:46'),
(2, 'SEGUNDO', '2024-12-14 03:58:48', '2024-12-14 02:59:02'),
(3, 'TERCERO', '2024-12-14 03:58:48', '2024-12-14 02:59:02'),
(4, 'CUARTO', '2024-12-14 03:59:13', '2024-12-14 02:59:18'),
(5, 'QUINTO', '2024-12-14 03:59:28', '2024-12-14 02:59:36'),
(6, 'SEXTO', '2024-12-14 03:59:28', '2024-12-14 02:59:36');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_materia`
--

CREATE TABLE `cat_materia` (
  `nIdMateria` int(11) NOT NULL,
  `sMateria` varchar(150) NOT NULL,
  `dFecRegistro` datetime NOT NULL,
  `dFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cat_materia`
--

INSERT INTO `cat_materia` (`nIdMateria`, `sMateria`, `dFecRegistro`, `dFecMovimiento`) VALUES
(1, 'ESPAÑOL', '2024-12-14 03:21:30', '2024-12-17 03:20:55'),
(2, 'MATEMATICAS', '2024-12-14 03:59:41', '2024-12-17 03:20:59'),
(3, 'FISICA', '2024-12-14 04:00:06', '2024-12-17 03:26:22'),
(4, 'CIENCIAS', '2024-12-16 22:57:36', '2024-12-17 03:21:03'),
(5, 'HISTORIA', '2024-12-16 22:58:19', '2024-12-17 03:21:05'),
(6, 'GEOGRAFIA', '2024-12-17 04:26:33', '2024-12-17 03:26:49'),
(7, 'BIOLOGIA', '2024-12-17 04:27:58', '2024-12-17 03:28:25'),
(9, 'QUIMICA', '2024-12-17 04:28:50', '2024-12-17 03:29:06'),
(10, 'DEPORTES', '2024-12-17 04:29:46', '2024-12-17 03:29:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dat_alumno`
--

CREATE TABLE `dat_alumno` (
  `nIdAlumno` int(11) NOT NULL,
  `nEstatus` int(1) NOT NULL DEFAULT 1 COMMENT '1= activo, 2=suspendido,\r\n3=eliminado/inactivo',
  `sIdAlumno` varchar(100) NOT NULL,
  `sNombre` varchar(150) NOT NULL,
  `sPaterno` varchar(100) NOT NULL,
  `sMaterno` varchar(100) DEFAULT NULL,
  `dFecNacimiento` date NOT NULL,
  `sGenero` char(1) DEFAULT NULL COMMENT 'M=masculino, F=femenino',
  `dFecRegistro` datetime NOT NULL,
  `dFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dat_alumno`
--

INSERT INTO `dat_alumno` (`nIdAlumno`, `nEstatus`, `sIdAlumno`, `sNombre`, `sPaterno`, `sMaterno`, `dFecNacimiento`, `sGenero`, `dFecRegistro`, `dFecMovimiento`) VALUES
(1, 3, 'HEOZ930625MOCRRR01', 'ZURISADDAI MERARI', 'HERNANDEZ', 'ORDAZ', '1993-06-25', 'F', '2024-12-14 03:19:50', '2024-12-17 05:47:02'),
(4, 1, 'N12188515', 'HUGO', 'HERNANDEZ', 'ORDAZ', '1996-08-04', 'M', '2024-12-16 16:20:22', '2024-12-17 01:12:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dat_calificaciones`
--

CREATE TABLE `dat_calificaciones` (
  `nIdCalificacion` int(11) NOT NULL,
  `nIdAlumno` int(11) NOT NULL,
  `nIdMateria` int(11) NOT NULL,
  `nCalificacion` decimal(3,1) NOT NULL,
  `nGrado` int(11) NOT NULL,
  `nMes` int(2) NOT NULL,
  `nYear` year(4) NOT NULL,
  `dFecRegistro` datetime NOT NULL,
  `dFecMovimiento` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dat_calificaciones`
--

INSERT INTO `dat_calificaciones` (`nIdCalificacion`, `nIdAlumno`, `nIdMateria`, `nCalificacion`, `nGrado`, `nMes`, `nYear`, `dFecRegistro`, `dFecMovimiento`) VALUES
(2, 1, 1, 9.3, 1, 12, '2024', '2024-12-16 22:28:59', '2024-12-17 04:28:59'),
(7, 4, 3, 8.5, 1, 11, '2024', '2024-12-16 22:50:05', '2024-12-17 04:50:05'),
(9, 1, 10, 8.0, 1, 12, '2024', '2024-12-17 06:42:10', '2024-12-17 05:42:31'),
(10, 1, 7, 7.0, 2, 12, '2024', '2024-12-17 06:42:49', '2024-12-17 05:43:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dat_user`
--

CREATE TABLE `dat_user` (
  `nId` int(11) NOT NULL,
  `sUsuario` varchar(50) NOT NULL,
  `sPassword` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dat_user`
--

INSERT INTO `dat_user` (`nId`, `sUsuario`, `sPassword`) VALUES
(1, 'admin', '12345');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cat_grado`
--
ALTER TABLE `cat_grado`
  ADD PRIMARY KEY (`nIdGrado`);

--
-- Indices de la tabla `cat_materia`
--
ALTER TABLE `cat_materia`
  ADD PRIMARY KEY (`nIdMateria`);

--
-- Indices de la tabla `dat_alumno`
--
ALTER TABLE `dat_alumno`
  ADD PRIMARY KEY (`nIdAlumno`),
  ADD UNIQUE KEY `sIdAlumno` (`sIdAlumno`);

--
-- Indices de la tabla `dat_calificaciones`
--
ALTER TABLE `dat_calificaciones`
  ADD PRIMARY KEY (`nIdCalificacion`),
  ADD UNIQUE KEY `nIdAlumno` (`nIdAlumno`,`nIdMateria`,`nMes`,`nYear`,`nGrado`) USING BTREE,
  ADD KEY `nIdMateria` (`nIdMateria`),
  ADD KEY `nGrado` (`nGrado`);

--
-- Indices de la tabla `dat_user`
--
ALTER TABLE `dat_user`
  ADD PRIMARY KEY (`nId`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cat_grado`
--
ALTER TABLE `cat_grado`
  MODIFY `nIdGrado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `cat_materia`
--
ALTER TABLE `cat_materia`
  MODIFY `nIdMateria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `dat_alumno`
--
ALTER TABLE `dat_alumno`
  MODIFY `nIdAlumno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `dat_calificaciones`
--
ALTER TABLE `dat_calificaciones`
  MODIFY `nIdCalificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `dat_user`
--
ALTER TABLE `dat_user`
  MODIFY `nId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `dat_calificaciones`
--
ALTER TABLE `dat_calificaciones`
  ADD CONSTRAINT `dat_calificaciones_ibfk_1` FOREIGN KEY (`nIdAlumno`) REFERENCES `dat_alumno` (`nIdAlumno`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dat_calificaciones_ibfk_3` FOREIGN KEY (`nIdMateria`) REFERENCES `cat_materia` (`nIdMateria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dat_calificaciones_ibfk_4` FOREIGN KEY (`nGrado`) REFERENCES `cat_grado` (`nIdGrado`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;