BEGIN TRANSACTION;
INSERT INTO Pais (IdPais, Nombre)
VALUES (1, "Argentina");

INSERT INTO Escuela (IdEscuela, Nombre, IdPais)
VALUES (1, "FCEN", 1);

INSERT INTO Maestro (NroDePlacaDeInstructor, Nombre, Apellido, Graduacion, IdPais, IdEscuela)
VALUES (110, "Lin", "ChinMin", 6, 1, 1);

INSERT INTO Alumno (DNI, IdEscuela, Nombre, Apellido, Graduacion, NroCertificadoGraduacionITF, Foto)
VALUES (15000000, 1, "Andrea", "Manna", 1, 1200, "Foto");
INSERT INTO Alumno (DNI, IdEscuela, Nombre, Apellido, Graduacion, NroCertificadoGraduacionITF, Foto)
VALUES (16000000, 1, "Alguien", "Otro", 1, 1300, "Foto");

INSERT INTO Competidor (DNI, FechaDeNacimiento, Sexo, Edad, Titular, IdEquipo)
VALUES (15000000, 1, DATE "2001-02-16", "F", 45, 1, 1);

INSERT INTO Equipo (IdEquipo, NombreDeFantasia)
VALUES (1, "elEquipo");

COMMIT;
