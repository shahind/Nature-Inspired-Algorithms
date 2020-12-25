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

from __future__ import print_function

import sys, random

import metaheuristic_optimizer
import metaheuristic_optimizer.artificial_bee_colony
import metaheuristic_optimizer.artificial_feeding_birds
import metaheuristic_optimizer.firefly_algorithm
from metaheuristic_optimizer.bench_functions import *


class Params(object):
  def __init__(self, cost_func, **kargs):
    self.cost_func = cost_func
    self.__dict__.update(kargs)
    
sphere_params = Params(
  sphere,
  nb_dimension =  5, min_x = -100.0, max_x = 100.0, delta_x = 0.5,
  max_trial = 100,
  chance_join_other = 0.1, chance_memory = 0.7, fly_limit = 4,
)
pics4_params = Params(
  pics4,
  nb_dimension =  2, min_x = -5.0, max_x = 5.0,
  max_trial = 100,
)
rosenbrock_params = Params(
  rosenbrock,
  nb_dimension = 2, min_x = -2.048, max_x = 2.048, delta_x = 0.02,
  max_trial = 100,
  chance_join_other = 0.75, fly_limit = 4,
)
rastrigin_params = Params(
  rastrigin,
  nb_dimension = 10, min_x = -600.0, max_x = 600.0, delta_x = 8.0,
  max_trial = 100,
  chance_join_other = 0.9, fly_limit = 1,
)
himmelblau_params = Params(
  himmelblau,
  nb_dimension = 2, min_x = -6.0, max_x = 6.0, delta_x = 0.1,
  max_trial = 100,
  chance_join_other = 0.8, fly_limit = 2,
)
eggholder_params = Params(
  eggholder,
  nb_dimension = 2, min_x = -512.0, max_x = 512.0, delta_x = 2.0,
  max_trial = 100,
  chance_join_other = 0.1, chance_memory = 0.7, fly_limit = 4,
)
xor6_sin_params = Params(
  xor6_sin,
  nb_dimension = 6, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
  chance_join_other = 0.2, fly_limit = 4, nb_bird = 10, chance_memory = 0.4,
)
xor6_sig_params = Params(
  xor6_sig,
  nb_dimension = 6, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
  chance_join_other = 0.2, fly_limit = 4, nb_bird = 10, chance_memory = 0.4,
)
xor9_params = Params(
  xor9,
  nb_dimension = 9, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
  chance_join_other = 0.8, fly_limit = 10, nb_bird = 10,
)


def create_cost(params):
  def cost(p):
    algo = metaheuristic_optimizer.firefly_algorithm.NumericAlgorithm(
      params.cost_func, params.nb_dimension, params.min_x, params.max_x,
      alpha      = p[0],
      alpha_fade = p[1],
      beta       = p[2],
      gamma      = p[3] * 10.0,
    )
    x = algo.multiple_run(5, nb_tested_solution = 40000)
    return x.mean
  return cost


last_pos = None
def dump(algo):
  global last_pos
  best = algo.get_best_position()
  
  if best == last_pos: return
  last_pos = best
  
  print("Best results: ", algo.get_lowest_cost())
  print("Params:")
  print("  alpha      : ", best[0])
  print("  alpha fade : ", best[1])
  print("  beta       : ", best[2])
  print("  gamma      : ", best[3] * 10.0)
  print()


if len(sys.argv) > 1:
  params = globals()["%s_params" % sys.argv[-1]]
  cost = create_cost(params)
  
  print()
  print("Initializing birds...")
  
  algo = metaheuristic_optimizer.artificial_feeding_birds.NumericAlgorithm(cost, 4, 0.0, 1.0)
  
  print()
  
  nb_iter = algo.run(print_func = dump)
  
  print(nb_iter, "iterations")
  dump(algo)
  
else:
  for params in [sphere_params, rosenbrock_params, rastrigin_params, eggholder_params, xor6_sin_params, xor6_sig_params]:
    print(params.cost_func.__name__)
    cost = create_cost(params)
    algo = metaheuristic_optimizer.artificial_feeding_birds.NumericAlgorithm(cost, 4, 0.0, 1.0)
    nb_iter = algo.run(nb_tested_solution = 1000)
    print(nb_iter, "iterations")
    dump(algo)
    print()
    
