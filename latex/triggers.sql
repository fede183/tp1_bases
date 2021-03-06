
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


CREATE FUNCTION checkCompetidorSinEquipoNoEsTitularNiSup() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF NEW.IdEquipo = NULL AND NEW.Titular <> NULL THEN
		RAISE EXCEPTION 'Error: competidor no pertenece a un equipo y figura como titular.';
	ELSE
		RETURN NEW;
	END IF;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER CompetidorSinEquipoNoEsTitularNiSup BEFORE INSERT OR UPDATE ON Competidor FOR EACH ROW EXECUTE PROCEDURE checkCompetidorSinEquipoNoEsTitularNiSup();

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

CREATE FUNCTION checkDistintosCompetidoresPrimerSegunTercerPuesto() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Competidor c WHERE NEW.PrimerLugar = c.DNI AND NEW.SegundoLugar = c.DNI) > 0 THEN
		RAISE EXCEPTION 'Error: mismo competidor no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;

	IF (SELECT COUNT(1) FROM Competidor c WHERE NEW.PrimerLugar = c.DNI AND NEW.TercerLugar = c.DNI) > 0 THEN
		RAISE EXCEPTION 'Error: mismo competidor no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;

	IF (SELECT COUNT(1) FROM Competidor c WHERE NEW.SegundoLugar = c.DNI AND NEW.TercerLugar = c.DNI) > 0 THEN
		RAISE EXCEPTION 'Error: mismo competidor no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;

    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER DistintosCompetidoresPrimerSegunTercerPuesto BEFORE INSERT ON CompetenciaIndividual FOR EACH ROW EXECUTE PROCEDURE checkDistintosCompetidoresPrimerSegunTercerPuesto();

CREATE FUNCTION checkDistintosEquiposPrimerSegunTercerPuesto() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF (SELECT COUNT(1) FROM Equipo e WHERE NEW.PrimerLugar = e.IdEquipo AND NEW.SegundoLugar = e.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: mismo equipo no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;

	IF (SELECT COUNT(1) FROM Equipo e WHERE NEW.PrimerLugar = e.IdEquipo AND NEW.TercerLugar = e.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: mismo equipo no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;

	IF (SELECT COUNT(1) FROM Equipo e WHERE NEW.SegundoLugar = e.IdEquipo AND NEW.TercerLugar = e.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: mismo equipo no puede obtener mas de un lugar.';
	ELSE
		RETURN NEW;
	END IF;

    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER DistintosEquiposPrimerSegunTercerPuesto BEFORE INSERT ON CompetenciaCombateEquipos FOR EACH ROW EXECUTE PROCEDURE checkDistintosEquiposPrimerSegunTercerPuesto();

CREATE FUNCTION checkPodioInscriptosCompetencia() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF NEW.PrimerLugar <> NULL AND (SELECT COUNT(1) FROM Competidor c, InscriptoEn ie WHERE NEW.PrimerLugar = c.DNI AND NEW.IdCompetencia = ie.IdCompetencia AND c.DNI = ie.DNIAlumno) > 0 THEN
		RAISE EXCEPTION 'Error: primer lugar no esta inscripto en la competencia.';
	ELSE
		RETURN NEW;
	END IF;

	IF NEW.SegundoLugar <> NULL AND (SELECT COUNT(1) FROM Competidor c, InscriptoEn ie WHERE NEW.SegundoLugar = c.DNI AND NEW.IdCompetencia = ie.IdCompetencia AND c.DNI = ie.DNIAlumno) > 0 THEN
		RAISE EXCEPTION 'Error: segundo lugar no esta inscripto en la competencia.';
	ELSE
		RETURN NEW;
	END IF;

	IF NEW.TercerLugar <> NULL AND (SELECT COUNT(1) FROM Competidor c, InscriptoEn ie WHERE NEW.TercerLugar = c.DNI AND NEW.IdCompetencia = ie.IdCompetencia AND c.DNI = ie.DNIAlumno) > 0 THEN
		RAISE EXCEPTION 'Error: tercer lugar no esta inscripto en la competencia.';
	ELSE
		RETURN NEW;
	END IF;

    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER PodioInscriptosCompetencia BEFORE INSERT OR UPDATE ON CompetenciaIndividual FOR EACH ROW EXECUTE PROCEDURE checkPodioInscriptosCompetencia();

CREATE FUNCTION checkPodioInscriptosEquipoCompetencia() RETURNS trigger AS $emp_stamp$
    BEGIN
	IF NEW.PrimerLugar <> NULL AND (SELECT COUNT(1) FROM Equipo e, EquipoInscriptoEn ei WHERE NEW.PrimerLugar = e.IdEquipo AND NEW.IdCompetencia = ei.IdCompetencia AND e.IdEquipo = ei.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: primer lugar no esta inscripto en la competencia.';
	ELSE
		RETURN NEW;
	END IF;

	IF NEW.SegundoLugar <> NULL AND (SELECT COUNT(1) FROM Equipo e, EquipoInscriptoEn ei WHERE NEW.SegundoLugar = e.IdEquipo AND NEW.IdCompetencia = ei.IdCompetencia AND e.IdEquipo = ei.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: segundo lugar no esta inscripto en la competencia.';
	ELSE
		RETURN NEW;
	END IF;

	IF NEW.TercerLugar <> NULL AND (SELECT COUNT(1) FROM Equipo e, EquipoInscriptoEn ei WHERE NEW.TercerLugar = e.IdEquipo AND NEW.IdCompetencia = ei.IdCompetencia AND e.IdEquipo = ei.IdEquipo) > 0 THEN
		RAISE EXCEPTION 'Error: tercer lugar no esta inscripto en la competencia.';
	ELSE
		RETURN NEW;
	END IF;

    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER PodioInscriptosEquipoCompetencia BEFORE INSERT OR UPDATE ON CompetenciaCombateEquipos FOR EACH ROW EXECUTE PROCEDURE checkPodioInscriptosEquipoCompetencia();

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
