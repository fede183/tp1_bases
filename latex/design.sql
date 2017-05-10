CREATE TABLE Ring (
	IdRing	INTEGER PRIMARY KEY
);
CREATE TABLE Pais (
	IdPais	INTEGER PRIMARY KEY,
	Nombre	TEXT NOT NULL UNIQUE
);
CREATE TABLE Competencia (
	IdCompetencia	INTEGER PRIMARY KEY,
	Sexo	TEXT NOT NULL,
	TipoCompetencia	INTEGER NOT NULL CHECK (TipoCompetencia = 0 OR TipoCompetencia = 1)
);
CREATE TABLE Escuela (
	IdEscuela	INTEGER PRIMARY KEY,
	Nombre	TEXT NOT NULL,
	IdPais	INTEGER,
	FOREIGN KEY(IdPais) REFERENCES Pais(IdPais)
);
CREATE TABLE Arbitro (
	NroPlacaArbitro	INTEGER PRIMARY KEY,
	Nombre	TEXT NOT NULL,
	Apellido	TEXT NOT NULL,
	Graduacion	INTEGER NOT NULL,
	IdPais	INTEGER,
	Tipo	TEXT NOT NULL,
	FOREIGN KEY(IdPais) REFERENCES Pais(IdPais)
);
CREATE TABLE Alumno (
	DNI	INTEGER PRIMARY KEY,
	IdEscuela	INTEGER NOT NULL,
	Nombre	TEXT NOT NULL,
	Apellido	TEXT NOT NULL,
	Graduacion	INTEGER NOT NULL,
	NroCertificadoGraduacionITF	INTEGER NOT NULL,
	Foto	TEXT NOT NULL,
	FOREIGN KEY(IdEscuela) REFERENCES Escuela(IdEscuela)
);
CREATE TABLE Coach (
	DNI	INTEGER,
	PRIMARY KEY(DNI),
	FOREIGN KEY(DNI) REFERENCES Alumno(DNI)
);
CREATE TABLE Equipo (
	IdEquipo	INTEGER PRIMARY KEY,
	NombreDeFantasia	TEXT NOT NULL
);
CREATE TABLE Maestro (
	NroDePlacaDeInstructor	INTEGER PRIMARY KEY,
	Nombre	TEXT NOT NULL,
	Apellido	TEXT NOT NULL,
	Graduacion	INTEGER,
	IdPais	INTEGER,
	IdEscuela	INTEGER,
	FOREIGN KEY(IdPais) REFERENCES Pais(IdPais),
	FOREIGN KEY(IdEscuela) REFERENCES Escuela(IdEscuela)
);
CREATE TABLE PresidenteDeMesa (
	NroPlacaArbitro	INTEGER,
	IdRing	INTEGER UNIQUE,
	PRIMARY KEY(NroPlacaArbitro),
	FOREIGN KEY(NroPlacaArbitro) REFERENCES Arbitro(NroPlacaArbitro),
	FOREIGN KEY(IdRing) REFERENCES Ring(IdRing)
);
CREATE TABLE Juez (
	NroPlacaArbitro	INTEGER,
	IdRing	INTEGER,
	PRIMARY KEY(NroPlacaArbitro,IdRing),
	FOREIGN KEY(NroPlacaArbitro) REFERENCES Arbitro(NroPlacaArbitro),
	FOREIGN KEY(IdRing) REFERENCES Ring(IdRing)
);
CREATE TABLE InscriptoEn (
	DNIAlumno	INTEGER NOT NULL,
	DNICoach	INTEGER,
	IdCompetencia	INTEGER NOT NULL,
	PRIMARY KEY(DNIAlumno,IdCompetencia),
	FOREIGN KEY(DNIAlumno) REFERENCES Alumno(DNI),
	FOREIGN KEY(DNICoach) REFERENCES Alumno(DNI),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE EquipoInscriptoEn (
	IdEquipo	INTEGER NOT NULL,
	IdCompetencia	INTEGER NOT NULL,
	DNICoach	INTEGER,
	PRIMARY KEY(IdEquipo,IdCompetencia),
	FOREIGN KEY(IdEquipo) REFERENCES Equipo(IdEquipo),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia),
	FOREIGN KEY(DNICoach) REFERENCES Alumno(DNI)
);
CREATE TABLE Competidor (
	DNI	INTEGER NOT NULL,
	FechaDeNacimiento	DATE NOT NULL,
	Sexo	TEXT NOT NULL,
	Peso	INTEGER NOT NULL,
	Titular	INTEGER,
	IdEquipo	INTEGER,
	PRIMARY KEY(DNI),
	FOREIGN KEY(DNI) REFERENCES Alumno(DNI),
	FOREIGN KEY(IdEquipo) REFERENCES Equipo(IdEquipo)
);
CREATE TABLE CompetenciaSalto (
	IdCompetencia	INTEGER NOT NULL,
	Edad	INTEGER NOT NULL,
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE CompetenciaRotura (
	IdCompetencia	INTEGER NOT NULL,
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE CompetenciaIndividual (
	IdCompetencia	INTEGER NOT NULL,
	PrimerLugar	INTEGER,
	SegundoLugar	INTEGER,
	TercerLugar	INTEGER,
	Graduacion	INTEGER NOT NULL,
	Modalidad	INTEGER NOT NULL CHECK (Modalidad >= 0 AND Modalidad <= 3),
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia),
	FOREIGN KEY(PrimerLugar) REFERENCES Alumno(DNI),
	FOREIGN KEY(SegundoLugar) REFERENCES Alumno(DNI),
	FOREIGN KEY(TercerLugar) REFERENCES Alumno(DNI)
);
CREATE TABLE CompetenciaFormas (
	IdCompetencia	INTEGER NOT NULL,
	Edad	INTEGER NOT NULL,
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE CompetenciaCombateIndividual (
	IdCompetencia	INTEGER NOT NULL,
	Edad	INTEGER NOT NULL,
	Peso	INTEGER NOT NULL,
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE CompetenciaCombateEquipos (
	IdCompetencia	INTEGER NOT NULL,
	PrimerLugar	INTEGER,
	SegundoLugar	INTEGER,
	TercerLugar	INTEGER,
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia),
	FOREIGN KEY(PrimerLugar) REFERENCES Equipo(IdEquipo),
	FOREIGN KEY(SegundoLugar) REFERENCES Equipo(IdEquipo),
	FOREIGN KEY(TercerLugar) REFERENCES Equipo(IdEquipo)
);
CREATE TABLE ArbitroDeRecambio (
	NroPlacaArbitro	INTEGER,
	IdRing	INTEGER,
	PRIMARY KEY(NroPlacaArbitro,IdRing),
	FOREIGN KEY(NroPlacaArbitro) REFERENCES Arbitro(NroPlacaArbitro),
	FOREIGN KEY(IdRing) REFERENCES Ring(IdRing)
);
CREATE TABLE ArbitroCentral (
	NroPlacaArbitro	INTEGER,
	IdRing	INTEGER UNIQUE,
	PRIMARY KEY(NroPlacaArbitro),
	FOREIGN KEY(NroPlacaArbitro) REFERENCES Arbitro(NroPlacaArbitro),
	FOREIGN KEY(IdRing) REFERENCES Ring(IdRing)
);
CREATE TABLE SeRealizaEn (
	IdCompetencia	INTEGER NOT NULL,
	IdRing	INTEGER NOT NULL,
	PRIMARY KEY(IdCompetencia,IdRing),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia),
	FOREIGN KEY(IdRing) REFERENCES Ring(IdRing)
);