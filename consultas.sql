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
, c.Resultado as Resultado from ((CompetenciaCombateEquipoDeCompetidor Union CompetenciaSaltoDeCompetidor Union CompetenciaFormasDeCompetidor Union CompetenciaCombateIndividualDeCompetidor Union CompetenciaRoturaDeCompetidor) left join ResultadosCompetenciasCompetidor) c

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
