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
import metaheuristic_optimizer.genetic_algorithm
import metaheuristic_optimizer.ant_colony_optimization
import metaheuristic_optimizer.artificial_feeding_birds
from metaheuristic_optimizer.bench_functions import *

NB = 50

tsp = wan14_tsp
#tsp = fri26_tsp

print("AFB")
algo = metaheuristic_optimizer.artificial_feeding_birds.OrderingAlgorithm(tsp.cities, tsp)
x = algo.multiple_run(NB, nb_tested_solution = 40000)
print(x)


print("GA")
algo = metaheuristic_optimizer.genetic_algorithm.OrderingAlgorithm(
  tsp.cities, tsp,
  local_improvement = False,
)
x = algo.multiple_run(NB, nb_tested_solution = 40000)
print(x)

print()
print()

print("GA + local improvement")
algo = metaheuristic_optimizer.genetic_algorithm.OrderingAlgorithm(
  tsp.cities, tsp,
  local_improvement = True,
)
x = algo.multiple_run(NB, nb_tested_solution = 40000)
print(x)

print()
print()

print("ACO")
algo = metaheuristic_optimizer.ant_colony_optimization.OrderingAlgorithm(tsp.cities, tsp,
  nb_ant = 4,
  evaporation_rate = 0.00615251356311,
  pheromon_default = 0.67058954196,
  pheromon_min     = 0.0,
  pheromon_max     = 0.499364786193,
)
x = algo.multiple_run(NB, nb_tested_solution = 40000)
print(x)

print()
print()


