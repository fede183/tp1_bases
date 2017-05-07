#!/usr/bin/python
# -*- coding: utf-8 -*-
import psycopg2
import pandas as pd
from tqdm import tqdm
from numpy.random import randint, random
from math import floor
from datetime import datetime

hostname = 'localhost'
username = 'postgres'
password = 'basesdedatos'
database = 'dublin'

insertQueries = {
	'Ring' : """INSERT INTO "Ring" ("IdRing") VALUES (%s);""",
	'Pais' : """INSERT INTO "Pais" ("IdPais","Nombre") VALUES (%s,%s);""",
	'Competencia' : """INSERT INTO "Competencia" ("IdCompetencia","Sexo","TipoCompetencia") VALUES (%s, %s, %s);""",
	'Escuela' : """INSERT INTO "Escuela" ("IdEscuela", "Nombre", "IdPais") VALUES (%s, %s, %s);""",
	'Arbitro' : """INSERT INTO "Arbitro" ("NroPlacaArbitro", "Nombre", "Apellido", "Graduacion", "IdPais", "Tipo") VALUES (%s,%s ,%s ,%s ,%s ,%s );""",
	'Alumno' : """INSERT INTO "Alumno" ("DNI", "IdEscuela", "Nombre", "Apellido", "Graduacion", "NroCertificadoGraduacionITF", "Foto") VALUES (%s , %s, %s, %s, %s, %s, %s);""",
	'Coach' : """INSERT INTO "Coach" ("DNI") VALUES (%s);""",
	'Equipo' : """INSERT INTO "Equipo" ("IdEquipo", "NombreDeFantasia") VALUES (%s, %s);""",
	'Maestro' : """INSERT INTO "Maestro" ("NroDePlacaDeInstructor", "Nombre", "Apellido", "Graduacion", "IdPais", "IdEscuela") VALUES (%s, %s, %s, %s, %s, %s);""",
	'PresidenteDeMesa' : """INSERT INTO "PresidenteDeMesa" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'Juez' : """INSERT INTO "Juez" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'InscriptoEn' : """INSERT INTO "InscriptoEn" ("DNIAlumno", "DNICoach", "IdCompetencia") VALUES (%s, %s, %s);""",
	'EquipoInscriptoEn' : """INSERT INTO "EquipoInscriptoEn" ("IdEquipo", "IdCompetencia", "DNICoach") VALUES (%s, %s, %s);""",
	'Competidor' : """INSERT INTO "Competidor" ("DNI", "FechaDeNacimiento", "Sexo", "Edad", "Titular", "IdEquipo") VALUES (%s, %s, %s, %s, %s, %s);""",
	'CompetenciaSalto' : """INSERT INTO "CompetenciaSalto" ("IdCompetencia", "Edad") VALUES (%s, %s);""",
	'CompetenciaRotura' : """INSERT INTO "CompetenciaRotura" ("IdCompetencia") VALUES (%s);""",
	'CompetenciaIndividual' : """INSERT INTO "CompetenciaIndividual" ("IdCompetencia", "PrimerLugar", "SegundoLugar", "TercerLugar", "Graduacion", "Modalidad") VALUES (%s, %s, %s, %s, %s, %s);""",
	'CompetenciaFormas' : """INSERT INTO "CompetenciaFormas" ("IdCompetencia", "Edad") VALUES (%s, %s);""",
	'CompetenciaCombateIndividual' : """INSERT INTO "CompetenciaCombateIndividual" ("IdCompetencia", "Edad", "Peso") VALUES (%s, %s, %s);""",
	'CompetenciaCombateEquipos' : """INSERT INTO "CompetenciaCombateEquipos" ("IdCompetencia", "PrimerLugar", "SegundoLugar", "TercerLugar", "Edad") VALUES (%s, %s, %s, %s, %s);""",
	'ArbitroDeRecambio' : """INSERT INTO "ArbitroDeRecambio" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'ArbitroCentral' : """INSERT INTO "ArbitroCentral" ("NroPlacaArbitro", "IdRing") VALUES (%s, %s);""",
	'SeRealizaEn' : """INSERT INTO "SeRealizaEn" ("IdCompetencia", "IdRing") VALUES (%s, %s);""",
}

updates = {}
updates['CompetenciaIndividual'] = [
""" UPDATE "CompetenciaIndividual" SET "PrimerLugar" = %s WHERE "IdCompetencia" = %s; """,
""" UPDATE "CompetenciaIndividual" SET "SegundoLugar" = %s WHERE "IdCompetencia" = %s; """,
""" UPDATE "CompetenciaIndividual" SET "TercerLugar" = %s WHERE "IdCompetencia" = %s; """,
]
updates['CompetenciaCombateEquipos'] = [
""" UPDATE "CompetenciaCombateEquipos" SET "PrimerLugar" = %s WHERE "IdCompetencia" = %s; """,
""" UPDATE "CompetenciaCombateEquipos" SET "SegundoLugar" = %s WHERE "IdCompetencia" = %s; """,
""" UPDATE "CompetenciaCombateEquipos" SET "TercerLugar" = %s WHERE "IdCompetencia" = %s; """,
]

queries = {
	'available_teams': """	SELECT e."IdEquipo", e."NombreDeFantasia" 
								FROM "Equipo" e 
								WHERE NOT EXISTS (
									SELECT * 
									FROM "Competidor" c, "Alumno" a
									WHERE a."DNI" = c."DNI" 
									AND c."IdEquipo" = e."IdEquipo"
									AND a."IdEscuela" <> %s);""",
	'team_members': """ SELECT c
						FROM "Competidor" c, "Equipo" e
						WHERE e."IdEquipo" = %s
						AND c."IdEquipo" = e."IdEquipo";""",
	'school_students': """	SELECT c."DNI" 
							FROM "Competidor" c, "Alumno" a 
							WHERE c."DNI" = a."DNI"
							AND a."IdEscuela" = %s; """,
	'inscriptos': """ SELECT i."DNIAlumno" FROM "InscriptoEn" i WHERE i."IdCompetencia" = %s; """,
	'equiposInscriptos': """ SELECT i."IdEquipo" FROM "EquipoInscriptoEn" i WHERE i."IdCompetencia" = %s; """,
	'schools': """ SELECT e."IdEscuela", e."Nombre", e."IdPais" FROM "Escuela" e; """,
	'competidores': """SELECT c."DNI" FROM "Competidor" c;""",
	'equipos': """SELECT e."IdEquipo" FROM "Equipo" e;""",
	'CompetenciaCombateEquipos': """SELECT c."IdCompetencia" FROM "CompetenciaCombateEquipos" c;""",
	'CompetenciaIndividual': """ SELECT c."IdCompetencia" FROM "CompetenciaIndividual" c; """,
	'CompetenciaSalto': """SELECT c."IdCompetencia" FROM "CompetenciaSalto" c;""",
	'CompetenciaFormas': """SELECT c."IdCompetencia" FROM "CompetenciaFormas" c;""",
	'CompetenciaCombateIndividual': """SELECT c."IdCompetencia" FROM "CompetenciaCombateIndividual" c;""",
	'CompetenciaRotura': """SELECT c."IdCompetencia" FROM "CompetenciaRotura" c;""",
	'competidor_coaches': """	SELECT c."DNI" 
							FROM "Alumno" a1, "Alumno" a2, "Coach" c
							WHERE a2."DNI" = c."DNI"
							AND a1."DNI" = %s
							AND a1."DNI" <> a2."DNI"
							AND a1."IdEscuela" = a2."IdEscuela"; """,
	'equipo_coaches': """ 	SELECT c."DNI"
							FROM "Alumno" a, "Coach" c
							WHERE a."DNI" = c."DNI"
							AND a."IdEscuela" = (	SELECT a."IdEscuela"
													FROM "Competidor" c, "Alumno" a
													WHERE a."DNI" = c."DNI"
													AND c."IdEquipo" = %s
													LIMIT 1 )
							AND c."DNI" NOT IN (SELECT c."DNI"
												FROM "Competidor" c
												WHERE c."IdEquipo" = %s); """,
}

paises = pd.read_csv('csv/paises.csv', sep=',')
nombres = pd.read_csv('csv/nombres.csv', sep=',')
apellidos = pd.read_csv('csv/apellidos.csv', sep=',')
escuelas = pd.read_csv('csv/escuelas.csv', sep=',')
equipos = pd.read_csv('csv/equipos.csv', sep=',')
categorias = pd.read_csv('csv/categorias.csv', sep=',')

dni = []
while len(dni) < 1000:
	dni = list(set(dni+[randint(10000000,90000000) for i in range(1000-len(dni))]))
nroCerITF = []
while len(nroCerITF) < 1000:
	nroCerITF = list(set(nroCerITF+[randint(1,90000) for i in range(1000-len(nroCerITF))]))
nroPlaca = []
while len(nroPlaca) < 10000:
	nroPlaca = list(set(nroPlaca+[randint(1,90000) for i in range(10000-len(nroPlaca))]))

def bernoulli(p): return True if random() <= p else False

# Query functions

def doInsert(conn,table,values=[]):
    cur = conn.cursor()
    cur.execute(insertQueries[table],values)
    conn.commit()

def doUpdate(conn,query,values=[]):
    cur = conn.cursor()
    cur.execute(query,values)
    conn.commit()

def doQuery(conn, query, values=[]):
	#cur = conn.cursor()
	#cur.execute(query,values)
	#data = cur.fetchall()
	#res = pd.DataFrame([i for i in data])
	return pd.read_sql_query(query, conn, params=values)

# Loaders

def loadPaises(conn):
	print("Cargando Paises...")
	IdPais = 0
	for r in tqdm(range(len(paises))):
		IdPais += 1
		doInsert(conn, 'Pais', [IdPais, paises['Nombre'][r]])

def loadEscuelas(conn):
	print("Cargando Escuelas...")
	IdEscuela = 0
	for r in tqdm(range(len(escuelas))):
		IdEscuela += 1
		doInsert(conn, 'Escuela', [IdEscuela, escuelas['Nombre'][r], randint(1,len(paises))])

def loadMaestro(conn):
	print("Cargando Maestros...")
	NroDePlacaDeInstructor = 0
	for r in tqdm(range(len(escuelas))):
		NroDePlacaDeInstructor += 1
		doInsert(conn, 'Maestro', [	NroDePlacaDeInstructor,
									nombres['Nombre'][randint(1,len(nombres))],
									apellidos['Apellido'][randint(1,len(apellidos))],
									randint(1,9),
									randint(1,len(paises)),
									r+1 ])

def loadRings(conn):
	print("Cargando Rings...")
	IdRing = 0
	for r in tqdm(range(200)):
		IdRing += 1
		doInsert(conn, 'Ring', [IdRing])

def loadEquipos(conn):
	print("Cargando Equipos...")
	for r in tqdm(range(len(equipos))):
		doInsert(conn, 'Equipo', [r+1, equipos['Nombre'][r]])

# puede que la edad y el mes no den exacto (paja)
def generateAlumno():
	name_index = randint(len(nombres))
	dni_index = randint(len(dni))
	dni_student = dni[dni_index]
	dni.pop(dni_index)
	nsg_index = randint(len(nroCerITF))
	nsg_student = nroCerITF[nsg_index]
	nroCerITF.pop(nsg_index)
	age = randint(15,75)
	return {
		'dni': dni_student,
		'name': nombres['Nombre'][name_index],
		'last_name': apellidos['Apellido'][randint(len(apellidos))],
		'gender': nombres['Sexo'][name_index],
		'school': randint(1,len(escuelas)),
		'age': age,
		'graduation': randint(1,9),
		'NroCertificadoGraduacionITF': nsg_student,
		'birthdate': datetime(2017-age,randint(1,12),randint(1,28)),
	}

def insertAlumno(conn, alumno):
	doInsert(conn, 'Alumno', [	alumno['dni'],
								alumno['school'],
								alumno['name'],
								alumno['last_name'],
								alumno['graduation'],
								alumno['NroCertificadoGraduacionITF'],
								alumno['name'] + "-" + alumno['last_name'] + ".jpg"])

def insertCompetidor(conn, alumno, compite_en_equipo):
	titular = 0
	teamId = None
	if compite_en_equipo:
		available_teams = doQuery(conn, queries['available_teams'] ,[alumno['school']])
		if len(available_teams) > 0:
			teamId = available_teams['IdEquipo'][randint(len(available_teams))]
			team_members = doQuery(conn, queries['team_members'],[teamId])
			titular = 1 if len(team_members) < 5 else 0 # los primeros 5 son titulares
	doInsert(conn, 'Competidor', [	alumno['dni'],
									alumno['birthdate'],
									alumno['gender'],
									alumno['age'],
									titular,
									teamId])

def loadCompetidores(conn, amount, team_members_p):
	print("Cargando competidores...")
	for r in tqdm(range(amount)):
		alumno = generateAlumno()
		insertAlumno(conn, alumno)
		insertCompetidor(conn, alumno, bernoulli(team_members_p))

def loadCoaches(conn,overlap):
	print "Cargando Coaches..."
	schools = doQuery(conn,queries['schools'],[])
	for r in tqdm(range(len(schools))):
		idEscuela = schools['IdEscuela'][r]
		school_students = doQuery(conn,queries['school_students'],[idEscuela])
		school_coach_amount = floor(len(school_students) / 5)
		overlap_amount = int(floor(school_coach_amount * overlap))
		no_overlap_amount = int(school_coach_amount) - overlap_amount
		for c in tqdm(range(no_overlap_amount)):
			alumno = generateAlumno()
			insertAlumno(conn, alumno)
			doInsert(conn, 'Coach', [alumno['dni']])
		for c in tqdm(range(overlap_amount)):
			alumno_index = randint(len(school_students))
			doInsert(conn, 'Coach', [school_students['DNI'][alumno_index]])
			school_students.drop(alumno_index)

# 0 comp individual 
# 1 comp equipo
# comp individual:
# 0 salto
# 1 forma
# 2 combate individual
# 3 rotura

def loadCompetencias(conn):
	print "Cargango competencias..."
	categorias_sexo = categorias[categorias['Discriminante'] == 'Sexo'].reset_index()
	categorias_graduacion = categorias[categorias['Discriminante'] == 'Graduacion'].reset_index()
	categorias_edad = categorias[categorias['Discriminante'] == 'Edad'].reset_index()
	categorias_peso = categorias[categorias['Discriminante'] == 'Peso'].reset_index()
	IdCompetencia = 0

	print "Competencias por equipos"
	for r1 in tqdm(range(len(categorias_sexo))):
		sexo = categorias_sexo['Valor'][r1]
		for r3 in tqdm(range(len(categorias_edad))):
			edad = categorias_edad['Valor'][r3]
			# combate equipo
			IdCompetencia += 1
			doInsert(conn, 'Competencia', [IdCompetencia, sexo, 1])
			doInsert(conn, 'CompetenciaCombateEquipos', [IdCompetencia, None, None, None, edad])
	
	print "Competencias individuales"
	for r1 in tqdm(range(len(categorias_sexo))):
		sexo = categorias_sexo['Valor'][r1]
		for r2 in tqdm(range(len(categorias_graduacion))):
			graduacion = categorias_graduacion['Valor'][r2]
			# Rotura
			IdCompetencia += 1
			doInsert(conn, 'Competencia', [IdCompetencia, sexo, 0])
			doInsert(conn, 'CompetenciaIndividual', [IdCompetencia, None, None, None, graduacion, 3])
			doInsert(conn, 'CompetenciaRotura', [IdCompetencia])
			for r3 in tqdm(range(len(categorias_edad))):
				edad = categorias_edad['Valor'][r3]
				# Salto
				IdCompetencia += 1
				doInsert(conn, 'Competencia', [IdCompetencia, sexo, 0])
				doInsert(conn, 'CompetenciaIndividual', [IdCompetencia, None, None, None, graduacion, 0])
				doInsert(conn, 'CompetenciaSalto', [IdCompetencia, edad])
				# Forma
				IdCompetencia += 1
				doInsert(conn, 'Competencia', [IdCompetencia, sexo, 0])
				doInsert(conn, 'CompetenciaIndividual', [IdCompetencia, None, None, None, graduacion, 1])
				doInsert(conn, 'CompetenciaFormas', [IdCompetencia, edad])
				for r4 in tqdm(range(len(categorias_peso))):
					peso = categorias_peso['Valor'][r4]
					# Combate individual
					IdCompetencia += 1
					doInsert(conn, 'Competencia', [IdCompetencia, sexo, 0])
					doInsert(conn, 'CompetenciaIndividual', [IdCompetencia, None, None, None, graduacion, 2])
					doInsert(conn, 'CompetenciaCombateIndividual', [IdCompetencia, edad, peso])

def generate_arbitro(graduation):
	np_index = randint(len(nroPlaca))
	nroPlaca_arbitro = nroPlaca[np_index]
	nroPlaca.pop(np_index)
	return {
		'NroPlacaArbitro': nroPlaca_arbitro,
		'name': nombres['Nombre'][randint(len(nombres))],
		'last_name': apellidos['Apellido'][randint(len(apellidos))],
		'graduation': graduation,
		'country': randint(1,len(paises))
	}

def insertArbitro(conn, arbitro, tipo):
	doInsert(conn, 'Arbitro', [ arbitro['NroPlacaArbitro'],
								arbitro['name'],
								arbitro['last_name'],
								arbitro['graduation'],
								arbitro['country'],
								tipo])

# 0 = presidente de mesa
# 1 = juez
# 2 = arbitro central
# 3 = arbitro de recambio
def loadArbitros(conn):
	print "Cargando Árbitros..."
	rings = doQuery(conn, """SELECT * FROM "Ring"; """,[])

	for r1 in tqdm(range(len(rings))):
		graduation = randint(1,9)

		# Presidente de mesa
		arbitro = generate_arbitro(graduation)
		insertArbitro(conn,arbitro,0)
		doInsert(conn, 'PresidenteDeMesa', [arbitro['NroPlacaArbitro'], rings['IdRing'][r1]])

		# Arbitro central
		arbitro = generate_arbitro(graduation)
		insertArbitro(conn,arbitro,2)
		doInsert(conn, 'ArbitroCentral', [arbitro['NroPlacaArbitro'], rings['IdRing'][r1]])

		# Jueces
		jueces = randint(1,10)
		for r2 in tqdm(range(jueces)):
			arbitro = generate_arbitro(graduation)
			insertArbitro(conn,arbitro,1)
			doInsert(conn, 'Juez', [arbitro['NroPlacaArbitro'], rings['IdRing'][r1]])

		# Arbitros de recambio
		arbitros_recambio = randint(1,10)
		for r2 in tqdm(range(arbitros_recambio)):
			arbitro = generate_arbitro(graduation)
			insertArbitro(conn,arbitro,3)
			doInsert(conn, 'ArbitroDeRecambio', [arbitro['NroPlacaArbitro'], rings['IdRing'][r1]])

def loadInscriptosEn(conn):
	print "Cargando inscripciones competencia salto..."
	inserInscriptosEn(conn, 'CompetenciaSalto')
	print "Cargando inscripciones competencia formas..."
	inserInscriptosEn(conn, 'CompetenciaFormas')
	print "Cargando inscripciones competencia combate individual..."
	inserInscriptosEn(conn, 'CompetenciaCombateIndividual')
	print "Cargando inscripciones competencia rotura..."
	inserInscriptosEn(conn, 'CompetenciaRotura')

def loadEquipoInscriptoEn(conn):
	print "Cargando inscripciones combate por equipo"
	equipos = doQuery(conn, queries['equipos'])
	categorias = doQuery(conn, queries['CompetenciaCombateEquipos'])

	for e in tqdm(range(len(equipos))):
		equipo = equipos['IdEquipo'][e]
		for c in tqdm(range(len(categorias))):
			categoria = categorias['IdCompetencia'][c]
			coaches = doQuery(conn, queries['equipo_coaches'], [equipo,equipo])
			if len(coaches) > 0:
				coach = coaches['DNI'][randint(len(coaches))]
				doInsert(conn, 'EquipoInscriptoEn', [equipo, categoria, coach]);

def inserInscriptosEn(conn, competencia):
	competidores = doQuery(conn, queries['competidores'])
	categorias = doQuery(conn, queries[competencia])

	for c1 in tqdm(range(len(competidores))): 
		competidor = competidores['DNI'][c1]
		for c2 in tqdm(range(len(categorias))):
			categoria = categorias['IdCompetencia'][c2]
			coaches = doQuery(conn, queries['competidor_coaches'], [competidor])
			if len(coaches) > 0:
				coach = coaches['DNI'][randint(len(coaches))]
				doInsert(conn, 'InscriptoEn', [competidor, coach, categoria]);

def loadPositions(conn):
	print "Cargando 1ra 2da y 3ra posion de cada competencia individual"

	competencias = doQuery(conn, queries['CompetenciaIndividual'])
	for c in tqdm(range(len(competencias))):
		competencia = competencias['IdCompetencia'][c]
		inscriptos = doQuery(conn, queries['inscriptos'], [competencia])
		ganadores = []
		while len(inscriptos) > 0 and len(ganadores) < 3:
			nro = randint(len(inscriptos))
			ganadores.append(inscriptos['DNIAlumno'][nro])
			inscriptos.drop(nro)
		for i in tqdm(range(len(ganadores))):
			doUpdate(conn, updates['CompetenciaIndividual'][i], [ganadores[i],competencia])

	competencias = doQuery(conn, queries['CompetenciaCombateEquipos'])
	for c in tqdm(range(len(competencias))):
		competencia = competencias['IdCompetencia'][c]
		inscriptos = doQuery(conn, queries['equiposInscriptos'], [competencia])
		ganadores = []
		while len(inscriptos) > 0 and len(ganadores) < 3:
			nro = randint(len(inscriptos))
			ganadores.append(inscriptos['IdEquipo'][nro])
			inscriptos.drop(nro)
		for i in tqdm(range(len(ganadores))):
			doUpdate(conn, updates['CompetenciaCombateEquipos'][i], [ganadores[i],competencia])

myConnection = psycopg2.connect(host=hostname, user=username, password=password, dbname=database)
loadPaises(myConnection)
loadEscuelas(myConnection)
loadMaestro(myConnection)
loadRings(myConnection)
loadEquipos(myConnection)
loadCompetidores(myConnection, 400, 0.3)
loadCoaches(myConnection, 0.5)
loadCompetencias(myConnection)
loadArbitros(myConnection)
loadInscriptosEn(myConnection)
loadEquipoInscriptoEn(myConnection)
loadPositions(myConnection)
myConnection.close()