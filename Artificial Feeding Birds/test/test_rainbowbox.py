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

import random, time, math
from rainbowbox import *
from rainbowbox.order_elements import best_elements_order_optim

import metaheuristic_optimizer
import metaheuristic_optimizer.genetic_algorithm
import metaheuristic_optimizer.ant_colony_optimization
import metaheuristic_optimizer.artificial_feeding_birds


# Small random datasets
NB_ELEMENT    = 20
NB_SET        = 8
NB_RELATION   = 30
NB_TESTED_SOL = 10000

# Large random datasets
#NB_ELEMENT    = 30
#NB_SET        = 15
#NB_RELATION   = 60
#NB_TESTED_SOL = 40000

NB_TEST       = 100

rb_random = random.Random(6)

def random_rb_dataset():
  elements = [Element(None, "el<br/>%s" % (i+1))
              for i in range(NB_ELEMENT)
  ]
  sets = [Property(None, "set %s" % (i+1))
          for i in range(NB_SET)
  ]
  relations = set()
  while len(relations) < NB_RELATION:
    relations.add((rb_random.choice(elements), rb_random.choice(sets)))
  relations = [Relation(e, s) for (e, s) in relations]
  
  return elements, sets, relations

def bench_module(optim_module):
  print(optim_module.__name__)
  total_holes = 0
  total_time  = 0.0
  costs       = []
  for i in range(NB_TEST):
    #print(i)
    elements, sets, relations = random_rb_dataset()
    t0 = time.time()
    lowest_cost  = best_elements_order_optim(relations, elements, nb_tested_solution = NB_TESTED_SOL, optim_module = optim_module, bench = True)
    total_time  += time.time() - t0
    if isinstance(lowest_cost, tuple): lowest_cost = lowest_cost[0]
    total_holes += lowest_cost
    costs.append(lowest_cost)
    
  mean = total_holes / NB_TEST
  std  = math.sqrt(sum(((cost - mean) ** 2) / NB_TEST for cost in costs))
  
  print("""Results of %s runs:
mean: %s std: %s
mean time: %.3fs

""" % (NB_TEST, mean, std, total_time / NB_TEST))


elements, sets, relations = random_rb_dataset()
html_page = HTMLPage()
html_page.rainbowbox(relations)
html_page.show(100)

#bench_module(metaheuristic_optimizer.artificial_feeding_birds)
#bench_module(metaheuristic_optimizer.genetic_algorithm)
#bench_module(metaheuristic_optimizer.ant_colony_optimization)
