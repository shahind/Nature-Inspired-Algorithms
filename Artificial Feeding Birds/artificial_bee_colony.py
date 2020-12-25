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

import random

import metaheuristic_optimizer


def calculate_fitness(x):
  if x >= 0: return 1.0 / (x + 1)
  else:      return 1.0 + abs(x)

  
class FoodSource(object):
  def __init__(self, algo, position = None):
    self.algo        = algo
    self.position    = position or [random.uniform(algo.min_x, algo.max_x) for d in range(algo.nb_dimension)]
    self.cost        = algo.cost_func(self.position)
    self.fitness     = calculate_fitness(self.cost)
    self.nb_trial    = 0
    self.probability = 0.0

    
class NumericAlgorithm(metaheuristic_optimizer.Algorithm):
  def __init__(self, cost_func, nb_dimension = 2, min_x = -100.0, max_x = 100.0, nb = 20, max_trial = None):
    self.min_x = min_x
    self.max_x = max_x
    
    self.nb_dimension = nb_dimension
    self.nb_bee = nb
    self.nb_food_source = nb // 2
    self.max_trial = max_trial or (self.nb_bee - self.nb_food_source) * nb_dimension
    
    metaheuristic_optimizer.Algorithm.__init__(self, cost_func)
    
  def reset(self):
    metaheuristic_optimizer.Algorithm.reset(self)
    self.food_sources = [FoodSource(self) for i in range(self.nb_food_source)]
    self.best_food_source = self.food_sources[0]
    
    self.last_moves = [
      (1, food_source.position, food_source.position)
      for food_source in self.food_sources
      ]
    
  def iterate(self):
    self.last_moves = []
    
    self.iterate_employees()
    self.iterate_onlookers()
    self.iterate_scouts()
    
    for food_source in self.food_sources:
      if food_source.fitness > self.best_food_source.fitness:
        self.best_food_source = food_source
    
  def iterate_employees(self):
    for food_source in self.food_sources:
      self.visit_food_source(food_source, 1)
      
  def iterate_onlookers(self):
    self.compute_probabilities()
    
    b = 0
    i = 0
    while(b < self.nb_bee - self.nb_food_source):
      if random.random() < self.food_sources[i].probability:
        b += 1
        if self.visit_food_source(self.food_sources[i], 2):
          self.compute_probabilities()
          
      i += 1
      if i >= len(self.food_sources): i = 0
      
  def iterate_scouts(self):
    most_tried_source_food = self.food_sources[0]
    for food_source in self.food_sources:
      if food_source.nb_trial > most_tried_source_food.nb_trial:
        most_tried_source_food = food_source
    if most_tried_source_food.nb_trial > self.max_trial:
      i = self.food_sources.index(most_tried_source_food)
      old_pos = self.food_sources[i].position
      self.food_sources[i] = FoodSource(self)
      self.last_moves.append((3, old_pos, self.food_sources[i].position))
      
  def visit_food_source(self, food_source, mode):
    d = random.randint(0, self.nb_dimension - 1)
    
    neighbour_source = random.choice(self.food_sources)
    while neighbour_source is food_source:
      neighbour_source = random.choice(self.food_sources)
      
    p = food_source.position[:]
    p[d] = p[d] + (food_source.position[d] - neighbour_source.position[d]) * random.uniform(-1.0, 1.0)
    if   p[d] < self.min_x: p[d] = self.min_x
    elif p[d] > self.max_x: p[d] = self.max_x
    new_food_source = FoodSource(self, p)
    
    if new_food_source.cost < food_source.cost:
      new_food_source.probability = food_source.probability
      i = self.food_sources.index(food_source)
      self.food_sources[i] = new_food_source
      self.last_moves.append((mode, food_source.position, new_food_source.position))
      return True
    else:
      food_source.nb_trial += 1
      self.last_moves.append((mode, new_food_source.position, food_source.position))
      return False
    
    
  def compute_probabilities(self):
    max_fitness = max(food_source.fitness for food_source in self.food_sources)
    for food_source in self.food_sources:
      food_source.probability = 0.9 * (food_source.fitness / max_fitness) + 0.1
      
  def get_best_food_source(self): return self.best_food_source
  
  def get_best_position(self): return self.get_best_food_source().position
  def get_lowest_cost  (self): return self.get_best_food_source().cost
  
  





