# 2. Paises con más medallas
#Pais con mas medallas de oro

#Pais con mas medallas de plata

#Pais con mas medallas de bronce

DROP TABLE IF EXISTS CantidadOrosCompetidor;
DROP TABLE IF EXISTS CantidadPlatasCompetidor;
DROP TABLE IF EXISTS CantidadBroncesCompetidor;
DROP TABLE IF EXISTS CantidadOrosEquipo;
DROP TABLE IF EXISTS CantidadPlatasEquipo;
DROP TABLE IF EXISTS CantidadBroncesEquipo;
DROP TABLE IF EXISTS CantidadMedallasCompetidor;
DROP TABLE IF EXISTS CantidadMedallasEquipo;
DROP TABLE IF EXISTS PuntajeCompetidor;
DROP TABLE IF EXISTS PuntajeEquipo;
DROP TABLE IF EXISTS PuntajesEscuelaCompetidor;
DROP TABLE IF EXISTS PuntajeEscuelaEquipo;
DROP TABLE IF EXISTS PuntajeEscuela;
DROP TABLE IF EXISTS PuntajePais;

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

 
/* 4. Dado un competidor(DNIComp) la lista de categorias donde haya participado*/
CREATE FUNCTION CategoriasEnLasQueParticipo(@DNIComp int) 
RETURNS table
AS BEGIN

CREATE TEMP TABLE CompetenciasDeCompetidor AS select * from (select IE.IdCompetencia as IdCompetencia from InscriptoEn IE where IE.DNIAlumno = DNIComp) Union 
(select EIE.IdCompetencia from EquipoInscriptoEn EIE where  exists(select * from Competidor comp where comp.DNI = @DNIComp EIE.IdEquipo = comp.IdEquipo));

CREATE TEMP TABLE CompetenciaCombateEquipoDeCompetidor AS select c.IdCompetencia as IdCompetencia, c.Tipo as Tipo, c.Sexo as Sexo, cce.Edad as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaCombateEquipo cce where c.IdCompetencia = cce.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia);

CREATE TEMP TABLE CompetenciaSaltoDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, cs.Edad as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaSalto cs, CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cs.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia);

CREATE TEMP TABLE CompetenciaFormasDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, cf.Edad as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaFormas cf , CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cf.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia);

CREATE TEMP TABLE CompetenciaCombateIndividualDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, cci.Edad as Edad, cci.Peso as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaCombateIndividual cci , CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cci.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia);

CREATE TEMP TABLE CompetenciaRoturaDeCompetidor AS select c.Tipo as Tipo, c.Sexo as Sexo, NULL as Edad, NULL as Peso, ci.Graduacion as Graduacion from 
Competencia c, CompetenciaRotura cr , CompetenciaIndividual ci where ci.IdCompetencia = c.IdCompetencia and c.IdCompetencia = cr.IdCompetencia and 
Exists(select * from CompetenciasDeCompetidor cdc where cdc.IdCompetencia = c.IdCompetencia);



CREATE TEMP TABLE ResultadosCompetenciasCompetidorOroIndividual AS select cci.IdCompetencia as IdCompetencia, 'Oro' as Resultado from CompetenciaCombateIndividual cci where exists(select * from 
cci.PrimerLugar = @DNIComp);

CREATE TEMP TABLE ResultadosCompetenciasCompetidorPlataIndividual AS select cci.IdCompetencia as IdCompetencia, 'Plata' as Resultado from CompetenciaCombateIndividual cci where exists(select * from 
cci.SegundoLugar = @DNIComp);

CREATE TEMP TABLE ResultadosCompetenciasCompetidorBronceIndividual AS select cci.IdCompetencia as IdCompetencia, 'Bronce' as Resultado from CompetenciaCombateIndividual cci where exists(select * from 
cci.TercerLugar = @DNIComp);


CREATE TEMP TABLE ResultadosCompetenciasCompetidorOroEquipo AS select cce.IdCompetencia as IdCompetencia, 'Oro' as Resultado from CompetenciaCombateEquipo
 cce where exists(select * from Equipo eq, Competidor comp where cce.PrimerLugar = comp.IdEquipo and comp.DNI = @DNIComp);

CREATE TEMP TABLE ResultadosCompetenciasCompetidorPlataEquipo AS select cce.IdCompetencia as IdCompetencia, 'Plata' as Resultado from 
CompetenciaCombateEquipo cce where exists(select * from Equipo eq, Competidor comp where cce.PrimerLugar = comp.IdEquipo and comp.DNI = @DNIComp);

CREATE TEMP TABLE ResultadosCompetenciasCompetidorBronceEquipo AS select cce.IdCompetencia as IdCompetencia, 'Bronce' as Resultado from 
CompetenciaCombateEquipo cce where exists(select * from Equipo eq, Competidor comp where cce.PrimerLugar = comp.IdEquipo and comp.DNI = @DNIComp);

CREATE TEMP TABLE ResultadosCompetenciasCompetidor AS ResultadosCompetenciasCompetidorOroEquipo union ResultadosCompetenciasCompetidorPlataEquipo union 
ResultadosCompetenciasCompetidorBronceEquipo union ResultadosCompetenciasCompetidorOroIndividual union ResultadosCompetenciasCompetidorPlataIndividual 
union ResultadosCompetenciasCompetidorBronceIndividual;

CREATE TEMP TABLE CompetenciasCompetidor AS CompetenciaCombateEquipoDeCompetidor Union CompetenciaSaltoDeCompetidor Union CompetenciaFormasDeCompetidor 
Union CompetenciaCombateIndividualDeCompetidor Union CompetenciaRoturaDeCompetidor;

/*El Resultado*/
Return select c.Tipo as Tipo, c.Sexo as Sexo, c.Edad as Edad, c.Peso as Peso, c.Graduacion as Graduacion
, c.Resultado as Resultado from (CompetenciasCompetidor left outer join ResultadosCompetenciasCompetidor ON CompetenciasCompetidor.IdCompetencia = 
ResultadosCompetenciasCompetidor.IdCompetencia) c;

End 

# 5. El medallero por escuela.
SELECT E.Nombre as "Escuela", 
(SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.PrimerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.PrimerLugar = A.DNI) as "Medallas de Oro",
(SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.SegundoLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.SegundoLugar = A.DNI) as "Medallas de Plata",
(SELECT COUNT(1) FROM Alumno A, CompetenciaIndividual CI WHERE E.IdEscuela = A.IdEscuela AND CI.TercerLugar = A.DNI) + 
(SELECT COUNT(DISTINCT CCE.IdCompetencia) FROM Alumno A, CompetenciaCombateEquipos CCE WHERE E.IdEscuela = A.IdEscuela AND CCE.TercerLugar = A.DNI) as "Medallas de Bronce"
 FROM Escuela E;


# 6. El listado de los arbitros por pais.
SELECT P.Nombre, A.Nombre, A.Apellido FROM Pais P, Arbitro A WHERE P.IdPais = A.IdPais ORDER BY P.Nombre;

# 7. La lista de todos los arbitros que actuaron como arbitro central en las modalidades de combate.
SELECT A.Nombre, A.Apellido FROM Arbitro A, ArbitroCentral AC, Ring R, Competencia C, CompetenciaIndividual CI, SeRealizaEn SRE WHERE A.NroPlacaArbitro = AC.NroPlacaArbitro AND AC.IdRing = R.IdRing AND R.IdRing = SRE.IdRing AND SRE.IdCompetencia = C.IdCompetencia AND (C.Tipo = CompetenciaCombateEquipos OR (C.IdCompetencia = CI.IdCompetencia AND CI.Modalidad = CompetenciaCombateIndividual));

# 8. La lista de equipos por pais.
SELECT DISTINCT P.Nombre, EQ.NombreDeFantasia FROM Pais P, Escuela E, Alumno A, Competidor C, Equipo EQ WHERE P.IdPais = E.IdPais AND E.IdEscuela = A.IdEscuela AND A.DNI = C.DNI AND C.IdEquipo = EQ.IdEquipo ORDER BY P.Nombre;
