# 2. Paises con más medallas
#Pais con mas medallas de oro

select pais.nombre from Pais pais where
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.PrimerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from CompetenciaIndividual ci where ci.PrimerLugar = competidor.DNI) from Competidor competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = pais.IdPais)
=
select max(
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.PrimerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from CompetenciaIndividual ci where ci.PrimerLugar = competidor.DNI) from Competidor competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = paisSuma.IdPais
)
from Pais paisSuma)

#Pais con mas medallas de plata

select pais.nombre from Pais pais where
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.SegundoLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from CompetenciaIndividual ci where ci.SegundoLugar = competidor.DNI) from Competidor competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = pais.IdPais)
=
select max(
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.SegundoLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from CompetenciaIndividual ci where ci.SegundoLugar = competidor.DNI) from Competidor competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = paisSuma.IdPais
)
from Pais paisSuma)

#Pais con mas medallas de bronce

select pais.nombre from Pais pais where
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.TercerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from CompetenciaIndividual ci where ci.TercerLugar = competidor.DNI) from Competidor competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = pais.IdPais)
=
select max(
select sum(
select sum(select count(*) from CompetenciaCombateEquipos cce where cce.TercerLugar = equipo.IdEquipo) from Equipo equipo where EXISTS(Select * from Competidor comEquipo where Exists(Select * from Alumnos alum where alum.DNI = comEquipo.DNI AND alum.IdEscuela = escuela.IdEscuela) AND comEquipo.IdEquipo = equipo.IdEquipo) +
select sum(select count(*) from CompetenciaIndividual ci where ci.TercerLugar = competidor.DNI) from Competidor competidor where EXISTS(Select * from Alumnos alum where alum.DNI = competidor.DNI AND alum.IdEscuela = escuela.IdEscuela)
) from Escuela escuela where escuela.IdPais = paisSuma.IdPais
)
from Pais paisSuma)

# 4. Dado un competidor(comp) la lista de categorias donde haya participado
CREATE TEMP TABLE CompetenciasDeCompetidor AS select IdCompetencia as IdCompetencia from InscriptoEn IE where IE.DNIAlumno = comp.DNI Union select IdCompetencia from EquipoInscriptoEn EIE where EIE.IdEquipo = comp.IdEquipo

CREATE TEMP TABLE CompetenciaCombateEquipoDeCompetidor AS select c.IdCompetencia as IdCompetencia, c.Tipo as Tipo, c.Sexo as Sexo, cce.Edad as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaCombateEquipo cce where c.IdCompetencia = cce.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia)

CREATE TEMP TABLE CompetenciaSaltoDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, cs.Edad as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaSalto cs, CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cs.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia)

CREATE TEMP TABLE CompetenciaFormasDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, cf.Edad as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaFormas cf , CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cf.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia)

CREATE TEMP TABLE CompetenciaCombateIndividualDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, cci.Edad as Edad, cci.Peso as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaCombateIndividual cci , CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cci.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia)

CREATE TEMP TABLE CompetenciaRoturaDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, NULL as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaRotura cr , CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cr.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia)



CREATE TEMP TABLE ResultadosCompetenciasCompetidorOroIndividual AS select cci.IdCompetencia as IdCompetencia, 'Oro' as Resultado from CompetenciaCombateIndividual cci where exists(select * from 
cci.PrimerLugar = comp.DNI)

CREATE TEMP TABLE ResultadosCompetenciasCompetidorOroIndividual AS select cci.IdCompetencia as IdCompetencia, 'Plata' as Resultado from CompetenciaCombateIndividual cci where exists(select * from 
cci.SegundoLugar = comp.DNI)

CREATE TEMP TABLE ResultadosCompetenciasCompetidorOroIndividual AS select cci.IdCompetencia as IdCompetencia, 'Bronce' as Resultado from CompetenciaCombateIndividual cci where exists(select * from 
cci.TercerLugar = comp.DNI)


CREATE TEMP TABLE ResultadosCompetenciasCompetidorOroEquipo AS select cce.IdCompetencia as IdCompetencia, 'Oro' as Resultado from CompetenciaCombateEquipo cce where exists(select * from 
cce.PrimerLugar = comp.IdEquipo)

CREATE TEMP TABLE ResultadosCompetenciasCompetidorPlataEquipo AS select cce.IdCompetencia as IdCompetencia, 'Plata' as Resultado from CompetenciaCombateEquipo cce where exists(select * from 
cce.SegundoLugar = comp.IdEquipo)

CREATE TEMP TABLE ResultadosCompetenciasCompetidorBronceEquipo AS select cce.IdCompetencia as IdCompetencia, 'Bronce' as Resultado from CompetenciaCombateEquipo cce where exists(select * from 
cce.TercerLugar = comp.IdEquipo)

CREATE TEMP TABLE ResultadosCompetenciasCompetidor AS ResultadosCompetenciasCompetidorOroEquipo union ResultadosCompetenciasCompetidorPlataEquipo union ResultadosCompetenciasCompetidorBronceEquipo union ResultadosCompetenciasCompetidorOroIndividual union ResultadosCompetenciasCompetidorPlataEquipo union ResultadosCompetenciasCompetidorBronceEquipo

#El Resultado
select c.Tipo as Tipo, c.Sexo as Sexo, c.Edad as Edad, c.Peso as Peso, c.Graduacion as Graduacion
, c.Resultado as Resultado from ((CompetenciaCombateEquipoDeCompetidor Union CompetenciaSaltoDeCompetidor Union CompetenciaFormasDeCompetidor Union CompetenciaCombateIndividualDeCompetidor Union CompetenciaRoturaDeCompetidor) left outer join ResultadosCompetenciasCompetidor) c

# 5. El medallero por escuela.
CREATE TEMP TABLE OrosPorEscuela AS SELECT E.IdEscuela, E.Nombre, COUNT(*) AS Oro FROM Escuela E, Alumno A, InscriptoEn IE, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND A.DNI = IE.DNI AND IE.IdCompetencia = CI.IdCompetencia AND CI.PrimerLugar = A.DNI GROUP BY E.IdEscuela;

CREATE TEMP TABLE PlatasPorEscuela AS SELECT E.IdEscuela, E.Nombre, COUNT(*) AS Plata FROM Escuela E, Alumno A, InscriptoEn IE, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND A.DNI = IE.DNI AND IE.IdCompetencia = CI.IdCompetencia AND CI.SegundoLugar = A.DNI GROUP BY E.IdEscuela;

CREATE TEMP TABLE BroncePorEscuela AS SELECT E.IdEscuela, E.Nombre, COUNT(*) AS Bronce FROM Escuela E, Alumno A, InscriptoEn IE, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND A.DNI = IE.DNI AND IE.IdCompetencia = CI.IdCompetencia AND CI.TercerLugar = A.DNI GROUP BY E.IdEscuela;

SELECT OPE.IdEscuela, OPE.Nombre, OPE.Oro, PPE.Plata, BPE.Bronce FROM OrosPorEscuela OPE, PlatasPorEscuela PPE, BroncePorEscuela BPE WHERE OPE.IdEscuela = PPE.IdEscuela AND PPE.IdEscuela = BPE.IdEscuela;

SELECT IdEscuela, 
# 6. El listado de los arbitros por pais.
SELECT P.Nombre, A.Nombre, A.Apellido FROM Pais P, Arbitro A WHERE P.IdPais = A.IdPais ORDER BY P.Nombre;

# 7. La lista de todos los arbitros que actuaron como arbitro central en las modalidades de combate.
SELECT A.Nombre, A.Apellido FROM Arbitro A, ArbitroCentral AC, Ring R, Competencia C, CompetenciaIndividual CI, SeRealizaEn SRE WHERE A.NroPlacaArbitro = AC.NroPlacaArbitro AND AC.IdRing = R.IdRing AND R.IdRing = SRE.IdRing AND SRE.IdCompetencia = C.IdCompetencia AND (C.Tipo = CompetenciaCombateEquipos OR (C.IdCompetencia = CI.IdCompetencia AND CI.Modalidad = CompetenciaCombateIndividual));

# 8. La lista de equipos por pais.
SELECT DISTINCT P.Nombre, EQ.NombreDeFantasia FROM Pais P, Escuela E, Alumno A, Competidor C, Equipo EQ WHERE P.IdPais = E.IdPais AND E.IdEscuela = A.IdEscuela AND A.DNI = C.DNI AND C.IdEquipo = EQ.IdEquipo ORDER BY P.Nombre;
=======
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
>>>>>>> 6e5c1fd621f941ecf15dcd62d16b4e7a8fb4c8c5
