# -*- coding: utf-8 -*-
# Metaheuristic_Optimizer
# Copyright (C) 2016-2017 Jean-Baptiste LAMY
# LIMICS (Laboratoire d'informatique médicale et d'ingénierie des connaissances en santé), UMR_S 1142
# University Paris 13, Sorbonne paris-Cité, Bobigny, France

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import math, random

import metaheuristic_optimizer

def two_op(position, solution, cost0, cost_func):
  for i in range(len(solution) - 1):
    for j in range(i - 1):
      if i - j >= 2:
        new_solution      = list(solution)
        new_solution[i:j] = reversed(new_solution[i:j])
        new_cost          = cost_func(new_solution)
        
        if new_cost < cost0:
          new_position = list(position)
          new_position[i:j] = reversed(new_position[i:j])
          return new_position, new_solution, new_cost
        
  return None, None, cost0


def swap(position, solution, cost0, cost_func):
  for i in range(len(solution) - 1):
    solution_after_removal = list(solution)
    swaped = solution_after_removal.pop(i)
    for j in range(0, len(solution_after_removal)):
      new_solution = list(solution_after_removal)
      new_solution.insert(j, swaped)
      
      new_cost = cost_func(new_solution)
      
      if new_cost < cost0:
        new_position = list(position)
        
        del new_position[i]
        if   j == 0:                               k =  new_position[ 0] - (new_position[ 1] - new_position[ 0])
        elif j == len(solution_after_removal) - 1: k =  new_position[-1] + (new_position[-1] - new_position[-2])
        else:                                      k = (new_position[j - 1] + new_position[j]) / 2.0
        new_position.insert(j, k)
        
        return new_position, new_solution, new_cost
      
  return None, None, cost0

class Organism(object):
  def __init__(self, algo, position):
    self.position = position
    
    key_pairs = sorted(
      ((position[i], algo.elements[i]) for i in range(len(position))),
      key = lambda pair: pair[0],
      )
    self.solution    = [element for (key, element) in key_pairs]
    self.preimp_cost = self.cost = algo.cost_func(self.solution)
    
    if algo.local_improvement and algo.previous_organisms:
      limit = algo.previous_organisms[int(algo.parameter_p * algo.nb_organism)].preimp_cost
      
      if self.preimp_cost > limit: # level-I improvement:
        new_position, new_solution, new_cost = two_op(self.position, self.solution, self.cost, algo.cost_func)
        if new_cost < self.cost:
          self.position, self.solution, self.cost = new_position, new_solution, new_cost
          
        new_position, new_solution, new_cost = swap(self.position, self.solution, self.cost, algo.cost_func)
        if new_cost < self.cost:
          self.position, self.solution, self.cost = new_position, new_solution, new_cost
          
      else: #level-II improvement:
        while True:
          new_position, new_solution, new_cost = two_op(self.position, self.solution, self.cost, algo.cost_func)
          if new_cost < self.cost:
            self.position, self.solution, self.cost = new_position, new_solution, new_cost
          else:
            break
          
        while True:
          new_position, new_solution, new_cost = swap(self.position, self.solution, self.cost, algo.cost_func)
          if new_cost < self.cost:
            self.position, self.solution, self.cost = new_position, new_solution, new_cost
          else:
            break
          
    if (algo.best_cost is None) or (self.cost < algo.best_cost):
      algo.best_cost     = self.cost
      algo.best_solution = self.solution
      
      
class OrderingAlgorithm(metaheuristic_optimizer.Algorithm):
  def __init__(self, elements, cost_func, nb = 100, crossover_rate = 0.7, immigration_rate = 0.1, parameter_p = 0.05, local_improvement = False):
    self.tsp = cost_func
    
    self.elements          = elements
    self.nb_organism       = nb
    self.nb_crossover      = int(round(crossover_rate   * nb))
    self.nb_immigration    = int(round(immigration_rate * nb))
    self.nb_reproduction   = nb - self.nb_crossover - self.nb_immigration
    self.parameter_p       = parameter_p
    self.local_improvement = local_improvement
    
    metaheuristic_optimizer.Algorithm.__init__(self, cost_func)
    
  def reset(self):
    metaheuristic_optimizer.Algorithm.reset(self)
    self.best_solution = None
    self.best_cost     = None
    
    self.previous_organisms = None
    self.organisms = [self.random_organism() for i in range(self.nb_organism)]
    
  def iterate(self):
    self.organisms.sort(key = lambda organism: organism.cost)
    #new_organisms = self.organisms[:self.nb_reproduction]
    new_organisms = []
    i = 0
    while (len(new_organisms) < self.nb_reproduction) and i < len(self.organisms) - 1:
      for o in new_organisms:
        if o.solution == self.organisms[i].solution:
          i += 1
          break
      else:
        new_organisms.append(self.organisms[i])
        i += 1
        
    while len(new_organisms) < self.nb_reproduction:
      new_organisms.append(self.random_organism())
      
    #print(self.organisms[0].cost, self.organisms[1].cost)
    
    for i in range(self.nb_crossover):
      a = random.choice(self.organisms)
      b = random.choice(self.organisms)
      while a is b:
        b = random.choice(self.organisms)
      new_organisms.append(self.make_crossover(a, b))
      
    for i in range(self.nb_immigration):
      new_organisms.append(self.random_organism())

    self.previous_organisms = self.organisms
    self.organisms          = new_organisms
      
  def random_organism(self):
    return Organism(self, [random.random() for i in range(len(self.elements))])
    
  def make_crossover(self, a, b):
    l = []
    for i in range(len(a.position)):
      if random.random() < 0.7:
        l.append(a.position[i])
      else:
        l.append(b.position[i])
    return Organism(self, l)
  
  def get_best_position(self): return self.best_solution
  
  def get_lowest_cost(self):   return self.best_cost
