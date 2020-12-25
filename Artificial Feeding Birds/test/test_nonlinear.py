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
  alpha = 0.37, alpha_fade = 0.98, beta = 0.91, gamma = 0.0
)
rosenbrock_params = Params(
  rosenbrock,
  nb_dimension = 2, min_x = -2.048, max_x = 2.048, delta_x = 0.02,
  max_trial = 100,
  alpha = 0.0219667520894, alpha_fade = 1.0, beta = 0.441708475807, gamma = 3.41274335871
)
rastrigin_params = Params(
  rastrigin,
  nb_dimension = 10, min_x = -600.0, max_x = 600.0, delta_x = 8.0,
  max_trial = 100,
  alpha = 0.37, alpha_fade = 0.98, beta = 0.91, gamma = 0.0
)
himmelblau_params = Params(
  himmelblau,
  nb_dimension = 2, min_x = -600.0, max_x = 600.0, delta_x = 0.1,
  max_trial = 100,
  alpha = 0.37, alpha_fade = 0.98, beta = 0.91, gamma = 0.0
)
eggholder_params = Params(
  eggholder,
  nb_dimension = 2, min_x = -512.0, max_x = 512.0, delta_x = 2.0,
  max_trial = 100,
  alpha = 0.268272289484, alpha_fade = 1.0, beta = 0.127545231065, gamma = 9.80678367882
)
xor6_sin_params = Params(
  xor6_sin,
  nb_dimension = 6, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
  alpha = 0.37, alpha_fade = 0.98, beta = 0.91, gamma = 0.0
)
xor6_sig_params = Params(
  xor6_sig,
  nb_dimension = 6, min_x = -100.0, max_x = 100.0, delta_x = 10.0,
  max_trial = 100,
  alpha = 0.37, alpha_fade = 0.98, beta = 0.91, gamma = 0.0
)

nb_tested_solution = 40000
nb_run             = 50


def test(params):
  print()
  print(params.cost_func.__name__)
  
  print("AFB")
  algo = metaheuristic_optimizer.artificial_feeding_birds.NumericAlgorithm(
    params.cost_func, params.nb_dimension, params.min_x, params.max_x)
  x = algo.multiple_run(nb_run, nb_tested_solution = nb_tested_solution)
  print(str(x))
  
  print("ABC")
  algo = metaheuristic_optimizer.artificial_bee_colony.NumericAlgorithm(
    params.cost_func, params.nb_dimension, params.min_x, params.max_x, max_trial = params.max_trial)
  x = algo.multiple_run(nb_run, nb_tested_solution = nb_tested_solution)
  print(str(x))
  
  print("Firefly")
  algo = metaheuristic_optimizer.firefly_algorithm.NumericAlgorithm(
    params.cost_func, params.nb_dimension, params.min_x, params.max_x,
    alpha = params.alpha, alpha_fade = params.alpha_fade, beta = params.beta, gamma = params.gamma
  )
  x = algo.multiple_run(nb_run, nb_tested_solution = nb_tested_solution)
  print(str(x))
  

test(sphere_params)
test(rosenbrock_params)
test(rastrigin_params)
test(eggholder_params)
test(himmelblau_params)
test(xor6_sin_params)
test(xor6_sig_params)

print()
print()

