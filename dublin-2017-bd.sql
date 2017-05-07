BEGIN TRANSACTION;
CREATE TABLE "Ring" (
	"IdRing"	INTEGER PRIMARY KEY
);
CREATE TABLE "Pais" (
	"IdPais"	INTEGER PRIMARY KEY,
	"Nombre"	TEXT NOT NULL UNIQUE
);
CREATE TABLE "Competencia" (
	"IdCompetencia"	INTEGER PRIMARY KEY,
	"Sexo"	TEXT NOT NULL,
	"TipoCompetencia"	INTEGER NOT NULL
);
CREATE TABLE "Escuela" (
	"IdEscuela"	INTEGER PRIMARY KEY,
	"Nombre"	TEXT NOT NULL,
	"IdPais"	INTEGER,
	FOREIGN KEY("IdPais") REFERENCES "Pais"("IdPais")
);
CREATE TABLE "Arbitro" (
	"NroPlacaArbitro"	INTEGER PRIMARY KEY,
	"Nombre"	TEXT NOT NULL,
	"Apellido"	TEXT NOT NULL,
	"Graduacion"	INTEGER NOT NULL,
	"IdPais"	INTEGER,
	"Tipo"	TEXT NOT NULL,
	FOREIGN KEY("IdPais") REFERENCES "Pais"("IdPais")
);
CREATE TABLE "Alumno" (
	"DNI"	INTEGER PRIMARY KEY,
	"IdEscuela"	INTEGER NOT NULL,
	"Nombre"	TEXT NOT NULL,
	"Apellido"	TEXT NOT NULL,
	"Graduacion"	INTEGER NOT NULL,
	"NroCertificadoGraduacionITF"	INTEGER NOT NULL,
	"Foto"	TEXT NOT NULL,
	FOREIGN KEY("IdEscuela") REFERENCES "Escuela"("IdEscuela")
);
CREATE TABLE "Coach" (
	"DNI"	INTEGER,
	PRIMARY KEY("DNI"),
	FOREIGN KEY("DNI") REFERENCES "Alumno"("DNI")
);
CREATE TABLE "Equipo" (
	"IdEquipo"	INTEGER PRIMARY KEY,
	"NombreDeFantasia"	TEXT NOT NULL
);
CREATE TABLE "Maestro" (
	"NroDePlacaDeInstructor"	INTEGER PRIMARY KEY,
	"Nombre"	TEXT NOT NULL,
	"Apellido"	TEXT NOT NULL,
	"Graduacion"	INTEGER,
	"IdPais"	INTEGER,
	"IdEscuela"	INTEGER,
	FOREIGN KEY("IdPais") REFERENCES "Pais"("IdPais"),
	FOREIGN KEY("IdEscuela") REFERENCES "Escuela"("IdEscuela")
);
CREATE TABLE "PresidenteDeMesa" (
	"NroPlacaArbitro"	INTEGER,
	"IdRing"	INTEGER UNIQUE,
	PRIMARY KEY("NroPlacaArbitro"),
	FOREIGN KEY("NroPlacaArbitro") REFERENCES "Arbitro"("NroPlacaArbitro"),
	FOREIGN KEY("IdRing") REFERENCES "Ring"("IdRing")
);
CREATE TABLE "Juez" (
	"NroPlacaArbitro"	INTEGER,
	"IdRing"	INTEGER,
	PRIMARY KEY("NroPlacaArbitro","IdRing"),
	FOREIGN KEY("NroPlacaArbitro") REFERENCES "Arbitro"("NroPlacaArbitro"),
	FOREIGN KEY("IdRing") REFERENCES "Ring"("IdRing")
);
CREATE TABLE "InscriptoEn" (
	"DNIAlumno"	INTEGER NOT NULL,
	"DNICoach"	INTEGER,
	"IdCompetencia"	INTEGER NOT NULL,
	PRIMARY KEY("DNIAlumno","IdCompetencia"),
	FOREIGN KEY("DNIAlumno") REFERENCES "Alumno"("DNI"),
	FOREIGN KEY("DNICoach") REFERENCES "Alumno"("DNI"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia")
);
CREATE TABLE "EquipoInscriptoEn" (
	"IdEquipo"	INTEGER NOT NULL,
	"IdCompetencia"	INTEGER NOT NULL,
	"DNICoach"	INTEGER,
	PRIMARY KEY("IdEquipo","IdCompetencia"),
	FOREIGN KEY("IdEquipo") REFERENCES "Equipo"("IdEquipo"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia"),
	FOREIGN KEY("DNICoach") REFERENCES "Alumno"("DNI")
);
CREATE TABLE "Competidor" (
	"DNI"	INTEGER NOT NULL,
	"FechaDeNacimiento"	TEXT NOT NULL,
	"Sexo"	TEXT NOT NULL,
	"Edad"	INTEGER NOT NULL,
	"Titular"	INTEGER,
	"IdEquipo"	INTEGER,
	PRIMARY KEY("DNI"),
	FOREIGN KEY("DNI") REFERENCES "Alumno"("DNI"),
	FOREIGN KEY("IdEquipo") REFERENCES "Equipo"("IdEquipo")
);
CREATE TABLE "CompetenciaSalto" (
	"IdCompetencia"	INTEGER NOT NULL,
	"Edad"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia")
);
CREATE TABLE "CompetenciaRotura" (
	"IdCompetencia"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia")
);
CREATE TABLE "CompetenciaIndividual" (
	"IdCompetencia"	INTEGER NOT NULL,
	"PrimerLugar"	INTEGER,
	"SegundoLugar"	INTEGER,
	"TercerLugar"	INTEGER,
	"Graduacion"	INTEGER NOT NULL,
	"Modalidad"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia"),
	FOREIGN KEY("PrimerLugar") REFERENCES "Alumno"("DNI"),
	FOREIGN KEY("SegundoLugar") REFERENCES "Alumno"("DNI"),
	FOREIGN KEY("TercerLugar") REFERENCES "Alumno"("DNI")
);
CREATE TABLE "CompetenciaFormas" (
	"IdCompetencia"	INTEGER NOT NULL,
	"Edad"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia")
);
CREATE TABLE "CompetenciaCombateIndividual" (
	"IdCompetencia"	INTEGER NOT NULL,
	"Edad"	INTEGER NOT NULL,
	"Peso"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia")
);
CREATE TABLE "CompetenciaCombateEquipos" (
	"IdCompetencia"	INTEGER NOT NULL,
	"PrimerLugar"	INTEGER,
	"SegundoLugar"	INTEGER,
	"TercerLugar"	INTEGER,
	"Edad"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia"),
	FOREIGN KEY("PrimerLugar") REFERENCES "Equipo"("IdEquipo"),
	FOREIGN KEY("SegundoLugar") REFERENCES "Equipo"("IdEquipo"),
	FOREIGN KEY("TercerLugar") REFERENCES "Equipo"("IdEquipo")
);
CREATE TABLE "ArbitroDeRecambio" (
	"NroPlacaArbitro"	INTEGER,
	"IdRing"	INTEGER,
	PRIMARY KEY("NroPlacaArbitro","IdRing"),
	FOREIGN KEY("NroPlacaArbitro") REFERENCES "Arbitro"("NroPlacaArbitro"),
	FOREIGN KEY("IdRing") REFERENCES "Ring"("IdRing")
);
CREATE TABLE "ArbitroCentral" (
	"NroPlacaArbitro"	INTEGER,
	"IdRing"	INTEGER UNIQUE,
	PRIMARY KEY("NroPlacaArbitro"),
	FOREIGN KEY("NroPlacaArbitro") REFERENCES "Arbitro"("NroPlacaArbitro"),
	FOREIGN KEY("IdRing") REFERENCES "Ring"("IdRing")
);
CREATE TABLE "SeRealizaEn" (
	"IdCompetencia"	INTEGER NOT NULL,
	"IdRing"	INTEGER NOT NULL,
	PRIMARY KEY("IdCompetencia","IdRing"),
	FOREIGN KEY("IdCompetencia") REFERENCES "Competencia"("IdCompetencia"),
	FOREIGN KEY("IdRing") REFERENCES "Ring"("IdRing")
);


# TRIGGERS

CREATE FUNCTION checkCompetidoresEquipoMismaEscuela() RETURNS trigger AS $emp_stamp$
    BEGIN
        IF NEW.IdEquipo <> NULL THEN
		IF (SELECT COUNT(1) FROM "Competidor" c, Alumno a1, Alumno a2 WHERE NEW.IdEquipo = c.IdEquipo AND NEW.DNI = a1.DNI AND c.DNI = a2.DNI AND a1.IdEscuela <> a2.IdEscuela) > 0 THEN
			RAISE EXCEPTION 'Error: los competidores de un equipo deben pertenecer todos a la misma escuela.';
		ELSE
			RETURN NEW;
		END IF;
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CompetidoresEquipoMismaEscuela BEFORE INSERT OR UPDATE ON "Competidor" FOR EACH ROW EXECUTE PROCEDURE checkCompetidoresEquipoMismaEscuela();

###

CREATE FUNCTION checkEquipoInscriptoTiene5Titulares() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM "Competidor" c, Equipo e WHERE e.IdEquipo = NEW.IdEquipo AND c.IdEquipo = NEW.IdEquipo AND c.Titular = TRUE) <> 5 THEN
		RAISE EXCEPTION 'Error: todos los equipos inscriptos deben tener exactamente cinco titulares.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER EquipoInscriptoTiene5Titulares BEFORE INSERT ON "EquipoInscriptoEn" FOR EACH ROW EXECUTE PROCEDURE checkEquipoInscriptoTiene5Titulares();

###

CREATE FUNCTION checkEquipoInscriptoTiene3Suplentes() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM "Competidor" c, Equipo e WHERE e.IdEquipo = NEW.IdEquipo AND c.IdEquipo = NEW.IdEquipo AND c.Titular = FALSE) < 3 THEN
		RAISE EXCEPTION 'Error: todos los equipos inscriptos deben tener al menos 3 suplentes.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER EquipoInscriptoTiene3Suplentes BEFORE INSERT ON "EquipoInscriptoEn" FOR EACH ROW EXECUTE PROCEDURE checkEquipoInscriptoTiene3Suplentes();

###

COMMIT;
