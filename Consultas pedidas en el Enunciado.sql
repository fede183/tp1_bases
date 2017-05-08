#Pais con mas medallas de oro

select pais.nombre from Pais pais where
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.PrimerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from "CompetenciaIndividual" ci where ci.PrimerLugar = competidor.DNI) from "Competidor" competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = pais.IdPais)
=
select max(
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.PrimerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from "CompetenciaIndividual" ci where ci.PrimerLugar = competidor.DNI) from "Competidor" competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = paisSuma.IdPais
)
from Pais paisSuma)

#Pais con mas medallas de plata

select pais.nombre from Pais pais where
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.SegundoLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from "CompetenciaIndividual" ci where ci.SegundoLugar = competidor.DNI) from "Competidor" competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = pais.IdPais)
=
select max(
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.SegundoLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from "CompetenciaIndividual" ci where ci.SegundoLugar = competidor.DNI) from "Competidor" competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = paisSuma.IdPais
)
from Pais paisSuma)

#Pais con mas medallas de bronce

select pais.nombre from Pais pais where
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.TercerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from "CompetenciaIndividual" ci where ci.TercerLugar = competidor.DNI) from "Competidor" competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = pais.IdPais)
=
select max(
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.TercerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from "CompetenciaIndividual" ci where ci.TercerLugar = competidor.DNI) from "Competidor" competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = paisSuma.IdPais
)
from Pais paisSuma)

# 5. El medallero por escuela.
CREATE TEMP TABLE OrosPorEscuela AS SELECT E.IdEscuela, E.Nombre, COUNT(*) AS Oro FROM "Escuela" E, "Alumno" A, "InscriptoEn" IE, "CompetenciaIndividual" CI WHERE E.IdEscuela = A.IdEscuela AND A.DNI = IE.DNI AND IE.IdCompetencia = CI.IdCompetencia AND CI.PrimerLugar = A.DNI GROUP BY E.IdEscuela;

CREATE TEMP TABLE PlatasPorEscuela AS SELECT E.IdEscuela, E.Nombre, COUNT(*) AS Plata FROM "Escuela" E, "Alumno" A, "InscriptoEn" IE, "CompetenciaIndividual" CI WHERE E.IdEscuela = A.IdEscuela AND A.DNI = IE.DNI AND IE.IdCompetencia = CI.IdCompetencia AND CI.SegundoLugar = A.DNI GROUP BY E.IdEscuela;

CREATE TEMP TABLE BroncePorEscuela AS SELECT E.IdEscuela, E.Nombre, COUNT(*) AS Bronce FROM "Escuela" E, "Alumno" A, "InscriptoEn" IE, "CompetenciaIndividual" CI WHERE E.IdEscuela = A.IdEscuela AND A.DNI = IE.DNI AND IE.IdCompetencia = CI.IdCompetencia AND CI.TercerLugar = A.DNI GROUP BY E.IdEscuela;

SELECT OPE.IdEscuela, OPE.Nombre, OPE.Oro, PPE.Plata, BPE.Bronce FROM "OrosPorEscuela" OPE, "PlatasPorEscuela" PPE, "BroncePorEscuela" BPE WHERE OPE.IdEscuela = PPE.IdEscuela AND PPE.IdEscuela = BPE.IdEscuela;

SELECT IdEscuela, 
# 6. El listado de los arbitros por pais.
SELECT P.Nombre, A.Nombre, A.Apellido FROM "Pais" P, "Arbitro" A WHERE P.IdPais = A.IdPais ORDER BY P.Nombre;

# 7. La lista de todos los arbitros que actuaron como arbitro central en las modalidades de combate.
SELECT A.Nombre, A.Apellido FROM "Arbitro" A, "ArbitroCentral" AC, "Ring" R, "Competencia" C, "CompetenciaIndividual" CI, "SeRealizaEn" SRE WHERE A.NroPlacaArbitro = AC.NroPlacaArbitro AND AC.IdRing = R.IdRing AND R.IdRing = SRE.IdRing AND SRE.IdCompetencia = C.IdCompetencia AND (C.Tipo = "CompetenciaCombateEquipos" OR (C.IdCompetencia = CI.IdCompetencia AND CI.Modalidad = "CompetenciaCombateIndividual"));

# 8. La lista de equipos por pais.
SELECT DISTINCT P.Nombre, EQ.NombreDeFantasia FROM Pais P, Escuela E, Alumno A, Competidor C, Equipo EQ WHERE P.IdPais = E.IdPais AND E.IdEscuela = A.IdEscuela AND A.DNI = C.DNI AND C.IdEquipo = EQ.IdEquipo ORDER BY P.Nombre;
