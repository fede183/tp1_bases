BEGIN TRANSACTION;
CREATE TABLE "SeRealizaEn" (
	`IdCompetencia`	INTEGER NOT NULL,
	`IdRing`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`,`IdRing`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE `Ring` (
	`IdRing`	INTEGER NOT NULL,
	PRIMARY KEY(`IdRing`)
);
CREATE TABLE "PresidenteDeMesa" (
	`NroPlacaArbitro`	INTEGER,
	`IdRing`	INTEGER UNIQUE,
	PRIMARY KEY(`NroPlacaArbitro`),
	FOREIGN KEY(`NroPlacaArbitro`) REFERENCES `Arbitro`(`NroPlacaArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE "Pais" (
	`IdPais`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL UNIQUE,
	PRIMARY KEY(`IdPais`)
);
CREATE TABLE "Maestro" (
	`NroDePlacaDeInstructor`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	`Apellido`	TEXT NOT NULL,
	`Graduacion`	INTEGER,
	`IdPais`	INTEGER,
	`IdEscuela`	INTEGER,
	PRIMARY KEY(`NroDePlacaDeInstructor`),
	FOREIGN KEY(`IdPais`) REFERENCES `Pais`(`IdPais`),
	FOREIGN KEY(`IdEscuela`) REFERENCES `Escuela`(`IdEscuela`)
);
CREATE TABLE "Juez" (
	`NroPlacaArbitro`	INTEGER,
	`IdRing`	INTEGER,
	PRIMARY KEY(`NroPlacaArbitro`,`IdRing`),
	FOREIGN KEY(`NroPlacaArbitro`) REFERENCES `Arbitro`(`NroPlacaArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE "InscriptoEn" (
	`DNIAlumno`	INTEGER NOT NULL,
	`DNICoach`	INTEGER,
	`IdCompetencia`	INTEGER NOT NULL,
	PRIMARY KEY(`DNIAlumno`,`IdCompetencia`),
	FOREIGN KEY(`DNIAlumno`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`DNICoach`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE "Escuela" (
	`IdEscuela`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	`IdPais`	INTEGER,
	PRIMARY KEY(`IdEscuela`),
	FOREIGN KEY(`IdPais`) REFERENCES `Pais`(`IdPais`)
);
CREATE TABLE `EquipoInscriptoEn` (
	`IdEquipo`	INTEGER NOT NULL,
	`IdCompetencia`	INTEGER NOT NULL,
	`DNICoach`	INTEGER,
	PRIMARY KEY(`IdEquipo`,`IdCompetencia`),
	FOREIGN KEY(`IdEquipo`) REFERENCES `Equipo`(`IdEquipo`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`),
	FOREIGN KEY(`DNICoach`) REFERENCES `Alumno`(`DNI`)
);
CREATE TABLE "Equipo" (
	`IdEquipo`	INTEGER NOT NULL,
	`NombreDeFantasia`	TEXT NOT NULL,
	PRIMARY KEY(`IdEquipo`)
);
CREATE TABLE "Competidor" (
	`DNI`	INTEGER NOT NULL,
	`FechaDeNacimiento`	TEXT NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Edad`	INTEGER NOT NULL,
	`Titular`	INTEGER,
	`IdEquipo`	INTEGER,
	PRIMARY KEY(`DNI`),
	FOREIGN KEY(`DNI`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`IdEquipo`) REFERENCES `Equipo`(`IdEquipo`)
);
CREATE TABLE `CompetenciaSalto` (
	`IdCompetencia`	INTEGER NOT NULL,
	`Edad`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE "CompetenciaRotura" (
	`IdCompetencia`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE "CompetenciaIndividual" (
	`IdCompetencia`	INTEGER NOT NULL,
	`PrimerLugar`	INTEGER,
	`SegundoLugar`	INTEGER,
	`TercerLugar`	INTEGER,
	`Modalidad`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`),
	FOREIGN KEY(`PrimerLugar`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`SegundoLugar`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`TercerLugar`) REFERENCES `Alumno`(`DNI`)
);
CREATE TABLE `CompetenciaFormas` (
	`IdCompetencia`	INTEGER NOT NULL,
	`Edad`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE `CompetenciaCombateIndividual` (
	`IdCompetencia`	INTEGER NOT NULL,
	`Edad`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	`Peso`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE `CompetenciaCombateEquipos` (
	`IdCompetencia`	INTEGER NOT NULL,
	`PrimerLugar`	INTEGER,
	`SegundoLugar`	INTEGER,
	`TercerLugar`	INTEGER,
	`Edad`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`),
	FOREIGN KEY(`PrimerLugar`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`SegundoLugar`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`TercerLugar`) REFERENCES `Alumno`(`DNI`)
);
CREATE TABLE `Competencia` (
	`IdCompetencia`	INTEGER NOT NULL,
	`TipoCompetencia`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`)
);
CREATE TABLE "Coach" (
	`DNI`	INTEGER,
	PRIMARY KEY(`DNI`),
	FOREIGN KEY(`DNI`) REFERENCES `Alumno`(`DNI`)
);
CREATE TABLE "ArbitroDeRecambio" (
	`NroPlacaArbitro`	INTEGER,
	`IdRing`	INTEGER,
	PRIMARY KEY(`NroPlacaArbitro`,`IdRing`),
	FOREIGN KEY(`NroPlacaArbitro`) REFERENCES `Arbitro`(`NroPlacaArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE "ArbitroCentral" (
	`NroPlacaArbitro`	INTEGER,
	`IdRing`	INTEGER UNIQUE,
	PRIMARY KEY(`NroPlacaArbitro`),
	FOREIGN KEY(`NroPlacaArbitro`) REFERENCES `Arbitro`(`NroPlacaArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE "Arbitro" (
	`NroPlacaArbitro`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	`Apellido`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	`IdPais`	INTEGER,
	`Tipo`	TEXT NOT NULL,
	PRIMARY KEY(`NroPlacaArbitro`),
	FOREIGN KEY(`IdPais`) REFERENCES `Pais`(`IdPais`)
);
CREATE TABLE "Alumno" (
	`DNI`	INTEGER NOT NULL,
	`IdEscuela`	INTEGER NOT NULL,
	`Nombre`	INTEGER NOT NULL,
	`Apellido`	INTEGER NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	`NroCertificadoGraduacionITF`	INTEGER NOT NULL,
	`Foto`	BLOB NOT NULL,
	PRIMARY KEY(`DNI`),
	FOREIGN KEY(`IdEscuela`) REFERENCES `Escuela`(`IdEscuela`)
);
COMMIT;
