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


class Bird(object):
  def __init__(self, algo, i):
    self.algo        = algo
    self.position    = self.best_position  = algo.fly()
    self.cost        = self.best_cost      = algo.cost_func(self.position)
    self.iteration   = self.best_iteration = 1
    self.last_move   = 2
    if   i <= algo.nb_bird * 0.75: self.size = 0
    else:                          self.size = 1
    
    
  def iterate(self):
    self.iteration += 1
    
    if (self.last_move != 1) or (self.cost == self.best_cost):
      r = 1.0
    else:
      if self.size == 0: r = random.uniform(self.algo.chance_join_other, 1.0)
      else:              r = random.random()
      
    if   r >= self.algo.chance_fly + self.algo.chance_memory + self.algo.chance_join_other:
      self.last_move = 1
      self.position  = self.algo.walk(self)
      self.cost      = self.algo.cost_func(self.position)
      
    elif r >= self.algo.chance_memory + self.algo.chance_join_other:
      self.last_move = 2
      self.position  = self.algo.fly()
      self.cost      = self.algo.cost_func(self.position)
      
    elif r >= self.algo.chance_join_other:
      self.last_move = 3
      self.position  = self.best_position[:]
      self.cost      = self.best_cost
      
    else:
      other = random.choice(self.algo.birds)
      while other is self:
        other = random.choice(self.algo.birds)
        
      self.last_move = 4
      self.position  = other.position[:]
      self.cost      = other.cost
      
    if self.cost <= self.best_cost:
      if self.cost < self.best_cost:
        self.best_iteration = self.iteration
      self.best_position  = self.position
      self.best_cost      = self.cost

class MetaHeuristic(metaheuristic_optimizer.Algorithm):
  def __init__(self, cost_func, nb = 20, chance_walk = None, chance_fly = 0.01, chance_join_other = 0.07, chance_memory = 0.67):
    self.nb_bird             = nb
    if chance_walk is None:
      self.chance_fly        = chance_fly
      self.chance_join_other = chance_join_other
      self.chance_memory     = chance_memory
    else:
      total = chance_walk + chance_fly + chance_join_other + chance_memory
      self.chance_fly        = chance_fly        / total
      self.chance_join_other = chance_join_other / total
      self.chance_memory     = chance_memory     / total
      
    metaheuristic_optimizer.Algorithm.__init__(self, cost_func)
    
  def reset(self):
    metaheuristic_optimizer.Algorithm.reset(self)
    self.birds = [Bird(self, i + 1) for i in range(self.nb_bird)]
    
  def iterate(self):
    for bird in self.birds: bird.iterate()
    
  def get_best_bird(self):
    best_bird = self.birds[0]
    for bird in self.birds:
      if bird.best_cost < best_bird.best_cost: best_bird = bird
    return best_bird
  
  def get_best_position (self): return self.get_best_bird().best_position
  def get_lowest_cost   (self): return self.get_best_bird().best_cost
  def get_best_iteration(self): return self.get_best_bird().best_iteration


  def adaptative_2opt(self, bird, bird_2_x): # 2-opt variants (IAF2017)
    x = list(bird_2_x(bird))
    
    for z in range(100):
      other = random.choice(self.birds)
      while other is bird:
        other = random.choice(self.birds)
        
      i = random.randint(0, len(x) - 1)
      
      ref = bird_2_x(other)
      d = ref.index(x[i]) - ref.index(x[i - 1])
      if 1 < abs(d) < (len(x) - 1): break
      
    else:
      if len(x) < 4:
        d = 2
      else:
        d = random.randint(2, len(x) - 2)
        
    j = (i + d) % len(x)
    if j < i: i, j = j, i
    
    x[i:j] = reversed(x[i:j])
    
    return x  
  
  

  
class NumericAlgorithm(MetaHeuristic):
  def __init__(self, cost_func, nb_dimension = 2, min_x = -100.0, max_x = 100.0, nb = 20, chance_walk = None, chance_fly = 0.01, chance_join_other = 0.07, chance_memory = 0.67):
    self.nb_dimension = nb_dimension
    self.min_x = min_x
    self.max_x = max_x
    
    MetaHeuristic.__init__(self, cost_func, nb, chance_walk, chance_fly, chance_join_other, chance_memory)
    
  def fly(self):
    return [random.uniform(self.min_x, self.max_x) for d in range(self.nb_dimension)]
    
  def walk(self, bird):
    p2 = bird.position[:]
    d = random.randint(0, self.nb_dimension - 1)
    
    n = random.choice(self.birds)
    while n is bird:
      n = random.choice(self.birds)
      
    delta = abs(p2[d] - n.position[d])
    
    if delta == 0.0: delta = 0.001
    
    p2[d] = p2[d] + delta * random.uniform(-1.0, 1.0)
    if   p2[d] < self.min_x: p2[d] = self.min_x
    elif p2[d] > self.max_x: p2[d] = self.max_x
    return p2
  

class CyclicNumericAlgorithm(NumericAlgorithm):
  def __init__(self, cost_func, nb_dimension = 2, min_x = -100.0, max_x = 100.0, nb = 20, chance_walk = None, chance_fly = 0.01, chance_join_other = 0.07, chance_memory = 0.67):
    NumericAlgorithm.__init__(self, cost_func, nb_dimension, min_x, max_x, nb, chance_walk, chance_fly, chance_join_other, chance_memory)
    self.range_x = self.max_x - self.min_x
    
  def walk(self, bird):
    p2 = bird.position[:]
    d = random.randint(0, self.nb_dimension - 1)
    
    n = random.choice(self.birds)
    while n is bird:
      n = random.choice(self.birds)
      
    delta = abs(p2[d] - n.position[d])
    #delta2 = abs(delta - self.range_x)
    #if delta2 < delta: delta = delta2
    
    if delta == 0.0: delta = 0.001
    
    p2[d] = p2[d] + delta * random.uniform(-1.0, 1.0)
    if   p2[d] < self.min_x: p2[d] += self.range_x
    elif p2[d] > self.max_x: p2[d] -= self.range_x
    return p2

  
class OrderingAlgorithm(MetaHeuristic):
  def __init__(self, elements, tsp, nb = 20, chance_walk = None, chance_fly = 0.01, chance_join_other = 0.07, chance_memory = 0.67):
    self.tsp      = tsp
    self.elements = elements
    
    MetaHeuristic.__init__(self, tsp, nb, chance_walk, chance_fly, chance_join_other, chance_memory)
    
  def fly(self):
    x = list(self.elements)
    random.shuffle(x)
    return x
  
  def walk(self, bird):
    x = list(bird.position)
    i = random.randint(0, len(x) - 1)
    j = random.randint(0, len(x) - 1)
    while j == i:
      j = random.randint(0, len(x) - 1)
      
    x[i:j] = reversed(x[i:j])
    return x

  def walk(self, bird): # 2-opt variants (IAF2017)
    x = list(bird.position)
    
    for z in range(100):
      other = random.choice(self.birds)
      while other is bird:
        other = random.choice(self.birds)
        
      i = random.randint(0, len(x) - 1)
        
      d = other.position.index(x[i]) - other.position.index(x[i - 1])
      if 1 < abs(d) < (len(x) - 1): break
      
    else:
      if len(x) < 4:
        d = 2
      else:
        d = random.randint(2, len(x) - 2)
      
    j = (i + d) % len(x)
    if j < i: i, j = j, i

    x[i:j] = reversed(x[i:j])
    
    return x  
  
