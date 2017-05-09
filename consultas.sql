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
CREATE TEMP TABLE CantidadOrosCompetidor AS select comp.DNI as DNI, (select count(*) from CompetenciaIndividual CI where CI.PrimerLugar = comp.DNI) as CantidadMedallasOro from Competidor comp;

CREATE TEMP TABLE CantidadPlatasCompetidor AS select comp.DNI as DNI, (select count(*) from CompetenciaIndividual CI where CI.SegundoLugar = comp.DNI) as CantidadMedallasPlata from Competidor comp;

CREATE TEMP TABLE CantidadBroncesCompetidor AS select comp.DNI as DNI, (select count(*) from CompetenciaIndividual CI where CI.TercerLugar = comp.DNI) as CantidadMedallasBronce from Competidor comp;

CREATE TEMP TABLE CantidadOrosEquipo AS select equip.IdEquipo as IdEquipo, (select count(*) from CompetenciaCombateEquipos CCE where CCE.PrimerLugar = equip.IdEquipo) as CantidadMedallasOroEquipos from Equipo equip;

CREATE TEMP TABLE CantidadPlatasEquipo AS select equip.IdEquipo as IdEquipo, (select count(*) from CompetenciaCombateEquipos CCE where CCE.SegundoLugar = equip.IdEquipo) as CantidadMedallasPlataEquipos from Equipo equip;

CREATE TEMP TABLE CantidadBroncesEquipo AS select equip.IdEquipo as IdEquipo, (select count(*) from CompetenciaCombateEquipos CCE where CCE.TercerLugar = equip.IdEquipo) as CantidadMedallasBronceEquipos from Equipo equip;


CREATE TEMP TABLE CantidadMedallasCompetidor AS select * from ((CantidadOrosCompetidor inner join CantidadPlatasCompetidor using(DNI)) inner join 
CantidadBroncesCompetidor using(DNI));

 CREATE TEMP TABLE CantidadMedallasEquipo AS select * from ((CantidadOrosEquipo inner join CantidadPlatasEquipo using(IdEquipo)) inner join 
 CantidadBroncesEquipo using(IdEquipo));

/*Puntaje por Competidor*/
CREATE TEMP TABLE PuntajeCompetidor AS Select cmc.DNI as DNI, (3*cmc.CantidadMedallasOro + 2*cmc.CantidadMedallasPlata + cmc.CantidadMedallasBronce) 
as Puntaje from CantidadMedallasCompetidor cmc;

/*Puntaje por Equipo*/
CREATE TEMP TABLE PuntajeEquipo AS (Select cme.IdEquipo as IdEquipo, (3*cme.CantidadMedallasOroEquipos + 2*cme.CantidadMedallasPlataEquipos + cme.CantidadMedallasBronceEquipos) 
as Puntaje from CantidadMedallasEquipo cme);

/*Puntaje por Escuela Competidor*/
CREATE TEMP TABLE PuntajesEscuelaCompetidor AS (select e.IdEscuela as IdEscuela, sum(pc.Puntaje) as Puntaje from  PuntajeCompetidor pc, Escuela e where 
Exists(select * from Alumno a where a.DNI = pc.DNI and a.IdEscuela = e.IdEscuela) Group by IdEscuela order by Puntaje );

/*Puntaje por Escuela Equipo*/
CREATE TEMP TABLE PuntajeEscuelaEquipo AS select e.IdEscuela as IdEscuela, sum(pe.Puntaje) as Puntaje from Escuela e, PuntajeEquipo pe where Exists(select * from Alumno a where a.IdEscuela 
= e.IdEscuela And Exists(select * from Competidor comp where comp.DNI = a.DNI and comp.IdEquipo = pe.IdEquipo)) Group by IdEscuela order by Puntaje;

/*Puntaje por Escuela*/
CREATE TEMP TABLE PuntajeEscuela AS select pec.IdEscuela as IdEscuela, pec.Puntaje + pee.Puntaje as Puntaje from PuntajesEscuelaCompetidor pec, PuntajeEscuelaEquipo
 pee where pec.IdEscuela = pee.IdEscuela order by Puntaje;

 /*Puntaje por Pais*/ 
 CREATE TEMP TABLE PuntajePais AS select p.IdPais as IdPais, sum(pe.Puntaje) as Puntaje from Pais p, PuntajeEscuela pe where Exists(select * from Escuela es where 
 es.IdEscuela = pe.IdEscuela and es.IdPais = p.IdPais Group by es.IdEscuela) group by IdPais order by Puntaje;

select * from PuntajeEscuela;

select * from PuntajePais;

 
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
SELECT E.Nombre, 
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
