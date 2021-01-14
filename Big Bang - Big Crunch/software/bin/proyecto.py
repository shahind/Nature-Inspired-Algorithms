# -*- coding: utf-8 -*-
"""
Created on Sat Jun 27 06:26:28 2020

@author: Alba
"""


# enconding: utf-8

import numpy as np
import random
import math
import time
from os import listdir



NUM_MAX_EVALUACIONES = 100000
semillas = np.array([1, 3, 2, 7, 5])



class StellarObject():
    def __init__(self,n,d):
        self.valores_asignados = np.zeros(n)
        self.centroides = np.zeros((k,d))
        self.vf_objetivo = 0.0

    def __lt__(self, stellarObject):
        return self.vf_objetivo < stellarObject.vf_objetivo


# Funcion que carga lo datos. Tanto el set de valores como la matriz de restricciones
# Se devuelve 4 parametros, la matriz de datos, la matriz de restricciones, y el numero de filas
# y columnas de nuestra matriz de datos

def cargar_datos(f_datos, f_restricciones):
    # Read data separated by commmas in a text file
    # with open("text.txt", "r") as filestream:

    #f = open(f_datos, "r")
    #f1 = open(f_restricciones, "r")
     
    
    string1 = "datos/" + f_datos 
    string2 = "restricciones/" + f_restricciones

    f = open(string1, "r")
    f1 = open(string2, "r")
    
   
   
    # MATRIZ DATOS 

    currentline_datos = []
    matrix_datos = []


    # print(line)
    # We need to change the input text into something we can work with (such an array)
    # currentline contains all the integers listed in the first line of "text.txt"
    # string.split(separator, maxsplit)
    # https://stackoverflow.com/questions/4319236/remove-the-newline-character-in-a-list-read-from-a-file

    for line in f: 
    #for line in f: 
        
        currentline_datos = line.rstrip('\n').split(",")

        matrix_datos.append(currentline_datos)

    
    # n == filas y d == columnas
    n = len(matrix_datos)
    d = len(currentline_datos)

    # MATRIZ RESTRICCIONES

    for i in range (n):
        for j in range (d):
            matrix_datos[i][j] = float(matrix_datos[i][j])


    currentline_const = []
    matrix_const = []

    for line in f1:
        # https://stackoverflow.com/questions/4319236/remove-the-newline-character-in-a-list-read-from-a-file
        currentline_const = line.rstrip("\n").split(",")

        matrix_const.append(currentline_const)

    v_restricciones = []
    for i in range(len(matrix_const)):
        for j in range(i+1,len(matrix_const[0])):
            if matrix_const[i][j] == '-1':
                v_restricciones.append([i,j,-1])
            elif matrix_const[i][j] == '1':
                v_restricciones.append([i,j,1])

    return matrix_datos, v_restricciones, n, d



################################################################################
#                           FUNCIONES DE REPARACION
################################################################################

# Funcion para comprobar que ningun cluster queda vacio

def cluster_vacio(v_solucion, cluster):
    for i in range(len(v_solucion)):
        if v_solucion[i] == cluster:
            return 1

    return 0


def reparacion(solucion, num_cluster,n_genes):
    posicion = random.randint(0,(n_genes-1))

    solucion[posicion] = num_cluster

def reparar(solucion,n):
  esta_vacio = True

  while esta_vacio:
    esta_vacio = False
    for i in range(k):
      if cluster_vacio(solucion, i+1) == 0:
        reparacion(solucion,i+1,n)
        esta_vacio = True



################################################################################
#                                 FUNCIONES
################################################################################

# Funcion que calcula la infeasibility.
# Si en la matriz de restricciones marca un 1 y dos instancias NO estan en el mismo cluster
# o si en la matriz de restricciones hay un -1 y estan en el mismo, sumamos +1 el valor de la
# infeasibility ya que sera una RESTRICCION INCUMPLIDA


def calcular_infeasibility(datos, valores_asignados, restricciones):
    infeasability = 0

    for i in range(len(restricciones)):
        if restricciones[i][2] == -1 and valores_asignados[restricciones[i][0]] == valores_asignados[restricciones[i][1]]:
            infeasability = infeasability + 1
        elif restricciones[i][2] == 1 and valores_asignados[restricciones[i][0]] != valores_asignados[restricciones[i][1]]:
            infeasability = infeasability + 1

    return infeasability
 


# Funcion que recalcula los centroides

def recalcular_centroides(datos, vector_asignados, centroides, d):

    for i in range(k):
        nuevo_centroide = np.zeros(d)
        num_total = 0

        for j in range (n):
            #Si este punto pertenece a este cluster
            if vector_asignados[j] == i + 1:
                for l in range (d):
                    nuevo_centroide[l] = nuevo_centroide[l] + datos[j][l]

            
                num_total = num_total + 1

        for j in range(d):
            if num_total != 0:
                nuevo_centroide[j] = nuevo_centroide[j]/num_total

        centroides[i] = nuevo_centroide




# Funcion que calcula cual es la distancia maxima de entre todas las instancias

def calcular_dmaxima(datos, n):
    maximo = float("-inf")
    dist = 0

    for i in range(n):
        for j in range(i+1, n):
            for c in range(d):
                dist = dist + math.pow((datos[i][c] - datos[j][c]),2)

            distancia = math.sqrt(dist)
            dist = 0

            if(distancia > maximo):
                maximo = distancia

    return maximo



# Funcion que calcula el numero de restricciones de la matriz de restricciones

def calcular_nrestricciones(restricciones, n):

    num_restricciones = len(restricciones)

    return num_restricciones



# Funcion que calcula el valor de lambda de la funcion objetivo 

def calcular_lambda(datos, restricciones, n):
    distancima_maxima = calcular_dmaxima(datos,n)

    num_restricciones = calcular_nrestricciones(restricciones, n)

    lamda = (int(distancima_maxima))/ num_restricciones

    return lamda


# Funcion que calcula la distancia

def distancia_media(datos, pos, centroides, vector_asignados):
    dist = 0
    elementos = 0
   
    for j in range (len(datos)):
        if vector_asignados[j] == pos + 1:
            dist = dist + np.linalg.norm(datos[j] - centroides[pos])
            elementos = elementos + 1
    dist = dist/elementos
    return dist



def desviacion(datos, centroides, d, valores_asignados):
    desv = 0
    cont = 0

    for i in range(k):

        if (cluster_vacio(valores_asignados, i + 1 ) != 0):
            desv = desv + distancia_media(datos, i, centroides, valores_asignados)
            cont = cont + 1

    desviacion_general = desv / cont

    return desviacion_general



# FUNCION OBJETIVO DE LA BUSQUEDA LOCAL    

def f_objetivo(datos, valores_asignados, restricciones, n, d, centroides, valor_lambda):
    return desviacion(datos, centroides, d, valores_asignados) + (calcular_infeasibility(datos, valores_asignados, restricciones) * valor_lambda)



################################################################################
#                      FUNCIONES BIG BANG BIG CRUNCH
################################################################################


def generar_poblacion(long_poblacion,k,n,d, elite_pool):
    solucion = []

    if (len(elite_pool) == 0):
      for i in range(long_poblacion):
          cromo = StellarObject(n,d)
          solucion.append(cromo)
          solucion[i].valores_asignados = np.copy(solucion[i].valores_asignados)

          for j in range(n):
              solucion[i].valores_asignados[j] = random.randint(1,k)     

      for i in range(long_poblacion):
        reparar(solucion[i].valores_asignados,n) 

    else:

      for i in range(len(elite_pool)):
        cromo = StellarObject(n,d)
        solucion.append(cromo)
        solucion[i].valores_asignados = np.copy(elite_pool[i].valores_asignados)

      for i in range(len(elite_pool)):
        for j in range(4):
          vecino = StellarObject(n,d)
          vecino.valores_asignados = np.copy(elite_pool[i].valores_asignados)
          posicion = random.randint(0,(n-1))

          valor = elite_pool[i].valores_asignados[posicion]
          nuevo_valor = random.randint(1,k)

          while nuevo_valor == valor:
            nuevo_valor = random.randint(1,k)

          vecino.valores_asignados[posicion] = nuevo_valor
          reparar(vecino.valores_asignados, n)
          solucion.append(vecino)


    return solucion


def evaluar_poblacion(poblacion, long_poblacion, datos, restricciones, n, d, valor_lambda, num_evaluaciones):
    for i in range(long_poblacion):
        recalcular_centroides(datos, poblacion[i].valores_asignados, poblacion[i].centroides, d)

        poblacion[i].vf_objetivo = f_objetivo(datos, poblacion[i].valores_asignados, restricciones, n, d, poblacion[i].centroides, valor_lambda)
        num_evaluaciones = num_evaluaciones + 1
    
    return num_evaluaciones



def scaleBetween(unscaledNum, minAllowed, maxAllowed, min, max):
  #return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
  return ((unscaledNum - min) * (minAllowed - maxAllowed)) / (max - min) + minAllowed


def calcula_sigma(c_max, c_min, alpha, num_eval_max, long_poblacion):
  r = random.random()
  sigma = (r*alpha*(c_max - c_min)) / num_eval_max

  valor_sigma = scaleBetween(sigma, 1 , long_poblacion, 0.0000009 , 0.000009 )
  valor_sigma = (valor_sigma%long_poblacion)
  valor_sigma = int(valor_sigma)

  return valor_sigma



################################################################################
#                           BUSQUEDA LOCAL
################################################################################

def LocalSearch(datos, restricciones, n, d, v_solucion, centroides, valor_lambda,num_evaluaciones):
  hay_cambio = 1
  num_eval = 0

  vecinos = []

  v_centroides = []
  for i in range(n*(k-1)):
      v_centroides.append(np.zeros((k,d)))
      

  #Vectores usados para realizar las graficas
  #valores_fobj = []
  #num_iterw = []

  coste_sol = f_objetivo(datos, v_solucion, restricciones, n, d, centroides, valor_lambda)

  while(hay_cambio == 1) and (num_eval < 100):
    hay_cambio = 1
    #print("llevo ", num_evaluaciones , " evaluaciones")
    vecinos = []
    for i in range(n):
        for j in range(k):
        
            if (float(j + 1)) != v_solucion[i]:

                vecinos.append(v_solucion.copy()) 
                valor_anterior = vecinos[-1][i]                 
                vecinos[-1][i] = j + 1

                if (cluster_vacio(vecinos[-1], valor_anterior ) == 0):
                    vecinos.pop()

    np.random.shuffle(vecinos)

    for v in range(len(vecinos)):
        recalcular_centroides(datos, vecinos[v], v_centroides[v], d)

        sol1 = f_objetivo(datos, vecinos[v], restricciones, n, d, v_centroides[v], valor_lambda)
        num_evaluaciones = num_evaluaciones + 1
        num_eval = num_eval + 1

        #sol2 = f_objetivo(datos, v_solucion, restricciones, n, d, centroides, valor_lambda)

        if sol1 < coste_sol :
          v_solucion = vecinos[v]
          centroides = v_centroides[v]
          coste_sol = sol1
          #valores_fobj.append(sol1)
          #num_iterw.append(contador)
          
          hay_cambio = 0
          break

        

  return v_solucion, coste_sol, centroides, num_evaluaciones



################################################################################
#                          METAHEURÍSTICA
################################################################################

def BBBC(datos, restricciones, n, d, long_poblacion):
  num_evaluaciones = 0
  num_vecinos = 5
  num_poor_sols = 10
  elite_pool = []
  tam_elite_pool = 10
  sigue = True

  valor_lambda = calcular_lambda(datos, restricciones, n)

  # Generamos y evaluamos los individuos de la población inicial
  poblacion_inicial = generar_poblacion(long_poblacion, k, n, d, elite_pool)
  num_evaluaciones = evaluar_poblacion(poblacion_inicial, long_poblacion, datos, restricciones, n, d, valor_lambda, num_evaluaciones)

  poblacion = sorted(poblacion_inicial, key=lambda poblacion:poblacion.vf_objetivo)
  
  centre_mass = np.copy(poblacion[0].valores_asignados)

  # Rellenamos la elite pool
  for i in range(tam_elite_pool):
    elite_pool.append(poblacion[i])

  c_max = elite_pool[-1].vf_objetivo
  c_min = elite_pool[0].vf_objetivo


  while(num_evaluaciones < NUM_MAX_EVALUACIONES):
    while sigue == True:
      #nueva_poblacion = np.copy(poblacion)
      nueva_poblacion = []

      # Cada inidividuo de la población generará "num_vecinos" vecinos
      for i in range(long_poblacion):
        mejor_hijo = StellarObject(n,d)
        mejor_hijo.vf_objetivo = float("inf")

        for j in range(num_vecinos):
          num_elem = 0
          inicio_seg = random.randint(0,(n-1))
          posicion = inicio_seg

          sigma = calcula_sigma(c_max, c_min, 0.8, NUM_MAX_EVALUACIONES, long_poblacion)

          hijo = StellarObject(n,d)
          hijo.valores_asignados = np.copy(centre_mass)

          while num_elem < sigma:
            hijo.valores_asignados[posicion] = poblacion[i].valores_asignados[posicion]
            posicion = (posicion + 1)%n
            num_elem = num_elem + 1

          recalcular_centroides(datos, hijo.valores_asignados, hijo.centroides, d)
          hijo.vf_objetivo = f_objetivo(datos, hijo.valores_asignados, restricciones, n, d, hijo.centroides, valor_lambda)
          num_evaluaciones = num_evaluaciones + 1

          if hijo.vf_objetivo < mejor_hijo.vf_objetivo:
            mejor_hijo.vf_objetivo = hijo.vf_objetivo
            mejor_hijo.valores_asignados = np.copy(hijo.valores_asignados)
            mejor_hijo.centroides = np.copy(hijo.centroides)
          

        nueva_poblacion.append(mejor_hijo)

      for i in range(long_poblacion):
        reparar(nueva_poblacion[i].valores_asignados,n)

      # Find the centre of mass
      nueva_poblacion = sorted(nueva_poblacion, key=lambda nueva_poblacion:nueva_poblacion.vf_objetivo)
      centre_mass = np.copy(nueva_poblacion[0].valores_asignados)

      # Update elite pool
      elite_pool[-1].valores_asignados = nueva_poblacion[0].valores_asignados
      elite_pool[-1].vf_objetivo = nueva_poblacion[0].vf_objetivo
      elite_pool[-1].centroides = nueva_poblacion[0].centroides
      elite_pool = sorted(elite_pool, key=lambda elite_pool:elite_pool.vf_objetivo)
    

      c_max = elite_pool[-1].vf_objetivo
      c_min = elite_pool[0].vf_objetivo
      #print("C max ", c_max , " c min ", c_min)

      if long_poblacion == num_poor_sols:
        nueva_poblacion = nueva_poblacion[:len(nueva_poblacion) - (num_poor_sols -1)]
        
      else:
        nueva_poblacion = nueva_poblacion[:len(nueva_poblacion) - num_poor_sols]
      
      long_poblacion = len(nueva_poblacion)
      

      if long_poblacion == 1:
        sigue = False

    


    if num_evaluaciones < NUM_MAX_EVALUACIONES:
      long_poblacion = 50
      poblacion = generar_poblacion(long_poblacion, k, n, d, elite_pool)
      num_evaluaciones = evaluar_poblacion(poblacion, long_poblacion, datos, restricciones, n, d, valor_lambda, num_evaluaciones)
      poblacion = sorted(poblacion, key=lambda poblacion:poblacion.vf_objetivo)
      sigue = True


  desviacion_general = desviacion(datos,elite_pool[0].centroides, d, elite_pool[0].valores_asignados)
  print("La desviacion general es: ", desviacion_general)
  valor_inf = calcular_infeasibility(datos,elite_pool[0].valores_asignados , restricciones)
  print("valor de infeasibility ", valor_inf)
  valor_fobjetivo = f_objetivo(datos, elite_pool[0].valores_asignados, restricciones, n, d, elite_pool[0].centroides, valor_lambda)
  print("valor f_obj: ", valor_fobjetivo)




def BBBC_Memetic(datos, restricciones, n, d, long_poblacion):
  num_evaluaciones = 0
  num_vecinos = 5
  num_poor_sols = 10
  elite_pool = []
  tam_elite_pool = 10
  sigue = True

  valor_lambda = calcular_lambda(datos, restricciones, n)

  # Generamos y evaluamos los individuos de la población inicial
  poblacion_inicial = generar_poblacion(long_poblacion, k, n, d, elite_pool)
  num_evaluaciones = evaluar_poblacion(poblacion_inicial, long_poblacion, datos, restricciones, n, d, valor_lambda, num_evaluaciones)


  poblacion = sorted(poblacion_inicial, key=lambda poblacion:poblacion.vf_objetivo)
  
  centre_mass = np.copy(poblacion[0].valores_asignados)

  # Rellenamos la elite pool
  for i in range(tam_elite_pool):
    elite_pool.append(poblacion[i])

  c_max = elite_pool[-1].vf_objetivo
  c_min = elite_pool[0].vf_objetivo



  while(num_evaluaciones < NUM_MAX_EVALUACIONES):
    while sigue == True:
      nueva_poblacion = []

      # Cada inidividuo de la población generará "num_vecinos" vecinos
      for i in range(long_poblacion):
        mejor_hijo = StellarObject(n,d)
        mejor_hijo.vf_objetivo = float("inf")

        for j in range(num_vecinos):
          num_elem = 0
          inicio_seg = random.randint(0,(n-1))
          posicion = inicio_seg

          sigma = calcula_sigma(c_max, c_min, 0.8, NUM_MAX_EVALUACIONES, long_poblacion)

          hijo = StellarObject(n,d)
          hijo.valores_asignados = np.copy(centre_mass)

          while num_elem < sigma:
            hijo.valores_asignados[posicion] = poblacion[i].valores_asignados[posicion]
            posicion = (posicion + 1)%n
            num_elem = num_elem + 1

          recalcular_centroides(datos, hijo.valores_asignados, hijo.centroides, d)
          hijo.vf_objetivo = f_objetivo(datos, hijo.valores_asignados, restricciones, n, d, hijo.centroides, valor_lambda)
          num_evaluaciones = num_evaluaciones + 1

          if hijo.vf_objetivo < mejor_hijo.vf_objetivo:
            mejor_hijo.vf_objetivo = hijo.vf_objetivo
            mejor_hijo.valores_asignados = np.copy(hijo.valores_asignados)
            mejor_hijo.centroides = np.copy(hijo.centroides)
          

        nueva_poblacion.append(mejor_hijo)

      for i in range(long_poblacion):
        reparar(nueva_poblacion[i].valores_asignados,n)

      # Find the centre of mass
      nueva_poblacion = sorted(nueva_poblacion, key=lambda nueva_poblacion:nueva_poblacion.vf_objetivo)
      centre_mass = np.copy(nueva_poblacion[0].valores_asignados)
      valor_cm = np.copy(nueva_poblacion[0].vf_objetivo)
      centroid_cm = np.copy(nueva_poblacion[0].centroides)

      centre_mass, valor_cm, centroid_cm, num_evaluaciones = LocalSearch(datos, restricciones, n, d, centre_mass, centroid_cm, valor_lambda, num_evaluaciones)


      # Update elite pool
      elite_pool[-1].valores_asignados = np.copy(centre_mass)
      elite_pool[-1].vf_objetivo = np.copy(valor_cm)
      elite_pool[-1].centroides = np.copy(centroid_cm)
      elite_pool = sorted(elite_pool, key=lambda elite_pool:elite_pool.vf_objetivo)
    

      c_max = elite_pool[-1].vf_objetivo
      c_min = elite_pool[0].vf_objetivo


      if long_poblacion == num_poor_sols:
        nueva_poblacion = nueva_poblacion[:len(nueva_poblacion) - (num_poor_sols -1)]
        
      else:
        nueva_poblacion = nueva_poblacion[:len(nueva_poblacion) - num_poor_sols]
      
      long_poblacion = len(nueva_poblacion)
      

      if long_poblacion == 1:
        sigue = False

    

    if num_evaluaciones < NUM_MAX_EVALUACIONES:
      long_poblacion = 50
      poblacion = generar_poblacion(long_poblacion, k, n, d, elite_pool)
      num_evaluaciones = evaluar_poblacion(poblacion, long_poblacion, datos, restricciones, n, d, valor_lambda, num_evaluaciones)
      poblacion = sorted(poblacion, key=lambda poblacion:poblacion.vf_objetivo)
      sigue = True



  desviacion_general = desviacion(datos,elite_pool[0].centroides, d, elite_pool[0].valores_asignados)
  print("La desviacion general es: ", desviacion_general)
  valor_inf = calcular_infeasibility(datos,elite_pool[0].valores_asignados , restricciones)
  print("valor de infeasibility ", valor_inf)
  valor_fobjetivo = f_objetivo(datos, elite_pool[0].valores_asignados, restricciones, n, d, elite_pool[0].centroides, valor_lambda)
  print("valor f_obj: ", valor_fobjetivo)





######################################################################
#                         MAIN DEL PROGRAMA
######################################################################
  
print("ELECCION DEL CONJUNTO DE DATOS")
print(" Introduzca: 1 -- CONJUNTO IRIS , 2 -- CONJUNTO ECOLI, 3 -- CONJUNTO RAND, 4 -- CONJUNTO NEWTHYROID")
numero = input("Introduce un numero:")

if numero == "1":
    f = "iris_set.dat"
elif numero == "2":
    f = "ecoli_set.dat"
elif numero == "3":
    f = "rand_set.dat"
elif numero == "4":
    f = "newthyroid_set.dat"
else:
    print("ERROR - Opción no valida")

txt_datos = f.split("_")

if txt_datos[0] == 'iris' or txt_datos[0] == 'rand' or txt_datos[0] == 'newthyroid':
    k = 3
elif txt_datos[0] == 'ecoli':
    k = 8


long_poblacion = 50



for f2 in listdir("restricciones"):
    txt_restricciones = f2.split("_")

    if txt_datos[0] == txt_restricciones[0]:   

        for i in range(5):
          random.seed(semillas[i])
          print("----------------------------------")
          print("----------------------------------")
          print("           SEMILLA " , semillas[i] )
          print("----------------------------------")
          print("----------------------------------")
        
          datos, restricciones, n, d = cargar_datos(f, f2)
          
          print("BB-BC MEMETIC")
          ini = time.time()
          BBBC_Memetic(datos, restricciones, n, d, long_poblacion)
          fin = time.time() - ini
          print("Tiempo ES: ", fin)
        
          print()
          print()
          
          print("BBC: ")
          ini = time.time()
          BBBC(datos, restricciones, n, d, long_poblacion)
          fin = time.time() - ini
          print("Tiempo ES: ", fin)