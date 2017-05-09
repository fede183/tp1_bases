BEGIN TRANSACTION;
CREATE TABLE Ring (
	IdRing	INTEGER PRIMARY KEY
);
CREATE TABLE Pais (
	IdPais	INTEGER PRIMARY KEY,
	Nombre	TEXT NOT NULL UNIQUE
);
CREATE TABLE Competencia (
	IdCompetencia	INTEGER PRIMARY KEY,
	Sexo	TEXT NOT NULL CHECK (Sexo = 'M' OR Sexo = 'F'),
	TipoCompetencia	INTEGER NOT NULL
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
	Graduacion	INTEGER NOT NULL CHECK (Graduacion >= 1 AND Graduacion <= 6),
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
	Graduacion	INTEGER NOT NULL CHECK (Graduacion >= 1 AND Graduacion <= 6),
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
	Sexo	TEXT NOT NULL CHECK (Sexo = 'M' OR Sexo = 'F'),
	Peso	INTEGER NOT NULL CHECK (Peso >= 1 AND Peso <= 300),
	Edad	INTEGER NOT NULL CHECK (Edad >= 1 AND Edad <= 150),
	Titular	INTEGER CHECK (Titular = 0 OR Titular = 1),
	IdEquipo	INTEGER,
	PRIMARY KEY(DNI),
	FOREIGN KEY(DNI) REFERENCES Alumno(DNI),
	FOREIGN KEY(IdEquipo) REFERENCES Equipo(IdEquipo)
);
CREATE TABLE CompetenciaSalto (
	IdCompetencia	INTEGER NOT NULL,
	Edad	INTEGER NOT NULL CHECK (Edad >= 1 AND Edad <= 150),
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
	Graduacion	INTEGER NOT NULL CHECK (Graduacion >= 1 AND Graduacion <= 6),
	Modalidad	INTEGER NOT NULL,
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia),
	FOREIGN KEY(PrimerLugar) REFERENCES Alumno(DNI),
	FOREIGN KEY(SegundoLugar) REFERENCES Alumno(DNI),
	FOREIGN KEY(TercerLugar) REFERENCES Alumno(DNI)
);
CREATE TABLE CompetenciaFormas (
	IdCompetencia	INTEGER NOT NULL,
	Edad	INTEGER NOT NULL CHECK (Edad >= 1 AND Edad <= 150),
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE CompetenciaCombateIndividual (
	IdCompetencia	INTEGER NOT NULL,
	Edad	INTEGER NOT NULL CHECK (Edad >= 1 AND Edad <= 150),
	Peso	INTEGER NOT NULL CHECK (Peso >= 1 AND Peso <= 300),
	PRIMARY KEY(IdCompetencia),
	FOREIGN KEY(IdCompetencia) REFERENCES Competencia(IdCompetencia)
);
CREATE TABLE CompetenciaCombateEquipos (
	IdCompetencia	INTEGER NOT NULL,
	PrimerLugar	INTEGER,
	SegundoLugar	INTEGER,
	TercerLugar	INTEGER,
	Edad	INTEGER NOT NULL CHECK (Edad >= 1 AND Edad <= 150),
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

-- Restricción 1: Toda escuela envia un coach por cada cinco competidores inscriptos.

CREATE FUNCTION checkCoachMaximo5Competidores() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM InscriptoEn ie WHERE NEW.DNIAlumno <> ie.DNIAlumno AND NEW.DNICoach = ie.DNICoach) > 5 THEN
		RAISE EXCEPTION 'Error: coach acompania a mas de 5 alumnos.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CoachMaximo5Competidores BEFORE INSERT ON InscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkCoachMaximo5Competidores();

-- Restricción 2: Todos los competidores que pertenecen a un mismo equipo son inscriptos por la misma escuela.

CREATE FUNCTION checkCompetidoresEquipoMismaEscuela() RETURNS trigger AS $emp_stamp$
    BEGIN
        IF NEW.IdEquipo <> NULL THEN
		IF (SELECT COUNT(1) FROM Competidor c, Alumno a1, Alumno a2 WHERE NEW.IdEquipo = c.IdEquipo AND NEW.DNI = a1.DNI AND c.DNI = a2.DNI AND a1.IdEscuela <> a2.IdEscuela) > 0 THEN
			RAISE EXCEPTION 'Error: los competidores de un equipo deben pertenecer todos a la misma escuela.';
		ELSE
			RETURN NEW;
		END IF;
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CompetidoresEquipoMismaEscuela BEFORE INSERT OR UPDATE ON Competidor FOR EACH ROW EXECUTE PROCEDURE checkCompetidoresEquipoMismaEscuela();

-- Restricción 3: Todo equipo está formado por cinco competidores con el atributo “Titular” en true que pertenecen al equipo.

CREATE FUNCTION checkEquipoInscriptoTiene5Titulares() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Competidor c, Equipo e WHERE e.IdEquipo = NEW.IdEquipo AND c.IdEquipo = NEW.IdEquipo AND c.Titular = 1) <> 5 THEN
		RAISE EXCEPTION 'Error: todos los equipos inscriptos deben tener exactamente cinco titulares.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER EquipoInscriptoTiene5Titulares BEFORE INSERT ON EquipoInscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkEquipoInscriptoTiene5Titulares();

-- Restricción 4: Todo equipo esta formado por al menos tres competidores con el atributo “Titular” en false que pertenecen al equipo.

CREATE FUNCTION checkEquipoInscriptoTiene3Suplentes() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Competidor c, Equipo e WHERE e.IdEquipo = NEW.IdEquipo AND c.IdEquipo = NEW.IdEquipo AND c.Titular = 0) < 3 THEN
		RAISE EXCEPTION 'Error: todos los equipos inscriptos deben tener al menos 3 suplentes.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER EquipoInscriptoTiene3Suplentes BEFORE INSERT ON EquipoInscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkEquipoInscriptoTiene3Suplentes();

-- Restricción 5: Todo competidor pertenece a un equipo si y solo si el atributo “Titular” es distinto de NULL.

CREATE FUNCTION checkCompetidorSinEquipoNoEsTitularNiSup() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (NEW.IdEquipo = NULL AND NEW.Titular <> NULL) OR (NEW.IdEquipo <> NULL AND NEW.Titular = NULL) THEN
		RAISE EXCEPTION 'Error: competidor pertenece a un equipo si y solo si el atributo Titular es distinto de NULL';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CompetidorSinEquipoNoEsTitularNiSup BEFORE INSERT OR UPDATE ON Competidor FOR EACH ROW EXECUTE PROCEDURE checkCompetidorSinEquipoNoEsTitularNiSup();

-- Restricción 6: Todo competidor inscripto en una competencia es acompañado por un coach enviado por la misma escuela que lo inscribió.

CREATE FUNCTION checkCompetidorMismaEscuelaCoach() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Alumno a1, Alumno a2 WHERE NEW.DNIAlumno = a1.DNI AND NEW.DNICoach = a2.DNI AND a1.IdEscuela <> a2.IdEscuela) > 0 THEN
		RAISE EXCEPTION 'Error: competidor y coach deben ser de la misma escuela.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CompetidorMismaEscuelaCoach BEFORE INSERT OR UPDATE ON InscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkCompetidorMismaEscuelaCoach();

-- Restricción 7: Todo equipo inscripto en una competencia es acompañado por un coach enviado por la misma escuela que inscribió a los competidores del equipo.

CREATE FUNCTION checkEquipoMismaEscuelaCoach() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Equipo e, Competidor c, Alumno a1, Alumno a2 WHERE NEW.IdEquipo = e.IdEquipo AND c.IdEquipo = e.IdEquipo AND c.DNI = a1.DNI AND NEW.DNICoach = a2.DNI AND a1.IdEscuela <> a2.IdEscuela) > 0 THEN
		RAISE EXCEPTION 'Error: miembros del equipo y coach deben ser de la misma escuela.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER EquipoMismaEscuelaCoach BEFORE INSERT OR UPDATE ON EquipoInscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkEquipoMismaEscuelaCoach();

-- Restricción 8: Ningún competidor puede ser acompañado en una competencia por un coach que tenga el mismo “DNI”.

CREATE FUNCTION checkCompetidorDistintoCoach() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF NEW.DNIAlumno = NEW.DNICoach THEN
		RAISE EXCEPTION 'Error: competidor y coach deben ser distintos.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CompetidorDistintoCoach BEFORE INSERT OR UPDATE ON InscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkCompetidorDistintoCoach();

-- Restricción 9: Ningún equipo puede ser acompañado en una competencia por un coach que tenga el mismo “DNI” que alguno de sus integrantes.

CREATE FUNCTION checkEquipoDistintoCoach() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Competidor c WHERE NEW.IdEquipo = c.IdEquipo AND c.DNI = NEW.DNICoach) > 0 THEN
		RAISE EXCEPTION 'Error: coach no pueden acompanar a un equipo en el cual es miembro.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER EquipoDistintoCoach BEFORE INSERT OR UPDATE ON EquipoInscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkEquipoDistintoCoach();

-- Restricción 10: Todas las competencias que tengan atributo “Graduación” deben ser realizadas en rings donde el juez de mesa sea un árbitro con graduación mayor a la de la competencia.
-- Restricción 11: Todas las competencias que tengan atributo “Graduación” deben ser realizadas en rings donde todos los jueces sean árbitros con graduación mayor a la de la competencia.
-- Restricción 12: Todas las competencias que tengan atributo “Graduación” deben ser realizadas en rings donde el árbitro central sea un árbitro con graduación mayor a la de la competencia.
-- Restricción 13: Todas las competencias que tengan atributo “Graduación” deben ser realizadas en rings donde todos los árbitros de recambio sean árbitros con graduación mayor a la de la competencia.

CREATE FUNCTION checkGraduacionArbitroYCompetencia() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Arbitro a, Ring r, SeRealizaEn s, Competencia c, CompetenciaIndividual ci WHERE NEW.IdRing = r.IdRing AND r.IdRing = s.IdRing AND s.IdCompetencia = c.IdCompetencia AND c.IdCompetencia = ci.IdCompetencia AND NEW.NroPlacaArbitro = a.NroPlacaArbitro AND ci.Graduacion >= a.Graduacion) > 0 THEN
		RAISE EXCEPTION 'Error: graduacion arbitro menor al de la competencia.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER GraduacionPresidenteDeMesaYCompetencia BEFORE INSERT OR UPDATE ON PresidenteDeMesa FOR EACH ROW EXECUTE PROCEDURE checkGraduacionArbitroYCompetencia();
CREATE TRIGGER GraduacionJuezYCompetencia BEFORE INSERT OR UPDATE ON Juez FOR EACH ROW EXECUTE PROCEDURE checkGraduacionArbitroYCompetencia();
CREATE TRIGGER GraduacionArbitroCentralYCompetencia BEFORE INSERT OR UPDATE ON ArbitroCentral FOR EACH ROW EXECUTE PROCEDURE checkGraduacionArbitroYCompetencia();
CREATE TRIGGER GraduacionArbitroRecambioYCompetencia BEFORE INSERT OR UPDATE ON ArbitroDeRecambio FOR EACH ROW EXECUTE PROCEDURE checkGraduacionArbitroYCompetencia();

-- Restricción 14: Todo ring tiene al menos tres arbitros de recambio.

CREATE FUNCTION checkRingTieneAlMenos3ArbitrosRecambio() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM ArbitroDeRecambio ar WHERE NEW.IdRing = ar.IdRing) < 3 THEN
		RAISE EXCEPTION 'Error: todos los rings donde se realizan competencias deben tener al menos 3 arbitros de recambio.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER RingTieneAlMenos3ArbitrosRecambio BEFORE INSERT ON SeRealizaEn FOR EACH ROW EXECUTE PROCEDURE checkRingTieneAlMenos3ArbitrosRecambio();

-- Restricción 15: Ningún competidor puede estar en más de una de las siguientes relaciones: “Primer lugar en”, “Segundo lugar en”, “Tercer lugar en” en una misma competencia.

CREATE FUNCTION checkDistintosCompetidoresPrimerSegunTercerPuesto() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Competidor c WHERE (NEW.PrimerLugar = c.DNI AND NEW.SegundoLugar = c.DNI) OR (NEW.PrimerLugar = c.DNI AND NEW.TercerLugar = c.DNI) OR (NEW.SegundoLugar = c.DNI AND NEW.TercerLugar = c.DNI)) > 0 THEN
		RAISE EXCEPTION 'Error: mismo competidor no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER DistintosCompetidoresPrimerSegunTercerPuesto BEFORE INSERT ON CompetenciaIndividual FOR EACH ROW EXECUTE PROCEDURE checkDistintosCompetidoresPrimerSegunTercerPuesto();

-- Restricción 16: Ningún equipo puede estar en más de una de las siguientes relaciones: “Primer lugar en”, “Segundo lugar en”, “Tercer lugar en” en una misma competencia.

CREATE FUNCTION checkDistintosEquiposPrimerSegunTercerPuesto() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Equipo e WHERE (NEW.PrimerLugar = e.IdEquipo AND NEW.SegundoLugar = e.IdEquipo) OR (NEW.PrimerLugar = e.IdEquipo AND NEW.TercerLugar = e.IdEquipo) OR (NEW.SegundoLugar = e.IdEquipo AND NEW.TercerLugar = e.IdEquipo)) > 0 THEN
		RAISE EXCEPTION 'Error: mismo equipo no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER DistintosEquiposPrimerSegunTercerPuesto BEFORE INSERT ON CompetenciaCombateEquipos FOR EACH ROW EXECUTE PROCEDURE checkDistintosEquiposPrimerSegunTercerPuesto();

-- Restricción 17: Todo competidor que está en alguna de las relaciones “Primer lugar en”, “Segundo lugar en” o “Tercer lugar en” debe estar inscripto a dicha competencia a la cual pertenece la relación.

CREATE FUNCTION checkPodioInscriptosCompetencia() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF NEW.PrimerLugar <> NULL AND (SELECT COUNT(1) FROM Competidor c, InscriptoEn ie WHERE NEW.PrimerLugar = c.DNI AND NEW.IdCompetencia = ie.IdCompetencia AND c.DNI = ie.DNIAlumno) > 0 THEN
		RAISE EXCEPTION 'Error: primer lugar no esta inscripto en la competencia.';
	ELSE
		IF NEW.SegundoLugar <> NULL AND (SELECT COUNT(1) FROM Competidor c, InscriptoEn ie WHERE NEW.SegundoLugar = c.DNI AND NEW.IdCompetencia = ie.IdCompetencia AND c.DNI = ie.DNIAlumno) > 0 THEN
			RAISE EXCEPTION 'Error: segundo lugar no esta inscripto en la competencia.';
		ELSE
			IF NEW.TercerLugar <> NULL AND (SELECT COUNT(1) FROM Competidor c, InscriptoEn ie WHERE NEW.TercerLugar = c.DNI AND NEW.IdCompetencia = ie.IdCompetencia AND c.DNI = ie.DNIAlumno) > 0 THEN
				RAISE EXCEPTION 'Error: tercer lugar no esta inscripto en la competencia.';
			ELSE
				RETURN NEW;
			END IF;
		END IF;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER PodioInscriptosCompetencia BEFORE INSERT OR UPDATE ON CompetenciaIndividual FOR EACH ROW EXECUTE PROCEDURE checkPodioInscriptosCompetencia();

-- Restricción 18: Todo Equipo que está en alguna de las relaciones “Primer lugar en”, “Segundo lugar en” o “Tercer lugar en” debe estar inscripto y habilitado en dicha competencia a la cual pertenece la relación.

CREATE FUNCTION checkPodioInscriptosEquipoCompetencia() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF NEW.PrimerLugar <> NULL AND (SELECT COUNT(1) FROM Equipo e, EquipoInscriptoEn ei WHERE NEW.PrimerLugar = e.IdEquipo AND NEW.IdCompetencia = ei.IdCompetencia AND e.IdEquipo = ei.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: primer lugar no esta inscripto en la competencia.';
	ELSE
		IF NEW.SegundoLugar <> NULL AND (SELECT COUNT(1) FROM Equipo e, EquipoInscriptoEn ei WHERE NEW.SegundoLugar = e.IdEquipo AND NEW.IdCompetencia = ei.IdCompetencia AND e.IdEquipo = ei.IdEquipo) > 0 THEN
			RAISE EXCEPTION 'Error: segundo lugar no esta inscripto en la competencia.';
		ELSE
			IF NEW.TercerLugar <> NULL AND (SELECT COUNT(1) FROM Equipo e, EquipoInscriptoEn ei WHERE NEW.TercerLugar = e.IdEquipo AND NEW.IdCompetencia = ei.IdCompetencia AND e.IdEquipo = ei.IdEquipo) > 0 THEN
				RAISE EXCEPTION 'Error: tercer lugar no esta inscripto en la competencia.';
			ELSE
				RETURN NEW;
			END IF;
		END IF;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER PodioInscriptosEquipoCompetencia BEFORE INSERT OR UPDATE ON CompetenciaCombateEquipos FOR EACH ROW EXECUTE PROCEDURE checkPodioInscriptosEquipoCompetencia();

-- Restricción 19: Cada competidor puede estar inscripto en una sola categoria.

CREATE FUNCTION checkUnaSolaCategoriaPorCompetidor() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM CompetenciaIndividual ci1, CompetenciaIndividual ci2, InscriptoEn ie WHERE NEW.DNIAlumno = ie.DNIAlumno AND NEW.IdCompetencia = ci1.IdCompetencia AND ie.IdCompetencia = ci2.IdCompetencia AND ci1.Modalidad = ci2.Modalidad) > 0 THEN
		RAISE EXCEPTION 'Error: competidor ya inscripto en esa modalidad.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER UnaSolaCategoriaPorCompetidor BEFORE INSERT ON InscriptoEn FOR EACH ROW EXECUTE PROCEDURE checkUnaSolaCategoriaPorCompetidor();

COMMIT;
