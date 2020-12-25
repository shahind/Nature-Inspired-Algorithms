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

def bounded(x, minimum, maximum):
  if x < minimum: return minimum
  if x > maximum: return maximum
  return x

class OrderingAlgorithm(metaheuristic_optimizer.Algorithm):
  def __init__(self, elements, cost_func, nb_ant = 8, evaporation_rate = 0.01, pheromon_default = 0.1, pheromon_min = 0.1, pheromon_max = 10.0):
    self.tsp = cost_func
    
    self.elements         = elements
    self.nb_ant           = nb_ant
    self.evaporation_rate = evaporation_rate
    self.pheromon_default = pheromon_default
    self.pheromon_min     = pheromon_min
    self.pheromon_max     = pheromon_max
    
    self.elements_set = set(elements)
    metaheuristic_optimizer.Algorithm.__init__(self, cost_func)
    
  def reset(self):
    metaheuristic_optimizer.Algorithm.reset(self)
    #self.pheromons = defaultdict(lambda : 1.0)
    self.pheromons = {
      (a, b) : self.pheromon_default
      for a in (self.elements + [None])
      for b in  self.elements
      if not a is b
    }
    self.best_solution = None
    self.best_cost     = None
    
  def iterate(self): 
    solutions = []
    iteration_best_solution = None
    iteration_best_cost     = None
    
    for i in range(self.nb_ant):
      solution = self.construct_solution()
      cost     = self.cost_func(solution)
      
      if (iteration_best_cost is None) or (cost < iteration_best_cost):
        iteration_best_cost     = cost
        iteration_best_solution = solution
        if (self.best_cost is None) or (cost < self.best_cost):
          self.best_cost     = cost
          self.best_solution = solution
      solutions.append((solution, cost))
    self.update_pheromons(iteration_best_solution, iteration_best_cost)
    #self.update_pheromons(self.best_solution, self.best_cost)
    
  def construct_solution(self):
    current  = None
    solution = []
    visited  = set()
    
    for i in range(len(self.elements)):
      total = 0.0
      candidates = self.elements_set - visited
      for candidate in candidates:
        #total += self.pheromons[current, candidate]
        if current:
          total += self.pheromons[current, candidate]# + 1.0 / self.tsp.distances[current, candidate]
        else:
          total += self.pheromons[current, candidate]
          
      r = random.uniform(0.0, total)
      for candidate in candidates:
        if current:
          r += -(self.pheromons[current, candidate])# + 1.0 / self.tsp.distances[current, candidate])
        else:
          r -= self.pheromons[current, candidate]
        if r <= 0.0:
          solution.append(candidate)
          visited .add   (candidate)
          current = candidate
          break
      else:
        assert False
      
    return solution
  
  def update_pheromons(self, solution, cost):
    solution_steps = {
      (solution[i], solution[i + 1])
      for i in range(len(solution) - 1)
      }
    solution_steps.add((None, solution[0]))
    
    for a in self.elements + [None]:
      for b in self.elements:
        if a is b: continue
        if (a, b) in solution_steps:
          self.pheromons[a, b] = bounded(
            (1 - self.evaporation_rate) * self.pheromons[a, b] + 1.0 / cost,
            self.pheromon_min,
            self.pheromon_max,
          )
        else:
          self.pheromons[a, b] = max(
            (1 - self.evaporation_rate) * self.pheromons[a, b],
            self.pheromon_min,
          )
      
  def get_best_position(self): return self.best_solution
  
  def get_lowest_cost(self):   return self.best_cost
