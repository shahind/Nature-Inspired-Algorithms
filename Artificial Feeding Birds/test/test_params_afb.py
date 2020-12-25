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
)
rastrigin_params = Params(
  rastrigin,
  nb_dimension = 10, min_x = -600.0, max_x = 600.0, delta_x = 8.0,
  max_trial = 100,
)
himmelblau_params = Params(
  himmelblau,
  nb_dimension = 2, min_x = -6.0, max_x = 6.0, delta_x = 0.1,
  max_trial = 100,
)
eggholder_params = Params(
  eggholder,
  nb_dimension = 2, min_x = -512.0, max_x = 512.0, delta_x = 2.0,
  max_trial = 100,
)
xor6_sin_params = Params(
  xor6_sin,
  nb_dimension = 6, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
)
xor6_sig_params = Params(
  xor6_sig,
  nb_dimension = 6, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
)
xor9_params = Params(
  xor9,
  nb_dimension = 9, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
)


def create_cost(params):
  def cost(p):
    algo = metaheuristic_optimizer.artificial_feeding_birds.NumericAlgorithm(
      params.cost_func, params.nb_dimension, params.min_x, params.max_x,
      chance_walk          = p[0],
      chance_fly           = p[1],
      chance_join_other    = p[2],
      chance_memory        = p[3],
      #nb = max(3, int(p[4] * 50)),
    )
    #x = algo.multiple_run(20, nb_tested_solution = 10000)
    x = algo.multiple_run(20, nb_tested_solution = 40000)
    return x.mean
  return cost


last_pos = None
def dump(algo):
  global last_pos
  best = algo.get_best_position()
  
  if best == last_pos: return
  last_pos = best
  
  chance_walk        = best[0]
  chance_fly         = best[1]
  chance_join_other  = best[2]
  chance_memory      = best[3]
  total = chance_walk + chance_fly + chance_join_other + chance_memory
  chance_walk       /= total
  chance_fly        /= total
  chance_join_other /= total
  chance_memory     /= total
  #nb                 = max(3, int(best[4] * 50))
  
  print("Best results: ", algo.get_lowest_cost())
  print("Params:")
  print("  chance_walk       : ", chance_walk)
  print("  chance_fly        : ", chance_fly)
  print("  chance_memory     : ", chance_memory)
  print("  chance_join_other : ", chance_join_other)
  #print("  nb                : ", nb)
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
    
