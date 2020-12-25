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

import random, math

import metaheuristic_optimizer


def distance(x, y):
  squarred = 0.0
  for k in range(len(x)):
    squarred += (x[k] - y[k]) ** 2
  return math.sqrt(squarred)


class Firefly(object):
  def __init__(self, algo, position = None):
    self.algo        = algo
    self.position    = position or [random.uniform(algo.min_x, algo.max_x) for d in range(algo.nb_dimension)]
    self.cost        = algo.cost_func(self.position)
    
  def attracted_by(self, other):
    r = distance(self.position, other.position)
    attractiveness = self.algo.beta * math.exp(-self.algo.gamma * (r ** 2))
    
    for k in range(self.algo.nb_dimension):
      self.position[k] += (attractiveness * (other.position[k] - self.position[k])
                       +   self.algo.current_alpha * (self.algo.max_x - self.algo.min_x)
                                                   *  random.gauss(0.0, 1.0) )
      if   self.position[k] < self.algo.min_x: self.position[k] = self.algo.min_x
      elif self.position[k] > self.algo.max_x: self.position[k] = self.algo.max_x
      
      
class NumericAlgorithm(metaheuristic_optimizer.Algorithm):
  def __init__(self, cost_func, nb_dimension = 2, min_x = -100.0, max_x = 100.0,
#               nb = 20, alpha = 0.37, alpha_fade = 0.98, beta = 0.91, gamma = 0.0):
               nb = 20, alpha = 0.268272289484, alpha_fade = 1.0, beta = 0.127545231065, gamma = 9.99937965334):
#               nb = 20, alpha = 0.0219667520894, alpha_fade = 1.0, beta = 0.441708475807, gamma = 3.41274335871): #Rosenbrock
    self.min_x = min_x
    self.max_x = max_x
    
    self.nb_dimension = nb_dimension
    self.nb_firefly = nb
    
    self.alpha      = alpha
    self.alpha_fade = alpha_fade
    self.beta       = beta
    self.gamma      = gamma
    
    metaheuristic_optimizer.Algorithm.__init__(self, cost_func)
    
  def reset(self):
    metaheuristic_optimizer.Algorithm.reset(self)
    self.current_iteration = 0
    self.fireflies = [Firefly(self) for i in range(self.nb_firefly)]
    self.lowest_cost   = float("inf")
    self.best_position = None
    
  def iterate(self):
    self.current_iteration += 1
    self.current_alpha = self.alpha * (self.alpha_fade ** self.current_iteration)
    self.fireflies.sort(key = lambda firefly: firefly.cost)
    
    for i in range(len(self.fireflies)):
      self.fireflies[i].changed = False
      for j in range(i):
        if self.fireflies[j].cost < self.fireflies[i].cost:
          self.fireflies[i].attracted_by(self.fireflies[j])
          self.fireflies[i].changed = True
          
    no_change = True
    for firefly in self.fireflies:
      if firefly.changed:
        no_change = False
        self.fireflies[i].cost = self.cost_func(self.fireflies[i].position)
        
        if firefly.cost < self.lowest_cost:
          self.lowest_cost   = firefly.cost
          self.best_position = list(firefly.position)

    if no_change: raise StopIteration
          
  def get_best_position(self): return self.best_position
  def get_lowest_cost  (self): return self.lowest_cost
  
  





