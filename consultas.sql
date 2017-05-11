/*1. El listado de inscriptos en cada categoría para el armado de llaves */

/* Listado de inscriptos en la modalidad competencia rotura*/
SELECT 	
	comp.IdCompetencia as "ID competencia", comp.Sexo as "Categoria sexo", ci.Graduacion as "Categoria graduacion",
	c.Sexo as "Sexo competidor", a1.Graduacion as "Graduacion competidor", a1.DNI as "DNI competidor", a1.Nombre as "Nombre competidor", a1.Apellido as "Apellido competidor",
	a2.DNI as "DNI coach", a2.Nombre as "Nombre coach", a2.Apellido as "Apellido coach"
FROM inscriptoen ie, alumno a1, alumno a2, competidor c, competencia comp, competenciaindividual ci, competenciarotura cr
WHERE a1.DNI = ie.DNIAlumno
AND a2.DNI = ie.DNICoach
AND c.DNI = a1.DNI
AND comp.IdCompetencia = ie.IdCompetencia
AND comp.IdCompetencia = ci.IdCompetencia
AND comp.IdCompetencia = cr.IdCompetencia
ORDER BY comp.Sexo, ci.Graduacion, comp.IdCompetencia ASC;

/* Listado de inscriptos en la modalidad competencia salto*/

SELECT 	comp.IdCompetencia as "ID competencia", comp.Sexo as "Categoria sexo", ci.Graduacion as "Categoria graduacion", cs.edad as "Categoria edad",
	c.Sexo as "Sexo competidor", a1.Graduacion as "Graduacion competidor", EXTRACT(YEAR FROM AGE(c.fechadenacimiento)) as "Edad competidor", a1.DNI as "DNI competidor", a1.Nombre as "Nombre competidor", a1.Apellido as "Apellido competidor",
	a2.DNI as "DNI coach", a2.Nombre as "Nombre coach", a2.Apellido as "Apellido coach"
FROM inscriptoen ie, alumno a1, alumno a2, competidor c, competencia comp, competenciaindividual ci, competenciasalto cs
WHERE a1.DNI = ie.DNIAlumno
AND a2.DNI = ie.DNICoach
AND c.DNI = a1.DNI
AND comp.IdCompetencia = ie.IdCompetencia
AND comp.IdCompetencia = ci.IdCompetencia
AND comp.IdCompetencia = cs.IdCompetencia
ORDER BY comp.Sexo, ci.Graduacion, comp.IdCompetencia ASC;


/* Listado de inscriptos en la modalidad competencia formas*/

SELECT 	comp.IdCompetencia as "ID competencia", comp.Sexo as "Categoria sexo", ci.Graduacion as "Categoria graduacion", cf.edad as "Categoria edad",
	c.Sexo as "Sexo competidor", a1.Graduacion as "Graduacion competidor", EXTRACT(YEAR FROM AGE(c.fechadenacimiento)) as "Edad competidor", a1.DNI as "DNI competidor", a1.Nombre as "Nombre competidor", a1.Apellido as "Apellido competidor",
	a2.DNI as "DNI coach", a2.Nombre as "Nombre coach", a2.Apellido as "Apellido coach"
FROM inscriptoen ie, alumno a1, alumno a2, competidor c, competencia comp, competenciaindividual ci, competenciaformas cf
WHERE a1.DNI = ie.DNIAlumno
AND a2.DNI = ie.DNICoach
AND c.DNI = a1.DNI
AND comp.IdCompetencia = ie.IdCompetencia
AND comp.IdCompetencia = ci.IdCompetencia
AND comp.IdCompetencia = cf.IdCompetencia
ORDER BY comp.Sexo, ci.Graduacion, comp.IdCompetencia ASC;

/* Listado de inscriptos en la modalidad competencia combate individual*/

SELECT 	comp.IdCompetencia as "ID competencia", comp.Sexo as "Categoria sexo", ci.Graduacion as "Categoria graduacion", cci.edad as "Categoria edad", cci.peso as "Categoria peso",
	c.Sexo as "Sexo competidor", a1.Graduacion as "Graduacion competidor", EXTRACT(YEAR FROM AGE(c.fechadenacimiento)) as "Edad competidor", c.peso as "Peso competidor", a1.DNI as "DNI competidor", a1.Nombre as "Nombre competidor", a1.Apellido as "Apellido competidor",
	a2.DNI as "DNI coach", a2.Nombre as "Nombre coach", a2.Apellido as "Apellido coach"
FROM inscriptoen ie, alumno a1, alumno a2, competidor c, competencia comp, competenciaindividual ci, competenciacombateindividual cci
WHERE a1.DNI = ie.DNIAlumno
AND a2.DNI = ie.DNICoach
AND c.DNI = a1.DNI
AND comp.IdCompetencia = ie.IdCompetencia
AND comp.IdCompetencia = ci.IdCompetencia
AND comp.IdCompetencia = cci.IdCompetencia
ORDER BY comp.Sexo, ci.Graduacion, comp.IdCompetencia ASC;

/* Listado de inscriptos en la modalidad competencia combate equipo*/

SELECT DISTINCT comp.IdCompetencia as "ID competencia", comp.Sexo as "Categoria sexo",
	c.Sexo as "Sexo equipo", e.NombreDeFantasia as "Nombre de fantasia equipo",
	a2.DNI as "DNI coach", a2.Nombre as "Nombre coach", a2.Apellido as "Apellido coach"
FROM equipoinscriptoen ie, equipo e, alumno a2, competidor c, competencia comp, CompetenciaCombateEquipos cce
WHERE a2.DNI = ie.DNICoach
AND e.IdEquipo = ie.IdEquipo
AND c.IdEquipo = e.IdEquipo
AND comp.IdCompetencia = ie.IdCompetencia
AND comp.IdCompetencia = cce.IdCompetencia
ORDER BY comp.Sexo, comp.IdCompetencia ASC;

/*2. Pais con mas medallas de oro */

Select * from Pais p where (
(select count(*) from Escuela es, Alumno a where es.IdPais = p.IdPais and es.IdEscuela = a.IdEscuela and Exists(select count(1) from Competidor com, 
CompetenciaIndividual ci where com.DNI = a.DNI and ci.PrimerLugar = com.DNI)) + 
(select count(*) from Escuela es, Equipo eq where es.IdPais = p.IdPais and exists(select count(1) from Alumno al, Competidor comEq where
comEq.IdEquipo = eq.IdEquipo and al.DNI = comEQ.DNI and  es.IdEscuela = al.IdEscuela) and 
Exists(select count(1) from CompetenciaCombateEquipos cce where cce.PrimerLugar = eq.IdEquipo))

)>= ALL  (select sum((select count(*) from Escuela es, Alumno a where es.IdPais = paisAux.IdPais and es.IdEscuela = a.IdEscuela and Exists(select count(1) from Competidor com, 
CompetenciaIndividual ci where com.DNI = a.DNI and ci.PrimerLugar = com.DNI)) + 
(select count(*) from Escuela es, Equipo eq where es.IdPais = paisAux.IdPais and exists(select count(1) from Alumno al, Competidor comEq where
comEq.IdEquipo = eq.IdEquipo and al.DNI = comEQ.DNI and  es.IdEscuela = al.IdEscuela) and 
Exists(select count(1) from CompetenciaCombateEquipos cce where cce.PrimerLugar = eq.IdEquipo))) from Pais paisAux);

/*Pais con mas medallas de plata */

Select * from Pais p where (
(select count(*) from Escuela es, Alumno a where es.IdPais = p.IdPais and es.IdEscuela = a.IdEscuela and Exists(select count(1) from Competidor com, 
CompetenciaIndividual ci where com.DNI = a.DNI and ci.SegundoLugar = com.DNI)) + 
(select count(*) from Escuela es, Equipo eq where es.IdPais = p.IdPais and exists(select count(1) from Alumno al, Competidor comEq where
comEq.IdEquipo = eq.IdEquipo and al.DNI = comEQ.DNI and  es.IdEscuela = al.IdEscuela) and 
Exists(select count(1) from CompetenciaCombateEquipos cce where cce.SegundoLugar = eq.IdEquipo))

)>= ALL  (select sum((select count(*) from Escuela es, Alumno a where es.IdPais = paisAux.IdPais and es.IdEscuela = a.IdEscuela and Exists(select count(1) from Competidor com, 
CompetenciaIndividual ci where com.DNI = a.DNI and ci.SegundoLugar = com.DNI)) + 
(select count(*) from Escuela es, Equipo eq where es.IdPais = paisAux.IdPais and exists(select count(1) from Alumno al, Competidor comEq where
comEq.IdEquipo = eq.IdEquipo and al.DNI = comEQ.DNI and  es.IdEscuela = al.IdEscuela) and 
Exists(select count(1) from CompetenciaCombateEquipos cce where cce.SegundoLugar = eq.IdEquipo))) from Pais paisAux);


/*Pais con mas medallas de bronce */

Select * from Pais p where (
(select count(*) from Escuela es, Alumno a where es.IdPais = p.IdPais and es.IdEscuela = a.IdEscuela and Exists(select count(1) from Competidor com, 
CompetenciaIndividual ci where com.DNI = a.DNI and ci.TercerLugar = com.DNI)) + 
(select count(*) from Escuela es, Equipo eq where es.IdPais = p.IdPais and exists(select count(1) from Alumno al, Competidor comEq where
comEq.IdEquipo = eq.IdEquipo and al.DNI = comEQ.DNI and  es.IdEscuela = al.IdEscuela) and 
Exists(select count(1) from CompetenciaCombateEquipos cce where cce.TercerLugar = eq.IdEquipo))

)>= ALL  (select sum((select count(*) from Escuela es, Alumno a where es.IdPais = paisAux.IdPais and es.IdEscuela = a.IdEscuela and Exists(select count(1) from Competidor com, 
CompetenciaIndividual ci where com.DNI = a.DNI and ci.TercerLugar = com.DNI)) + 
(select count(*) from Escuela es, Equipo eq where es.IdPais = paisAux.IdPais and exists(select count(1) from Alumno al, Competidor comEq where
comEq.IdEquipo = eq.IdEquipo and al.DNI = comEQ.DNI and  es.IdEscuela = al.IdEscuela) and 
Exists(select count(1) from CompetenciaCombateEquipos cce where cce.TercerLugar = eq.IdEquipo))) from Pais paisAux);


/* 3. Ranking Competidores */
SELECT E.Nombre as "Escuela", 
((SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.PrimerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.PrimerLugar = A.DNI)) * 3 +
((SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.SegundoLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.SegundoLugar = A.DNI)) * 2 +
((SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.TercerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.TercerLugar = A.DNI)) as "Puntos"
 FROM Escuela E ORDER BY "Puntos" DESC;

SELECT P.Nombre as "País", 
SUM(
((SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.PrimerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.PrimerLugar = A.DNI)) * 3 +
((SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.SegundoLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.SegundoLugar = A.DNI)) * 2 +
((SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.TercerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.TercerLugar = A.DNI))
) as "Puntos"
 FROM Pais P, Escuela E WHERE P.IdPais = E.IdPais GROUP BY P.IdPais ORDER BY "Puntos" DESC; 

 
-- 4. Dado un competidor(DNIComp) la lista de categorias donde haya participado

CREATE OR REPLACE FUNCTION CategoriasEnLasQueParticipo(DNIComp INTEGER)
RETURNS TABLE(IdCategoria INTEGER, Resultado TEXT)
AS
$$
SELECT IE.IdCompetencia as "ID Competencia",
CASE
	WHEN CI.PrimerLugar = C.DNI THEN 'Primer lugar'
	WHEN CI.SegundoLugar = C.DNI THEN 'Segundo lugar'
	WHEN CI.TercerLugar = C.DNI THEN 'Tercer lugar'
	ELSE 'Sin resultado'
END as "Resultado"
FROM Competidor C, InscriptoEn IE, CompetenciaIndividual CI WHERE C.DNI = DNIComp AND IE.DNIAlumno = C.DNI AND CI.IdCompetencia = IE.IdCompetencia;
$$
LANGUAGE SQL IMMUTABLE STRICT;

-- Ejemplo de uso
-- SELECT CategoriasEnLasQueParticipo(10000518);

-- 5. El medallero por escuela.
SELECT E.Nombre as "Escuela", 
(SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.PrimerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.PrimerLugar = A.DNI) as "Medallas de Oro",
(SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.SegundoLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.SegundoLugar = A.DNI) as "Medallas de Plata",
(SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.TercerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.TercerLugar = A.DNI) as "Medallas de Bronce"
 FROM Escuela E;


-- 6. El listado de los arbitros por pais.
SELECT P.Nombre as "País", A.Nombre, A.Apellido FROM Pais P, Arbitro A WHERE P.IdPais = A.IdPais ORDER BY P.Nombre;

-- 7. La lista de todos los arbitros que actuaron como arbitro central en las modalidades de combate.
SELECT A.Nombre, A.Apellido FROM Arbitro A, ArbitroCentral AC, Ring R, Competencia C, CompetenciaIndividual CI, SeRealizaEn SRE 
WHERE A.NroPlacaArbitro = AC.NroPlacaArbitro AND AC.IdRing = R.IdRing AND R.IdRing = SRE.IdRing AND SRE.IdCompetencia = C.IdCompetencia AND 
(C.TipoCompetencia = 1 OR (C.IdCompetencia = CI.IdCompetencia AND CI.Modalidad = 2));

-- 8. La lista de equipos por pais.
SELECT DISTINCT P.Nombre as "País", EQ.NombreDeFantasia as "Nombre Equipo" FROM Pais P, Escuela E, Alumno A, Competidor C, Equipo EQ WHERE P.IdPais = E.IdPais AND E.IdEscuela = A.IdEscuela AND A.DNI = C.DNI AND C.IdEquipo = EQ.IdEquipo ORDER BY P.Nombre;
