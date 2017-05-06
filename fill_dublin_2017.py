#!/usr/bin/python
import psycopg2
import pandas as pd
from tqdm import tqdm
from numpy.random import randint
from math import floor
from datetime import datetime

hostname = 'localhost'
username = 'postgres'
password = 'basesdedatos'
database = 'dublin'

insertQueries = {
	'Ring' : """INSERT INTO "Ring" ("IdRing") VALUES (%s);""",
	'Pais' : """INSERT INTO "Pais" ("IdPais","Nombre") VALUES (%s,%s);""",
	'Competencia' : """INSERT INTO "Competencia" ("IdCompetencia","sexo","TipoCompetencia") VALUES (%s, %s, %s);""",
	'Escuela' : """INSERT INTO "Escuela" ("IdEscuela", "Nombre", "IdPais") VALUES (%s, %s, %s);""",
	'Arbitro' : """INSERT INTO "Arbitro" ("NroPlacaArbitro", "Nombre", "Apellido", "Graduacion", "IdPais", "Tipo") VALUES (%s,%s ,%s ,%s ,%s ,%s );""",
	'Alumno' : """INSERT INTO "Alumno" ("DNI", "IdEscuela", "Nombre", "Apellido", "Graduacion", "NroCertificadoGraduacionITF", "Foto") VALUES (%s , %s, %s, %s, %s, %s, %s);""",
	'Coach' : """INSERT INTO "Coach" ("DNI") VALUES (%s);""",
	'Equipo' : """INSERT INTO "Equipo" ("IdEquipo", "NombreDeFantasia") VALUES (%s, %s);""",
	'Maestro' : """INSERT INTO "Maestro" ("NroDePlacaDeInstructor", "Nombre", "Apellido", "Graduacion", "IdPais", "IdEscuela") VALUES (%s, %s, %s, %s, %s, %s);""",
	'PresidenteDeMesa' : """INSERT INTO "PresidenteDeMesa" ("NroPlacaArbitro", "IdRing") VALUES ;""",
	'Juez' : """INSERT INTO "Juez" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'InscriptoEn' : """INSERT INTO "InscriptoEn" ("DNIAlumno", "DNICoach", "IdCompetencia") VALUES (%s, %s, %s);""",
	'EquipoInscriptoEn' : """INSERT INTO "EquipoInscriptoEn" ("IdEquipo", "IdCompetencia", "DNICoach") VALUES (%s, %s, %s);""",
	'Competidor' : """INSERT INTO "Competidor" ("DNI", "FechaDeNacimiento", "Sexo", "Edad", "Titular", "IdEquipo") VALUES (%s, %s, %s, %s, %s, %s);""",
	'CompetenciaSalto' : """INSERT INTO "CompetenciaSalto" ("IdCompetencia", "Edad", "Graduacion") VALUES (%s, %s, %s);""",
	'CompetenciaRotura' : """INSERT INTO "CompetenciaRotura" ("IdCompetencia", "Graduacion") VALUES (%s, %s);""",
	'CompetenciaIndividual' : """INSERT INTO "CompetenciaIndividual" ("IdCompetencia", "PrimerLugar", "SegundoLugar", "TercerLugar", "Modalidad") VALUES (%s, %s, %s, %s, %s);""",
	'CompetenciaFormas' : """INSERT INTO "CompetenciaFormas" ("IdCompetencia", "Edad", "Graduacion") VALUES (%s, %s, %s);""",
	'CompetenciaCombateIndividual' : """INSERT INTO "CompetenciaCombateIndividual" ("IdCompetencia", "Edad", "Graduacion", "Peso") VALUES (%s, %s, %s, %s);""",
	'CompetenciaCombateEquipos' : """INSERT INTO "CompetenciaCombateEquipos" ("IdCompetencia", "PrimerLugar", "SegundoLugar", "TercerLugar", "Edad") VALUES (%s, %s, %s, %s, %s);""",
	'ArbitroDeRecambio' : """INSERT INTO "ArbitroDeRecambio" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'ArbitroCentral' : """INSERT INTO "ArbitroCentral" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'SeRealizaEn' : """INSERT INTO "SeRealizaEn" ("IdCompetencia", "IdRing") VALUES (%s, %s);""",
}

def doInsert(conn,table,values):
    cur = conn.cursor()
    cur.execute(insertQueries[table],values)
    conn.commit()

paises = pd.read_csv('csv/paises.csv')
nombres = pd.read_csv('csv/nombres.csv')
apellidos = pd.read_csv('csv/apellidos.csv')
dni = [10000000 + i for i in range(3000)]
sexo = ['Masculino','Femenino']
escuelas = pd.read_csv('csv/escuelas.csv', sep=',')

def insertPaises(conn):
	print("Cargando Paises...")
	IdPais = 0
	for r in tqdm(paises.iterrows()):
		IdPais += 1
		doInsert(conn, 'Pais', [IdPais, r[1]['Nombre']])

def insertEscuelas(conn):
	print("Cargando Escuelas...")
	IdEscuela = 0
	for r in tqdm(escuelas.iterrows()):
		IdEscuela += 1
		doInsert(conn, 'Escuela', [IdEscuela, r[1]['Nombre'], randint(1,len(paises))])

def insertMaestro(conn):
	print("Cargando Maestros...")
	NroDePlacaDeInstructor = 0
	for r in tqdm(range(len(escuelas))):
		NroDePlacaDeInstructor += 1
		doInsert(conn, 'Maestro', [	NroDePlacaDeInstructor,
									nombres['Nombre'][randint(1,len(nombres))],
									apellidos['Apellido'][randint(1,len(apellidos))],
									randint(1,9),
									randint(1,len(paises)),
									r ])

def insertRings(conn):
	print("Cargando Rings...")
	IdRing = 0
	for r in tqdm(range(200)):
		IdRing += 1
		doInsert(conn, 'Ring', [IdRing])

def insertCompetidor(conn):
	print("Cargando Competidor...")
	amount = int(floor(len(dni)/3))
	for r in tqdm(range(amount)):
		nomNro = randint(1,len(nombres))
		age = randint(15,75)
		dt = datetime(2017-age,randint(1,12),randint(1,28)) # puede que la edad y el mes no den exacto (paja)
		nom = nombres['Nombre'][nomNro]
		lastnom = apellidos['Apellido'][randint(1,len(apellidos))]
		doInsert(conn, 'Alumno', [	dni[r],
									randint(1,len(escuelas)),
									nom,
									lastnom,
									randint(1,9),
									r,
									nom + "-" + lastnom + ".jpg"])
		doInsert(conn, 'Competidor', [	dni[r],
										dt,
										nombres['Sexo'][nomNro],
										age,
										0,
										"Null"])

myConnection = psycopg2.connect(host=hostname, user=username, password=password, dbname=database)
insertCompetidor(myConnection)
myConnection.close()