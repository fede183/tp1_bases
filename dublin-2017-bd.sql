BEGIN TRANSACTION;
CREATE TABLE `Ring` (
	`IdRing`	INTEGER NOT NULL,
	PRIMARY KEY(`IdRing`)
);
CREATE TABLE "PresidenteDeMesa" (
	`IdArbitro`	INTEGER,
	`IdRing`	INTEGER UNIQUE,
	PRIMARY KEY(`IdArbitro`),
	FOREIGN KEY(`IdArbitro`) REFERENCES `Arbitro`(`IdArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE `Pais` (
	`IdPais`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Nombre`	TEXT NOT NULL UNIQUE
);
CREATE TABLE "Maestro" (
	`NroPlacaInstructor`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	`Apellido`	TEXT NOT NULL,
	`Graduacion`	INTEGER,
	`IdPais`	INTEGER,
	`IdEscuela`	INTEGER,
	PRIMARY KEY(`NroPlacaInstructor`),
	FOREIGN KEY(`IdPais`) REFERENCES `Pais`(`IdPais`),
	FOREIGN KEY(`IdEscuela`) REFERENCES `Escuela`(`IdEscuela`)
);
CREATE TABLE "Juez" (
	`IdArbitro`	INTEGER,
	`IdRing`	INTEGER,
	PRIMARY KEY(`IdArbitro`,`IdRing`),
	FOREIGN KEY(`IdArbitro`) REFERENCES `Arbitro`(`IdArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE `Inscripcion` (
	`DNIAlumno`	INTEGER NOT NULL,
	`DNICoach`	INTEGER,
	`IdCompetencia`	INTEGER NOT NULL,
	PRIMARY KEY(`DNIAlumno`,`IdCompetencia`),
	FOREIGN KEY(`DNIAlumno`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE "Escuela" (
	`IdEscuela`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	`IdPais`	INTEGER,
	PRIMARY KEY(`IdEscuela`),
	FOREIGN KEY(`IdPais`) REFERENCES `Pais`(`IdPais`)
);
CREATE TABLE `Equipo` (
	`IdEquipo`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	PRIMARY KEY(`IdEquipo`)
);
CREATE TABLE `CompetenciaSalto` (
	`IdCompetencia`	INTEGER NOT NULL,
	`Edad`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE `CompetenciaRotura` (
	`Field1`	INTEGER NOT NULL,
	`Sexo`	TEXT NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	PRIMARY KEY(`Field1`),
	FOREIGN KEY(`Field1`) REFERENCES `Competencia`(`IdCompetencia`)
);
CREATE TABLE `CompetenciaRing` (
	`IdCompetencia`	INTEGER NOT NULL,
	`IdRing`	INTEGER NOT NULL,
	PRIMARY KEY(`IdCompetencia`,`IdRing`),
	FOREIGN KEY(`IdCompetencia`) REFERENCES `Competencia`(`IdCompetencia`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE `CompetenciaIndividual` (
	`IdCompetencia`	INTEGER NOT NULL,
	`PrimerLugar`	INTEGER,
	`SegundoLugar`	INTEGER,
	`TercerLugar`	INTEGER,
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
	`IdEscuela`	INTEGER,
	PRIMARY KEY(`DNI`),
	FOREIGN KEY(`DNI`) REFERENCES `Alumno`(`DNI`),
	FOREIGN KEY(`IdEscuela`) REFERENCES `Escuela`(`IdEscuela`)
);
CREATE TABLE "ArbitroDeRecambio" (
	`IdArbitro`	INTEGER,
	`IdRing`	INTEGER,
	PRIMARY KEY(`IdArbitro`,`IdRing`),
	FOREIGN KEY(`IdArbitro`) REFERENCES `Arbitro`(`IdArbitro`),
	FOREIGN KEY(`IdRing`) REFERENCES `Ring`(`IdRing`)
);
CREATE TABLE "ArbitroCentral" (
	`IdArbitro`	INTEGER,
	`IdRing`	INTEGER UNIQUE,
	PRIMARY KEY(`IdArbitro`),
	FOREIGN KEY(`IdArbitro`) REFERENCES `Arbitro`(`IdArbitro`),
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
	`Peso`	INTEGER NOT NULL,
	`Edad`	INTEGER NOT NULL,
	`IdEscuela`	INTEGER NOT NULL,
	`IdEquipo`	INTEGER,
	`FechaNacimiento`	INTEGER NOT NULL,
	`Nombre`	TEXT NOT NULL,
	`Apellido`	INTEGER NOT NULL,
	`Graduacion`	INTEGER NOT NULL,
	`NumeroCertificadoGraduacionITF`	INTEGER NOT NULL,
	`Foto`	BLOB NOT NULL,
	PRIMARY KEY(`DNI`),
	FOREIGN KEY(`IdEscuela`) REFERENCES `Escuela`(`IdEscuela`),
	FOREIGN KEY(`IdEquipo`) REFERENCES `Equipo`(`IdEquipo`)
);
COMMIT;
