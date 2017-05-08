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
